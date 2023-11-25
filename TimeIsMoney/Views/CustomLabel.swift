//
//
// TimeIsMoney
// CustomLabel.swift
// 
// Created by Alexander Kist on 25.11.2023.
//

import UIKit

final class CustomLabel: UILabel {

    init(text: String? = nil, isStatic: Bool = false, textColor: UIColor) {
        super.init(frame: .zero)
        self.text = isStatic ? text : ""
        self.textColor = textColor
        numberOfLines = 0
        font = UIFont.largeTitle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// private func makeLabel(text: String) -> UILabel {
//    let label = UILabel()
//    label.text = text
//    label.textColor = .mainGreen
//    label.numberOfLines = 0
//    label.font = UIFont.largeTitle()
//    return label
// }
