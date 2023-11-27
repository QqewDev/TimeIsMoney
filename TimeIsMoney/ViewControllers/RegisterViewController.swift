//
//
// TimeIsMoney
// RegisterViewController.swift
// 
// Created by Alexander Kist on 27.11.2023.
//

import UIKit

class RegisterViewController: UIViewController {

    weak var coordinator: AppCoordinator?

    // MARK: - Init
    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private variables
    private var viewModel: RegisterViewModel
    private let headerView = HeaderView(title: "Регистрация", subtitle: "Зарегистрируйте аккаунт")
    private let emailTField = CustomTextField(fieldType: .email)
    private let passwordTField = CustomTextField(fieldType: .password)
    private let registerButton = CustomTextButton(title: "Зарегистрироваться", hasBackground: true, fontSize: .big)
    private let goToLoginVCButton = CustomTextButton(title: "Уже есть аккаунт? Войти", hasBackground: false, fontSize: .small)

    // MARK: - Lifecycle methods
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
    }

    // MARK: - Private methods
    private func setupViews() {

        emailTField.tag = 0
        passwordTField.tag = 1

        emailTField.delegate = self
        passwordTField.delegate = self

        view.addSubview(headerView)
        view.addSubview(emailTField)
        view.addSubview(passwordTField)
        view.addSubview(registerButton)
        view.addSubview(goToLoginVCButton)

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

        registerButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTField.snp.bottom).offset(35)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalToSuperview().multipliedBy(0.055)
        }

        goToLoginVCButton.snp.makeConstraints { make in
            make.top.equalTo(registerButton.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.055)
        }
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)

        goToLoginVCButton.addTarget(self, action: #selector(goToLoginVCButtonTapped), for: .touchUpInside)
    }

    // MARK: - Selectors methods
    @objc private func registerButtonTapped() {
        guard let email = emailTField.text, let password = passwordTField.text else { return }
        viewModel.register(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let authData):
                self?.coordinator?.showInputVC()
                print(authData.user.uid)
            case .failure(let error):
                print("Ошибка регистрации: \(error)")
            }
        }
    }

    @objc private func goToLoginVCButtonTapped() {
        coordinator?.popViewController()
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}
