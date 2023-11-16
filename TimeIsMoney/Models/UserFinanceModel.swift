//
//
// TimeIsMoney
// UserFinanceModel.swift
// 
// Created by Alexander Kist on 16.11.2023.
//

import Foundation

struct UserFinanceModel {
    let salary: Double
    let monthlyExpenses: Double
    let dailyExpenses: [DailyExpense]
    let secondsInMonth: Double = 2_592_000
}
struct DailyExpense {
    var type: String
    var amount: Double
    var date: Date
}
extension UserFinanceModel {
    var availableMoney: Double {
        salary - monthlyExpenses
    }
    var moneyPerSecond: Double {
        salary / secondsInMonth
    }
    func earnedMoney() -> Double {
        let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date())) ?? Date()
        let secondsPassed = Date().timeIntervalSince(startOfMonth)
        return moneyPerSecond * secondsPassed
    }
}

