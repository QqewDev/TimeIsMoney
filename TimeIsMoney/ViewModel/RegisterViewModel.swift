//
//
// TimeIsMoney
// RegisterViewModel.swift
// 
// Created by Alexander Kist on 27.11.2023.
//

import Foundation
import FirebaseAuth

final class RegisterViewModel {
    
    // MARK: - Private properties
    private var authManager: FirebaseAuthManager

    // MARK: - Init
    init(authManager: FirebaseAuthManager) {
        self.authManager = authManager
    }
    
    // MARK: - Public methods
    func register(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        authManager.registerUser(email: email, password: password, completion: completion)
    }
}
