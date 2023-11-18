//
//
// TimeIsMoney
// UserFinanceModel.swift
// 
// Created by Alexander Kist on 16.11.2023.
//

import Foundation

struct UserFinanceModel {
    var salary: Double
    var monthlyExpenses: Double
    var dailyExpenses: [DailyExpense]
    let secondsInMonth: Double = 2_592_000
}
struct DailyExpense {
    var name: String
    var coast: Double
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

