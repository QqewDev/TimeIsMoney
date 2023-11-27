//
//
// TimeIsMoney
// UIFont+Extension.swift
// 
// Created by Alexander Kist on 22.11.2023.
//

import UIKit

extension UIFont {
    static func largeTitle() -> UIFont {
        return UIFont.preferredFont(forTextStyle: .largeTitle)
    }
    
    static func boldHeaderTitile() -> UIFont {
        return UIFont.systemFont(ofSize: 26, weight: .bold)
    }
    
    static func regularHeaderSubTitile() -> UIFont {
        return UIFont.systemFont(ofSize: 18, weight: .regular)
    }

    static func big() -> UIFont {
        return UIFont.systemFont(ofSize: 22, weight: .medium)
    }

    static func medium() -> UIFont {
        return UIFont.systemFont(ofSize: 20, weight: .medium)
    }

    static func small() -> UIFont {
        return UIFont.systemFont(ofSize: 18, weight: .regular)
    }
}
