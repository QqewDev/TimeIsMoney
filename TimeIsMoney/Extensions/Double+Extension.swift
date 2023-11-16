//
//
// TimeIsMoney
// Double+Extension.swift
// 
// Created by Alexander Kist on 16.11.2023.
//


import Foundation

extension Double {
    func rounding(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
