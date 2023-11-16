//
//
// TimeIsMoney
// Label+Extension.swift
// 
// Created by Alexander Kist on 16.11.2023.
//


import UIKit

extension UILabel {
    convenience init(numberOfLines: Int, font: UIFont, textColor: UIColor) {
        self.init()
        self.numberOfLines = numberOfLines
        self.font = font
        self.textColor = textColor
    }
}
