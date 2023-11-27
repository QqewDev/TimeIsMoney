//
//
// TimeIsMoney
// FirebaseAuthProtocol.swift
// 
// Created by Alexander Kist on 27.11.2023.
//

import Foundation
import FirebaseAuth

protocol FirebaseAuthProtocol: AnyObject {
    func registerUser(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void)
    func loginUser(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void)
}
