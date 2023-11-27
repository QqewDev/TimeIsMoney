//
//
// TimeIsMoney
// AppCoordinator.swift
// 
// Created by Alexander Kist on 22.11.2023.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {

    var navigationController: UINavigationController

    private var isPreviouslyLaunched: Bool = UserDefaults.standard.bool(forKey: "wasLaunchedBefore")

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showLoginVC()
    }

    func showInputVC() {
        let manager = NotificationManager()
        let viewModel = UserFinanceViewModel(notificationManager: manager)
        let inputVC = InputViewController(viewModel: viewModel)
        inputVC.coordinator = self
        navigationController.pushViewController(inputVC, animated: false)
    }

    func showDetailVC() {
        let manager = NotificationManager()
        let viewModel = UserFinanceViewModel(notificationManager: manager)
        let detailVC = DetailViewController(viewModel: viewModel)
        detailVC.coordinator = self
        navigationController.pushViewController(detailVC, animated: false)
    }

    func showLoginVC() {
        let manager = FirebaseAuthManager()
        let loginVM = LoginViewModel(authManager: manager)
        let loginVC = LoginViewController(viewModel: loginVM)
        loginVC.coordinator = self
        navigationController.viewControllers.removeAll()
        navigationController.pushViewController(loginVC, animated: true)
    }

    func showRegisterVC() {
        let manager = FirebaseAuthManager()
        let registerVM = RegisterViewModel(authManager: manager)
        let registerVC = RegisterViewController(viewModel: registerVM)
        registerVC.coordinator = self
        navigationController.pushViewController(registerVC, animated: true)
    }

    func showSettingsVC() {
        let manager = FirebaseAuthManager()
        let settingsVM = SettingsViewModel(manager: manager)
        let settingsVC = SettingsViewController(viewModel: settingsVM)
        settingsVC.coordinator = self
        navigationController.pushViewController(settingsVC, animated: true)
    }

    func showExpensesList() {
        let viewModel = ExpensesListViewModel()
        let expensesListVC = ExpensesListViewController(viewModel: viewModel)
        expensesListVC.coordinator = self
        navigationController.pushViewController(expensesListVC, animated: true)
    }

    func showAddExpenseVC(viewModel: UserFinanceViewModel) {
        let addExpense = AddExpenseViewController(viewModel: viewModel)
        if let sheet = addExpense.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        navigationController.present(addExpense, animated: true)
    }

    func popViewController() {
        navigationController.popViewController(animated: true)
    }
}
