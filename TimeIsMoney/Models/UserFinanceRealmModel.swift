//
//
// TimeIsMoney
// UserFinanceRealmModel.swift
//
// Created by Alexander Kist on 16.11.2023.
//

import Foundation
import RealmSwift

class UserFinanceRealmModel: Object {
    @objc dynamic var id = "single_user_id"
    @objc dynamic var salary: Double = 0
    @objc dynamic var monthlyExpenses: Double = 0
    let dailyExpenses = List<DailyExpenseRealmModel>()

    override static func primaryKey() -> String? {
        return "id"
    }
}
class DailyExpenseRealmModel: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var cost: Double = 0
    @objc dynamic var date = Date()

    override static func primaryKey() -> String? {
        return "id"
    }
}
