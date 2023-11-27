//
//
// TimeIsMoney
// LoginViewModel.swift
//
// Created by Alexander Kist on 27.11.2023.
//

import Foundation
import FirebaseAuth

final class LoginViewModel {
    
    // MARK: - Private properties
    private var authManager: FirebaseAuthManager
    
    // MARK: - Init
    init(authManager: FirebaseAuthManager) {
        self.authManager = authManager
    }
    // MARK: - Public methods
    func loginUser(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        authManager.loginUser(email: email, password: password, completion: completion)
    }
}
