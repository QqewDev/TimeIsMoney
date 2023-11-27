//
//
// TimeIsMoney
// Extension+String.swift
// 
// Created by Alexander Kist on 26.11.2023.
//

import Foundation

extension String {
    func toDoubleUsingComma() -> Double? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","

        if let number = formatter.number(from: self) {
            return Double(number.stringValue)
        } else {
            return nil
        }
    }
}
