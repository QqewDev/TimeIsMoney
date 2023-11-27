//
//
// TimeIsMoney
// UserFinanceViewModel.swift
//
// Created by Alexander Kist on 16.11.2023.
//

import Foundation
import RealmSwift
import UserNotifications

private enum RealmDBError: Error {
    case dataNotFound
    case failedToSaveData
    case failedToLoadData
}

protocol UserFinanceViewModelDelegate: AnyObject {
    func didUpdatedData()
    func didGetPermissionForNotify()
}
final class UserFinanceViewModel: NotificationManagerDelegate {
    func didGetPermission() {
        delegate?.didGetPermissionForNotify()
    }
    

    init(notificationManager: NotificationManager) {
        self.notificationManager = notificationManager
        do {
            realm = try Realm()
        } catch let error {
            print("Failed to instantiate Realm: \(error.localizedDescription)")
            realm = nil
        }
        self.notificationManager.delegate = self
    }

    func requestNotificationsPermission() {
        notificationManager.requestNotificationsPermission()
    }

    private enum Constants {
        static let userPrimaryKey: String = "single_user_id"
    }

    // MARK: - Public variables
    weak var delegate: UserFinanceViewModelDelegate?

    private let notificationManager: NotificationManager

    public var salary: Double {
        return data?.salary ?? 0.0
    }

    public var monthlyExpenses: Double {
        return data?.monthlyExpenses ?? 0.0
    }
    public var availableMoney: Double {
        return (data?.salary ?? 0.0) - (data?.monthlyExpenses ?? 0.0) - additionalExpenses
    }

    public var earnedMoney: Double {
        return data?.earnedMoney().rounding(toPlaces: 2) ?? 0.0
    }

    public var dailyExpenses: [DailyExpense] {
        return data?.dailyExpenses ?? []
    }

    public var isNotificationsAllowed: Bool {
      return notificationManager.isNotificationsAllowed
    }
    
    private var additionalExpenses: Double {
        return data?.dailyExpenses.reduce(0, { $0 + $1.cost }) ?? 0.0
    }

    private var data: UserFinanceModel?

    private let realm: Realm?

    // MARK: - Init Realm


    // MARK: - Public methods
    func handleInputData(salary: String?, expenses: String?) {
        guard let salaryText = salary,
              let expensesText = expenses else { return }

        guard let salaryDouble = Double(salaryText),
              let expensesDouble = Double(expensesText) else { return }

        setData(salary: salaryDouble, monthlyExpenses: expensesDouble, newExpense: nil)
        UserDefaults.standard.set(true, forKey: "wasLaunchedBefore")
    }

    func handleAddedExpense(title: String?, cost: String?, purchaseDate: Date?) {
        guard let titleText = title,
              let costText = cost,
              let costDouble = costText.toDoubleUsingComma() else { return }

        guard let purchaseDate = purchaseDate else { return }

        let dailyExpense = DailyExpense(name: titleText, cost: costDouble, date: purchaseDate)
        setData(salary: self.salary, monthlyExpenses: self.monthlyExpenses, newExpense: dailyExpense)
    }

    func loadData() {
        do {
            try loadFromRealm()
            delegate?.didUpdatedData()
        } catch RealmDBError.failedToLoadData {
            print("Ошибка загрузки данных")
        } catch {
            print("Неизвестная ошибка: \(error.localizedDescription)")
        }
    }

    func requestNotifications() {
        notificationManager.requestNotificationsPermission()
    }

    // MARK: - Private Methods
    private func setData(salary: Double, monthlyExpenses: Double, newExpense: DailyExpense?) {
        if data == nil {
            data = UserFinanceModel(salary: salary, monthlyExpenses: monthlyExpenses, dailyExpenses: newExpense != nil ? [newExpense!] : [])
        } else {
            if let expense = newExpense {
                data?.dailyExpenses.append(expense)
            }
        }

        do {
            try saveToRealm()
            self.delegate?.didUpdatedData()
        } catch RealmDBError.failedToSaveData {
            print("Ошибка сохранения данных в базу данных")
        } catch {
            print("Неизвестная ошибка: \(error.localizedDescription)")
        }
    }

    private func saveToRealm() throws {
        guard let data = data else {
            throw RealmDBError.dataNotFound
        }

        let realmModel = UserFinanceRealmModel()
        realmModel.salary = data.salary
        realmModel.monthlyExpenses = data.monthlyExpenses

        realmModel.dailyExpenses.append(objectsIn: data.dailyExpenses.map { dailyExpense in
            let realmDailyExpense = DailyExpenseRealmModel()
            realmDailyExpense.name = dailyExpense.name
            realmDailyExpense.cost = dailyExpense.cost
            realmDailyExpense.date = dailyExpense.date
            return realmDailyExpense
        })

        do {
            try realm?.write {
                realm?.add(realmModel, update: .modified)
            }
        } catch {
            throw RealmDBError.failedToSaveData
        }
    }

    private func loadFromRealm() throws {

        guard let realmModel = realm?.object(ofType: UserFinanceRealmModel.self, forPrimaryKey: Constants.userPrimaryKey) else {
            throw RealmDBError.failedToLoadData
        }

        let dailyExpenses = realmModel.dailyExpenses.map { DailyExpense(name: $0.name, cost: $0.cost, date: $0.date) }

        data = UserFinanceModel(salary: realmModel.salary, monthlyExpenses: realmModel.monthlyExpenses, dailyExpenses: Array(dailyExpenses))
    }
}
