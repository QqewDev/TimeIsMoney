//
//
// TimeIsMoney
// SettingsViewModel.swift
// 
// Created by Alexander Kist on 26.11.2023.
//

import RealmSwift
import FirebaseAuth

final class SettingsViewModel {
    // MARK: - Init
    init(manager: FirebaseAuthManager) {
        self.manager = manager
        if let actualUid = Auth.auth().currentUser?.uid {
            self.uid = actualUid
        }
        do {
            realm = try Realm()
        } catch let error {
            print("Failed to instantiate Realm: \(error.localizedDescription)")
            realm = nil
        }
    }

    // MARK: - Private properties
    private var manager: FirebaseAuthManager

    private var salary: Double {
        return data?.salary ?? 0.0
    }

    private var monthlyExpenses: Double {
        return data?.monthlyExpenses ?? 0.0
    }

    private var data: UserFinanceModel?

    private let realm: Realm?
    private var uid: String = ""

    // MARK: - Public methods
    func signOut(completion: @escaping (Error?) -> Void) {
        manager.signOut(completion: completion)
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

                if let userFinance = realm?.object(ofType: UserFinanceRealmModel.self, forPrimaryKey: uid) {
                    print("Траты dailyExpenses: \(userFinance.dailyExpenses) для uid: \(uid) найдены")
                    userFinance.dailyExpenses.removeAll()
                    print("Траты dailyExpenses: \(userFinance.dailyExpenses) для uid: \(uid) успешно удалены")
                } else {
                    print("Объект UserFinanceRealmModel не найден")
                }
            }

        } catch {
            print("Ошибка удаления ежедневных расходов: \(error.localizedDescription)")
        }
    }

    // MARK: - Private methods
    private func updateSalaryAndExpenses(salary: Double, monthlyExpenses: Double) {
        do {
            try realm?.write {
                if let userFinance = realm?.object(ofType: UserFinanceRealmModel.self, forPrimaryKey: uid) {
                    userFinance.salary = salary
                    userFinance.monthlyExpenses = monthlyExpenses
                    print("Объект UserFinanceRealmModel найден и успешно обновлен")
                } else {
                    print("Объект UserFinanceRealmModel не найден")
                }
            }
        } catch {
            print("Ошибка обновления зарплаты и ежемесячных расходов: \(error.localizedDescription)")
        }
    }
}
