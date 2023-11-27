//
//
// TimeIsMoney
// LoginViewController.swift
// 
// Created by Alexander Kist on 27.11.2023.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
   
    weak var coordinator: AppCoordinator?

    private let headerView = HeaderView(title: "Вход", subtitle: "Войдите в свой аккаунт")
    private let emailTField = CustomTextField(fieldType: .email)
    private let passwordTField = CustomTextField(fieldType: .password)
    private let loginButton = CustomTextButton(title: "Войти", hasBackground: true, fontSize: .big)
    private let goToRegisterVCButton = CustomTextButton(title: "Нет аккаунта? Создать аккаунт", hasBackground: false, fontSize: .small)
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
    }

    private func setupViews() {

        emailTField.tag = 0
        passwordTField.tag = 1

        emailTField.delegate = self
        passwordTField.delegate = self

        view.addSubview(headerView)
        view.addSubview(emailTField)
        view.addSubview(passwordTField)
        view.addSubview(loginButton)
        view.addSubview(goToRegisterVCButton)

        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(200).multipliedBy(0.1)
        }

        emailTField.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalToSuperview().multipliedBy(0.055)
        }

        passwordTField.snp.makeConstraints { make in
            make.top.equalTo(emailTField.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalToSuperview().multipliedBy(0.055)
        }

        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTField.snp.bottom).offset(35)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalToSuperview().multipliedBy(0.055)
        }

        goToRegisterVCButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.055)
        }

        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)

        goToRegisterVCButton.addTarget(self, action: #selector(goToRegisterVCButtonTapped), for: .touchUpInside)
    }


    //MARK: - Selectors
    @objc private func loginButtonTapped(){
        print("Login button tapped")
    }
    
    @objc private func goToRegisterVCButtonTapped(){
        coordinator?.showRegister()
    }

}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}
