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
        let viewModel = UserFinanceViewModel()
        if !isPreviouslyLaunched {
            let inputVC = InputViewController(viewModel: viewModel)
            inputVC.coordinator = self
            navigationController.pushViewController(inputVC, animated: false)
        } else {
            let inputVC = DetailViewController(viewModel: viewModel)
            inputVC.coordinator = self
            navigationController.pushViewController(inputVC, animated: false)
        }
    }

    func showSettings(viewModel: UserFinanceViewModel) {
        let settingsVC = SettingsViewController(viewModel: viewModel)
        settingsVC.coordinator = self
        navigationController.pushViewController(settingsVC, animated: true)
    }

    func showDetail(viewModel: UserFinanceViewModel) {
        let detailVC = DetailViewController(viewModel: viewModel)
        detailVC.coordinator = self
        navigationController.setViewControllers([detailVC], animated: true)
    }

    func showExpensesList() {
        let viewModel = ExpensesListViewModel()
        let expensesListVC = ExpensesListViewController(viewModel: viewModel)
        expensesListVC.coordinator = self
        navigationController.pushViewController(expensesListVC, animated: true)
    }

    func showAddExpense(viewModel: UserFinanceViewModel) {
        let addExpense = AddExpenseViewController(viewModel: viewModel)
        if let sheet = addExpense.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        navigationController.present(addExpense, animated: true)
    }

    func didFinishActions() {
        navigationController.popViewController(animated: true)
    }
}
