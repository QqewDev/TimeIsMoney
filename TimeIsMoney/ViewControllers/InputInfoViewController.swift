//
//
// TimeIsMoney
// InputInfoViewController.swift
//
// Created by Alexander Kist on 16.11.2023.
//

import Foundation
import UIKit

final class InputViewController: UIViewController {

    weak var coordinator: AppCoordinator?

    // MARK: Init
    init(viewModel: UserFinanceViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Error")
    }
    // MARK: - Private properties
    private enum Constants {
        static let viewHeight: CGFloat = 50
        static let viewVerticalOffset: CGFloat = 20
        static let viewHorizontalInset: CGFloat = 20
        static let salaryLabelText: String = "Введите зарплату"
        static let expensesLabelText: String = "Введите ежемесячные\nтраты"
        static let navButtonText: String = "Далее"
        static let backgroundColor: UIColor = .systemBackground
    }

    private let viewModel: UserFinanceViewModel

    private let salaryLabel = CustomLabel(text: Constants.salaryLabelText, isStatic: true, textColor: .mainGreen)

    private let expensesLabel = CustomLabel(text: Constants.expensesLabelText, isStatic: true, textColor: .mainGreen)

    private let salaryTField = CustomTextField(fieldType: .salary)

    private let expensesTField = CustomTextField(fieldType: .expenses)

    private let navButton = CustomTextButton(title: Constants.navButtonText, hasBackground: true, fontSize: .big)

    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.backgroundColor
        setupUI()
        setConstraints()
        setupTFields()
    }

    // MARK: - Private methods
    private func setupTFields() {
        salaryTField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        expensesTField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    private func setupUI() {
        view.addSubview(salaryLabel)
        view.addSubview(salaryTField)
        view.addSubview(expensesLabel)
        view.addSubview(expensesTField)
        view.addSubview(navButton)
        navButton.alpha = 0
        navButton.addTarget(self, action: #selector(navButtonTapped), for: .touchUpInside)
    }

    private func setConstraints() {
        salaryLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.viewVerticalOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.viewHorizontalInset)
        }

        salaryTField.snp.makeConstraints { make in
            make.top.equalTo(salaryLabel.snp.bottom).offset(Constants.viewVerticalOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.viewHorizontalInset)
            make.height.equalTo(Constants.viewHeight)
        }

        expensesLabel.snp.makeConstraints { make in
            make.top.equalTo(salaryTField.snp.bottom).offset(Constants.viewVerticalOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.viewHorizontalInset)
        }

        expensesTField.snp.makeConstraints { make in
            make.top.equalTo(expensesLabel.snp.bottom).offset(Constants.viewVerticalOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.viewHorizontalInset)
            make.height.equalTo(Constants.viewHeight)
        }

        navButton.snp.makeConstraints { make in
            make.top.equalTo(expensesTField.snp.bottom).offset(Constants.viewVerticalOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.viewHorizontalInset)
            make.height.equalTo(Constants.viewHeight)
        }
    }

    // MARK: - Selectors methods
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if salaryTField.text?.isEmpty == false, expensesTField.text?.isEmpty == false {
            UIView.animate(withDuration: 0.3) {
                self.navButton.alpha = 1.0
            }
            navButton.isEnabled = true
        } else {
            UIView.animate(withDuration: 0.3) {
                self.navButton.alpha = 0.0
            }
            navButton.isEnabled = false
        }
    }

    @objc private func navButtonTapped() {
        viewModel.handleInputData(salary: salaryTField.text, expenses: expensesTField.text)
        coordinator?.showDetailVC()
    }
}
