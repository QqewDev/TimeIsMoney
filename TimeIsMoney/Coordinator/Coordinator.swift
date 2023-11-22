//
//
// TimeIsMoney
// Coordinator.swift
// 
// Created by Alexander Kist on 22.11.2023.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }

    func start()
}
