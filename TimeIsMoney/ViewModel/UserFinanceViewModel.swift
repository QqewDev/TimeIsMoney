//
//
// TimeIsMoney
// UserFinanceViewModel.swift
//
// Created by Alexander Kist on 16.11.2023.
//



import Foundation
import RealmSwift

enum UserFinanceError: Error {
    case dataNotFound
    case failedToSaveData
    case failedToLoadData
}
protocol UserFinanceViewModelDelegate: AnyObject {
    func didUpdatedData()
}
final class UserFinanceViewModel {
    
    //MARK: - Public variables
    weak var delegate: UserFinanceViewModelDelegate?
    
    public var salary: Double {
        return data?.salary ?? 0.0
    }
    
    public var monthlyExpenses: Double {
        return data?.monthlyExpenses ?? 0.0
    }
    public var availableMoney: Double {
        return data?.availableMoney ?? 0.0
    }
    
    public var earnedMoney: Double {
        return data?.earnedMoney().rounding(toPlaces: 2) ?? 0.0
    }
    
    public var dailyExpenses: [DailyExpense] {
        return data?.dailyExpenses ?? []
    }
    
    private var data: UserFinanceModel?
    
    private let realm: Realm?
    
    
    //MARK: - Init Realm
    init() {
        do {
            realm = try Realm()
        } catch let error {
            print("Failed to instantiate Realm: \(error)")
            realm = nil
        }
    }
    
    //MARK: - Public methods
    func handleInputData(salary: String?, expenses: String?) {
        guard let salaryText = salary,
              let expensesText = expenses else { return }
        
        guard let salaryDouble = Double(salaryText),
              let expensesDouble = Double(expensesText) else { return }
        
        setData(salary: salaryDouble, monthlyExpenses: expensesDouble, newExpense: nil)
    }
    
    func handleUpdatedData(salary: String?, expenses: String?) {
        guard let salaryText = salary,
              let expensesText = expenses else { return }
        
        guard let newSalary = Double(salaryText),
              let newExpenses = Double(expensesText) else { return }
        
        updateSalaryAndExpenses(salary: newSalary, monthlyExpenses: newExpenses)
    }
    
    
    func handleAddedExpense(title: String?, cost: String?, purchaseDate: Date?) {
        guard let titleText = title,
              let costText = cost else { return }
        
        guard let costDouble = Double(costText) else { return }
        
        guard let purchaseDate = purchaseDate else { return }
        
        let dailyExpense = DailyExpense(name: titleText, coast: costDouble, date: purchaseDate)
        setData(salary: self.salary, monthlyExpenses: self.monthlyExpenses, newExpense: dailyExpense)
    }
    
    func loadData(){
        do {
            try loadFromRealm()
            delegate?.didUpdatedData()
        } catch UserFinanceError.failedToLoadData {
            print("Ошибка загрузки данных")
        } catch {
            print("Неизвестная ошибка: \(error.localizedDescription)")
        }
    }
    
    //MARK: - Private Methods
    private func setData(salary: Double, monthlyExpenses: Double, newExpense: DailyExpense?){
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
        } catch UserFinanceError.failedToSaveData {
            print("Ошибка сохранения данных в базу данных")
        } catch {
            print("Неизвестная ошибка: \(error.localizedDescription)")
        }
    }
    
    private func updateSalaryAndExpenses(salary: Double, monthlyExpenses: Double) {
        do {
            try realm?.write {
                if let userFinance = realm?.object(ofType: UserFinanceRealmModel.self, forPrimaryKey: "single_user_id") {
                    userFinance.salary = salary
                    userFinance.monthlyExpenses = monthlyExpenses
                    print("Зарплата и ежемесячные расходы успешно обновлены")
                } else {
                    print("Объект UserFinanceRealmModel не найден")
                }
            }
            self.delegate?.didUpdatedData()
        } catch {
            print("Ошибка обновления зарплаты и ежемесячных расходов: \(error.localizedDescription)")
        }
    }
    
    private func saveToRealm() throws {
        guard let data = data else {
            throw UserFinanceError.dataNotFound
        }
        
        
        let realmModel = UserFinanceRealmModel()
        realmModel.salary = data.salary
        realmModel.monthlyExpenses = data.monthlyExpenses
        
        realmModel.dailyExpenses.append(objectsIn: data.dailyExpenses.map { dailyExpense in
            let realmDailyExpense = DailyExpenseRealmModel()
            realmDailyExpense.name = dailyExpense.name
            realmDailyExpense.coast = dailyExpense.coast
            realmDailyExpense.date = dailyExpense.date
            return realmDailyExpense
        })
        
        do {
            try realm?.write {
                realm?.add(realmModel, update: .modified)
                print("Сохранение успешно с \(realmModel.salary), \(realmModel.monthlyExpenses),  и \(realmModel.dailyExpenses)")
            }
        } catch {
            throw UserFinanceError.failedToSaveData
        }
    }
    
    private func loadFromRealm() throws {
        
        guard let realmModel = realm?.object(ofType: UserFinanceRealmModel.self, forPrimaryKey: "single_user_id") else {
            throw UserFinanceError.failedToLoadData
        }
        
        let dailyExpenses = realmModel.dailyExpenses.map { DailyExpense(name: $0.name, coast: $0.coast, date: $0.date) }
        
        data = UserFinanceModel(salary: realmModel.salary, monthlyExpenses: realmModel.monthlyExpenses, dailyExpenses: Array(dailyExpenses))
        print("Информация успешно получена со значениями зп: \(realmModel.salary),траты: \(realmModel.monthlyExpenses), и дневными тратами: \(realmModel.dailyExpenses)")
    }
}
