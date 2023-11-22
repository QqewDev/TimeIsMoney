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
    init(viewModel: UserFinanceViewModel) {
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
    }

    private let viewModel: UserFinanceViewModel

    private lazy var salaryTField = makeTextField(placeholder: Constants.salaryPlaceholder)

    private lazy var expensesTField = makeTextField(placeholder: Constants.expensesPlaceholder)

    private lazy var deleteLabel = makeLabel(text: Constants.deleteLabel)

    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.saveButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .mainGreen
        return button
    }()

    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: Constants.deleteButtonImageName), for: .normal)
        button.tintColor = .mainGreen
        button.layer.borderWidth = Constants.borderWidth
        button.layer.borderColor = UIColor.mainGreen.cgColor
        return button
    }()

    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        setConstraints()
        setupNavBar()
    }

    override func viewWillLayoutSubviews() {
        salaryTField.layer.cornerRadius = salaryTField.frame.height / 2
        expensesTField.layer.cornerRadius = expensesTField.frame.height / 2
        saveButton.layer.cornerRadius = saveButton.frame.height / 2
        deleteButton.layer.cornerRadius = deleteButton.frame.height / 2
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
        coordinator?.didFinishActions()
    }

    @objc private func deleteButtonTapped(_ sender: UIButton) {
        viewModel.deleteAllDailyExpenses()
        coordinator?.didFinishActions()
    }

    private func makeTextField(placeholder: String) -> UITextField {
        let tField = UITextField()
        let spacingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: tField.frame.height))
        tField.leftView = spacingView
        tField.leftViewMode = .always
        tField.rightView = spacingView
        tField.rightViewMode = .always
        tField.borderStyle = .roundedRect
        tField.backgroundColor = .systemBackground
        tField.textColor = .mainGreen
        tField.font = UIFont.preferredFont(forTextStyle: .title2)
        tField.layer.borderWidth = Constants.borderWidth
        tField.layer.borderColor = UIColor.mainGreen.cgColor
        tField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                          attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderText.withAlphaComponent(0.4)])
        return tField
    }

    private func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .backgroundText
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        return label
    }
}
