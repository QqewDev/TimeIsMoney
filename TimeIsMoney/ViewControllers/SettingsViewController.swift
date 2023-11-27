//
//
// TimeIsMoney
// SettingsViewController.swift
// 
// Created by Alexander Kist on 16.11.2023.
//

import Foundation
import UIKit
import SnapKit

final class SettingsViewController: UIViewController {

    weak var coordinator: AppCoordinator?
    // MARK: - Init
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("")
    }

    // MARK: - Private properties
    private enum Constants {
        static let salaryPlaceholder: String = "Изменить зарплату"
        static let expensesPlaceholder: String = "Изменить ежемесячные траты "
        static let deleteLabel: String = "Удалить историю трат"
        static let saveButtonTitle: String = "Сохранить"
        static let deleteButtonImageName: String = "trash.fill"
        static let viewVerticalOffset: CGFloat = 20
        static let viewHorizontalInset: CGFloat = 20
        static let tFieldHeight: CGFloat = 50
        static let buttonSize: CGFloat = 50
        static let borderWidth: CGFloat = 1
        static let mainColor: UIColor = .mainGreen
        static let bgTextColor: UIColor = .backgroundText
        static let saveButtonTextColor: UIColor = .white
        static let backgroundColor: UIColor = .systemBackground
    }

    private let viewModel: SettingsViewModel

    private let salaryTField = CustomTextField(fieldType: .salary)

    private let expensesTField = CustomTextField(fieldType: .expenses)

    private let deleteLabel = CustomLabel(text: Constants.deleteLabel, isStatic: true, textColor: Constants.bgTextColor)

    private let saveButton = CustomTextButton(title: Constants.saveButtonTitle, hasBackground: true, fontSize: .big)

    private let deleteButton = CustomImageButton(imageName: Constants.deleteButtonImageName, hasTint: true)

    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.backgroundColor
        setupViews()
        setConstraints()
        setupNavBar()
    }

    // MARK: - Private methods
    private func setConstraints() {
        salaryTField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.viewVerticalOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.viewHorizontalInset)
            make.height.equalTo(Constants.tFieldHeight)
        }

        expensesTField.snp.makeConstraints { make in
            make.top.equalTo(salaryTField.snp.bottom).offset(Constants.viewVerticalOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.viewHorizontalInset)
            make.height.equalTo(Constants.tFieldHeight)
        }

        saveButton.snp.makeConstraints { make in
            make.top.equalTo(expensesTField.snp.bottom).offset(Constants.viewVerticalOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.viewHorizontalInset)
            make.height.equalTo(Constants.buttonSize)
        }

        deleteLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.centerY).offset(Constants.viewVerticalOffset)
            make.centerX.equalToSuperview()
        }

        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(deleteLabel.snp.bottom).offset(Constants.viewVerticalOffset)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(Constants.buttonSize)
        }
    }

    private func setupViews() {
        view.addSubview(salaryTField)
        view.addSubview(expensesTField)
        view.addSubview(saveButton)
        view.addSubview(deleteLabel)
        view.addSubview(deleteButton)

        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)

        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }

    private func setupNavBar() {
        navigationController?.navigationBar.tintColor = .mainGreen
        navigationController?.navigationBar.barTintColor = .systemBackground
    }

    @objc private func saveButtonTapped(_ sender: UIButton) {
        viewModel.handleUpdatedData(salary: salaryTField.text, expenses: expensesTField.text)
        coordinator?.popViewController()
    }

    @objc private func deleteButtonTapped(_ sender: UIButton) {
        viewModel.deleteAllDailyExpenses()
        coordinator?.popViewController()
    }
}
