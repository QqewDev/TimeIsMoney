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
        case username
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

        self.backgroundColor = .secondarySystemBackground
        self.returnKeyType = .done
        self.autocorrectionType = .no
        self.autocapitalizationType = .none

        self.leftViewMode = .always
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.size.height))

        switch authFieldType {
        case .username:
            placeholder = "Username"
        case .email:
            placeholder = "Email Address"
            keyboardType = .emailAddress
            textContentType = .emailAddress
        case .password:
            placeholder = "Password"
            textContentType = .oneTimeCode
            isSecureTextEntry = true
        case .salary:
            placeholder = "000000"
            keyboardType = .decimalPad
        case .expenses:
            placeholder = "000000"
            keyboardType = .decimalPad
        case .purchaseName:
            placeholder = "Название траты"
        case .purchasePrice:
            placeholder = "00000"
            keyboardType = .decimalPad
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

// private func makeTextField(placeholder: String) -> UITextField {
//    let tField = UITextField()
//    let spacingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: tField.frame.height))
//    tField.leftView = spacingView
//    tField.leftViewMode = .always
//    tField.rightView = spacingView
//    tField.rightViewMode = .always
//    tField.borderStyle = .roundedRect
//    tField.backgroundColor = .systemBackground
//    tField.textColor = .mainGreen
//    tField.font = UIFont.preferredFont(forTextStyle: .title2)
//    tField.layer.borderWidth = 1.0
//    tField.layer.borderColor = UIColor.mainGreen.cgColor
//    tField.attributedPlaceholder = NSAttributedString(string: placeholder,
//                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderText])
//    return tField
// }
