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

    private lazy var purchaseTitleTField = makeTextField(placeholder: Constants.purchasePlaceholder, keyboardType: .default)
    private lazy var purchaseCostTField = makeTextField(placeholder: Constants.costPlaceholder, keyboardType: .decimalPad)

    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.saveButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .backgroundText
        return button
    }()

    private let purchaseDate = Date()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .mainGreen
        setupViews()
        setConstraints()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        settingViewCorners()
    }

    // MARK: - Private methods
    private func settingViewCorners() {
        purchaseTitleTField.layer.cornerRadius = purchaseTitleTField.frame.height / 2
        purchaseCostTField.layer.cornerRadius = purchaseCostTField.frame.height / 2
        saveButton.layer.cornerRadius = saveButton.frame.height / 2
    }

    private func setupViews() {
        view.addSubview(purchaseCostTField)
        view.addSubview(purchaseTitleTField)
        view.addSubview(saveButton)

        purchaseTitleTField.becomeFirstResponder()

        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }

    @objc private func saveButtonTapped(_ sender: UIButton) {
        viewModel.handleAddedExpense(title: purchaseTitleTField.text, cost: purchaseCostTField.text, purchaseDate: Date())
        dismiss(animated: true, completion: nil)
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

    private func makeTextField(placeholder: String, keyboardType: UIKeyboardType) -> UITextField {
        let tField = UITextField()
        let spacingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: tField.frame.height))
        tField.leftView = spacingView
        tField.leftViewMode = .always
        tField.rightView = spacingView
        tField.rightViewMode = .always
        tField.borderStyle = .roundedRect
        tField.keyboardType = keyboardType
        tField.backgroundColor = .mainGreen
        tField.textColor = .backgroundText
        tField.font = UIFont.preferredFont(forTextStyle: .title2)
        tField.layer.borderWidth = 1.0
        tField.layer.borderColor = UIColor.backgroundText.cgColor
        tField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                          attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderText.withAlphaComponent(0.4)])
        return tField
    }

}
