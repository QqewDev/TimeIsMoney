//
//
// TimeIsMoney
// AddExpenseViewController.swift
// 
// Created by Alexander Kist on 16.11.2023.
//

import UIKit

final class AddExpenseViewController: UIViewController {

    // MARK: - Init
    init(viewModel: UserFinanceViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Error")
    }

    // MARK: - Private properties
    private enum Constants {
        static let purchasePlaceholder: String = "Название покупки"
        static let costPlaceholder: String = "Стоимость покупки"
        static let saveButtonTitle: String = "Внести"
        static let viewVerticalOffset: CGFloat = 20
        static let viewHorizontalInset: CGFloat = 20
        static let tFieldHeight: CGFloat = 50
        static let buttonSize: CGFloat = 50
        static let borderWidth: CGFloat = 1
    }

    private let viewModel: UserFinanceViewModel

    private let purchaseTitleTField = CustomTextField(fieldType: .purchaseName)

    private let purchaseCostTField = CustomTextField(fieldType: .purchasePrice)

    private let saveButton = CustomTextButton(title: Constants.saveButtonTitle, hasBackground: true, fontSize: .big)

    private let purchaseDate = Date()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupViews()
        setConstraints()
    }

    // MARK: - Private methods
    private func setupViews() {
        view.addSubview(purchaseCostTField)
        view.addSubview(purchaseTitleTField)
        view.addSubview(saveButton)

        purchaseTitleTField.becomeFirstResponder()

        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }

    private func setConstraints() {
        purchaseTitleTField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.viewVerticalOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.viewHorizontalInset)
            make.height.equalTo(Constants.tFieldHeight)
        }

        purchaseCostTField.snp.makeConstraints { make in
            make.top.equalTo(purchaseTitleTField.snp.bottom).offset(Constants.viewVerticalOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.viewHorizontalInset)
            make.height.equalTo(Constants.tFieldHeight)
        }

        saveButton.snp.makeConstraints { make in
            make.top.equalTo(purchaseCostTField.snp.bottom).offset(Constants.viewVerticalOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.viewHorizontalInset)
            make.height.equalTo(Constants.buttonSize)
        }
    }

    // MARK: - Selectors methods
    @objc private func saveButtonTapped(_ sender: UIButton) {
        viewModel.handleAddedExpense(title: purchaseTitleTField.text, cost: purchaseCostTField.text, purchaseDate: Date())
        dismiss(animated: true, completion: nil)
    }
}
