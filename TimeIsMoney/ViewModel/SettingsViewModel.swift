//
//
// TimeIsMoney
// SettingsViewModel.swift
// 
// Created by Alexander Kist on 26.11.2023.
//

import RealmSwift

final class SettingsViewModel {

    private enum Constants {
        static let userPrimaryKey: String = "single_user_id"
    }

    private var salary: Double {
        return data?.salary ?? 0.0
    }

    private var monthlyExpenses: Double {
        return data?.monthlyExpenses ?? 0.0
    }

    private var data: UserFinanceModel?

    private let realm: Realm?

    init() {
        do {
            realm = try Realm()
        } catch let error {
            print("Failed to instantiate Realm: \(error.localizedDescription)")
            realm = nil
        }
    }
    func handleUpdatedData(salary: String?, expenses: String?) {
        var newSalary: Double?
        var newExpenses: Double?

        if let salaryText = salary {
            newSalary = Double(salaryText)
        }

        if let expensesText = expenses {
            newExpenses = Double(expensesText)
        }

        guard newSalary != nil || newExpenses != nil else { return }

        updateSalaryAndExpenses(salary: newSalary ?? Double(self.salary), monthlyExpenses: newExpenses ?? self.monthlyExpenses)
    }

    func deleteAllDailyExpenses() {
        do {
            try realm?.write {
                if let userFinance = realm?.object(ofType: UserFinanceRealmModel.self, forPrimaryKey: Constants.userPrimaryKey) {
                    userFinance.dailyExpenses.removeAll()
                } else {
                    print("Объект UserFinanceRealmModel не найден")
                }
            }

        } catch {
            print("Ошибка удаления ежедневных расходов: \(error.localizedDescription)")
        }
    }

    private func updateSalaryAndExpenses(salary: Double, monthlyExpenses: Double) {
        do {
            try realm?.write {
                if let userFinance = realm?.object(ofType: UserFinanceRealmModel.self, forPrimaryKey: Constants.userPrimaryKey) {
                    userFinance.salary = salary
                    userFinance.monthlyExpenses = monthlyExpenses
                } else {
                    print("Объект UserFinanceRealmModel не найден")
                }
            }

        } catch {
            print("Ошибка обновления зарплаты и ежемесячных расходов: \(error.localizedDescription)")
        }
    }
}
