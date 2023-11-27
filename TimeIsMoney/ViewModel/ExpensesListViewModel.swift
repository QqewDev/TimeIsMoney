//
//
// TimeIsMoney
// ExpensesListViewModel.swift
//
// Created by Alexander Kist on 19.11.2023.
//

import Foundation
import RealmSwift
import FirebaseAuth

private enum RealmDBError: Error {
    case failedToLoadData
}

final class ExpensesListViewModel {

    weak var coordinator : AppCoordinator!

    // MARK: - Public properties
    public  var items: [String: [DailyExpenseRealmModel]] = [:]

    public var uniqueDates: [String] = []

    private var uid: String = ""

    // MARK: - Init
    init() {
        if let actualUid = Auth.auth().currentUser?.uid {
            self.uid = actualUid
        }
        setupData()
    }

    // MARK: - Public methods
    func removeExpenseAtIndexPath(_ indexPath: IndexPath) -> Bool {
        let date = uniqueDates[indexPath.section]
        guard var expensesForDate = items[date] else { return false }

        let expense = expensesForDate[indexPath.row]
        removeExpense(with: expense.id)
        expensesForDate.remove(at: indexPath.row)

        if expensesForDate.isEmpty {
            uniqueDates.remove(at: indexPath.section)
            return true
        } else {
            items[date] = expensesForDate
            return false
        }
    }

    // MARK: - Private methods
    private func removeExpense(with id: String) {
        do {
            guard let realm = try? Realm(),
                  let expense = realm.object(ofType: DailyExpenseRealmModel.self, forPrimaryKey: uid)
            else {
                throw RealmDBError.failedToLoadData
            }

            try realm.write {
                realm.delete(expense)
            }

            setupData()
        } catch {
            print("Error deleting data from db: \(error.localizedDescription)")
        }
    }

    private func setupData() {
        do {
            guard !uid.isEmpty,
                  let realm = try? Realm(),
                  let realmModel = realm.object(ofType: UserFinanceRealmModel.self, forPrimaryKey: uid)
            else {
                throw RealmDBError.failedToLoadData
            }

            let dailyExpenses = Array(realmModel.dailyExpenses)

            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ru_RU")
            dateFormatter.dateStyle = .long

            for expense in dailyExpenses {
                let date = Calendar.current.startOfDay(for: expense.date)
                let formattedDate = dateFormatter.string(from: date)

                if var expensesForDate = items[formattedDate] {
                    expensesForDate.append(expense)
                    items[formattedDate] = expensesForDate
                } else {
                    items[formattedDate] = [expense]
                    uniqueDates.append(formattedDate)
                }
            }
            uniqueDates.sort(by: >)
        } catch {
            print("Error initializing Realm: \(error.localizedDescription)")
        }
    }
}
