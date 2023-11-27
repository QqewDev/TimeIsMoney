//
//
// TimeIsMoney
// CustomTextField.swift
//
// Created by Alexander Kist on 25.11.2023.
//

import UIKit

final class  CustomTextField: UITextField {

    enum CustomTextFieldType {

        case email
        case password
        case salary
        case expenses
        case purchaseName
        case purchasePrice
    }

    private let authFieldType: CustomTextFieldType

    init(fieldType: CustomTextFieldType) {
        self.authFieldType = fieldType
        super.init(frame: .zero)

        backgroundColor = .secondarySystemBackground

        autocorrectionType = .no
        autocapitalizationType = .none

        leftViewMode = .always
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: frame.size.height))

        switch authFieldType {
        case .email:
            placeholder = "Введите E-mail"
            keyboardType = .emailAddress
            textContentType = .emailAddress
            returnKeyType = .continue
        case .password:
            placeholder = "Введите пароль"
            textContentType = .oneTimeCode
            isSecureTextEntry = true
            returnKeyType = .done
        case .salary:
            placeholder = "000000"
            keyboardType = .decimalPad
            returnKeyType = .continue
        case .expenses:
            placeholder = "000000"
            keyboardType = .decimalPad
            returnKeyType = .done
        case .purchaseName:
            placeholder = "Название траты"
            returnKeyType = .continue
        case .purchasePrice:
            placeholder = "00000"
            keyboardType = .decimalPad
            returnKeyType = .done
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.height / 2
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
