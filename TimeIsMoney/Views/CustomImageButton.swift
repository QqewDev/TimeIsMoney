//
//
// TimeIsMoney
// CustomImageButton.swift
// 
// Created by Alexander Kist on 25.11.2023.
//

import UIKit

final class CustomImageButton: UIButton {

    init(imageName: String, hasTint: Bool = false) {
        super.init(frame: .zero)
        setImage(UIImage(systemName: imageName), for: .normal)
        layer.masksToBounds = true

        tintColor = hasTint ? .mainGreen : .clear
        layer.borderWidth = 1
        layer.borderColor = UIColor.mainGreen.cgColor
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.height / 2
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// private let deleteButton: UIButton = {
//    let button = UIButton()
//    button.setImage(UIImage(systemName: Constants.deleteButtonImageName), for: .normal)
//    button.tintColor = .mainGreen
//    button.layer.borderWidth = Constants.borderWidth
//    button.layer.borderColor = UIColor.mainGreen.cgColor
//    return button
// }()
