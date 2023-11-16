//
//
// TimeIsMoney
// SettingsViewController.swift
// 
// Created by Alexander Kist on 16.11.2023.
//


import Foundation
import UIKit
import SnapKit

final class SettingsViewController: UIViewController {
    
    private let viewModel: UserFinanceViewModel
    
    init(viewModel: UserFinanceViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    private let salaryTField: UITextField = {
        let tField = UITextField()
        tField.borderStyle = .roundedRect
        tField.placeholder = "Salary"
        return tField
    }()
    
    private let expensesTField: UITextField = {
        let tField = UITextField()
        tField.borderStyle = .roundedRect
        tField.placeholder = "Expenses"
        return tField
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сохранить", for: .normal)
        button.backgroundColor = .systemGreen
        return button
    }()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        
        setupViews()
        setConstraints()
    }
    
    private func setConstraints(){
        salaryTField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        
        expensesTField.snp.makeConstraints { make in
            make.top.equalTo(salaryTField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(expensesTField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    private func setupViews(){
        view.addSubview(salaryTField)
        view.addSubview(expensesTField)
        view.addSubview(saveButton)
        
        
        salaryTField.placeholder = "Изменить зарплату"
        expensesTField.placeholder = "Изменить расходы"
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc func saveButtonTapped(_ sender: UIButton) {
        guard let salaryText = salaryTField.text,
              let expensesText = expensesTField.text else { return }
        
        
        guard let newSalary = Double(salaryText),
              let newExpenses = Double(expensesText) else { return }
        
        viewModel.setData(salary: newSalary, monthlyExpenses: newExpenses, dailyExpenses: [])
        navigationController?.popViewController(animated: true)
    }
}
