//
//
// TimeIsMoney
// ExpensesListViewModel.swift
// 
// Created by Alexander Kist on 19.11.2023.
//


import Foundation
import RealmSwift

private enum RealmDBError: Error {
    case failedToLoadData
}

final class ExpensesListViewModel {
    
    var items: [String: [DailyExpenseRealmModel]] = [:]
    
    var uniqueDates: [String] = []

    init() {
        setupData()
    }
    
    private func setupData() {
        do {
            guard let realm = try? Realm(),
                let realmModel = realm.object(ofType: UserFinanceRealmModel.self, forPrimaryKey: "single_user_id")
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
