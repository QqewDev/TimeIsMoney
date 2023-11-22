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
        static let tFieldPlaceholder: String = "000000"
    }

    private let viewModel: UserFinanceViewModel

    private lazy var salaryLabel = makeLabel(text: Constants.salaryLabelText)

    private lazy var expensesLabel = makeLabel(text: Constants.expensesLabelText)

    private lazy var salaryTField = makeTextField(placeholder: Constants.tFieldPlaceholder)

    private lazy var expensesTField = makeTextField(placeholder: Constants.tFieldPlaceholder)

    private let navButton: UIButton = {
        let button = UIButton()
        button.setTitle("Далее", for: .normal)
        button.setTitleColor(.mainGreen, for: .normal)
        button.backgroundColor = .backgroundText
        button.isEnabled = false
        button.alpha = 0
        return button
    }()

    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setConstraints()
        setupTFields()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        settingViewCorners()
    }

    // MARK: - Private methods
    private func setupTFields() {
        salaryTField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        expensesTField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

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

    private func settingViewCorners() {
        salaryTField.layer.cornerRadius = salaryTField.frame.height / 2
        expensesTField.layer.cornerRadius = expensesTField.frame.height / 2
        navButton.layer.cornerRadius = navButton.frame.height / 2
    }

    private func setupUI() {
        view.addSubview(salaryLabel)
        view.addSubview(salaryTField)
        view.addSubview(expensesLabel)
        view.addSubview(expensesTField)
        view.addSubview(navButton)
        navButton.addTarget(self, action: #selector(navButtonTapped), for: .touchUpInside)
    }

    @objc private func navButtonTapped() {
        viewModel.handleInputData(salary: salaryTField.text, expenses: expensesTField.text)
        coordinator?.showDetail(viewModel: viewModel)
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
        tField.layer.borderWidth = 1.0
        tField.layer.borderColor = UIColor.mainGreen.cgColor
        tField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                          attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderText])
        return tField
    }

    private func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .mainGreen
        label.numberOfLines = 0
        label.font = UIFont.largeTitle()
        return label
    }
}
