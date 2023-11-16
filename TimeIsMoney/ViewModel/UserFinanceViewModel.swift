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
    
    
    weak var delegate: UserFinanceViewModelDelegate?
    
    private var data: UserFinanceModel?
    
    private let realm: Realm?
    
    init() {
        do {
            realm = try Realm()
        } catch let error {
            print("Failed to instantiate Realm: \(error)")
            realm = nil
        }
    }
    
    var salary: Double {
        return data?.salary ?? 0.0
    }
    
    var monthlyExpenses: Double {
        return data?.monthlyExpenses ?? 0.0
    }
    var availableMoney: Double {
        return data?.availableMoney ?? 0.0
    }
    
    var earnedMoney: Double {
        return data?.earnedMoney().rounding(toPlaces: 2) ?? 0.0
    }
    
    var dailyExpenses: [DailyExpense] {
        return data?.dailyExpenses ?? []
    }
    
    func setData(salary: Double, monthlyExpenses: Double, dailyExpenses: [DailyExpense]){
        data = UserFinanceModel(salary: salary, monthlyExpenses: monthlyExpenses, dailyExpenses: dailyExpenses)
        
        
        do {
            try saveToRealm()
            self.delegate?.didUpdatedData()
        } catch UserFinanceError.failedToSaveData {
            print("Ошибка сохранения данных в базу данных")
        } catch {
            print("Неизвестная ошибка: \(error.localizedDescription)")
        }
    }
    
    func loadData(){
        do {
            try loadFromRealm()
        } catch UserFinanceError.failedToLoadData {
            print("Ошибка загрузки данных")
        } catch {
            print("Неизвестная ошибка: (error.localizedDescription)")
        }
    }
}
extension UserFinanceViewModel {
    private func saveToRealm() throws {
        guard let data = data else {
            throw UserFinanceError.dataNotFound
        }
        
        
        let realmModel = UserFinanceRealmModel()
        realmModel.salary = data.salary
        realmModel.monthlyExpenses = data.monthlyExpenses
        
        realmModel.dailyExpenses.append(objectsIn: data.dailyExpenses.map { dailyExpense in
            let realmDailyExpense = DailyExpenseRealmModel()
            realmDailyExpense.type = dailyExpense.type
        realmDailyExpense.amount = dailyExpense.amount
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
        
        let dailyExpenses = realmModel.dailyExpenses.map { DailyExpense(type: $0.type, amount: $0.amount, date: $0.date) }
        
        data = UserFinanceModel(salary: realmModel.salary, monthlyExpenses: realmModel.monthlyExpenses, dailyExpenses: Array(dailyExpenses))
        print("Информация успешно получена со значениями зп: \(realmModel.salary),траты: \(realmModel.monthlyExpenses), и дневными тратами: \(realmModel.dailyExpenses)")
    }
}
