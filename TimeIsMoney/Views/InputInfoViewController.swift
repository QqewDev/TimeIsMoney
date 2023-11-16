//
//
// TimeIsMoney
// InputInfoViewController.swift
//
// Created by Alexander Kist on 16.11.2023.
//


import Foundation
import UIKit

final class InputViewController: UIViewController {
    
    private let viewModel = UserFinanceViewModel()
    
    private let salaryTField: UITextField = {
        let tField = UITextField()
        tField.borderStyle = .roundedRect
        tField.text = "35000"
        tField.placeholder = "Salary"
        return tField
    }()
    
    private let expensesTField: UITextField = {
        let tField = UITextField()
        tField.borderStyle = .roundedRect
        tField.text = "5000"
        tField.placeholder = "Expenses"
        return tField
    }()
    
    private let navButton: UIButton = {
        let button = UIButton()
        button.setTitle("Далее", for: .normal)
        button.backgroundColor = .systemGreen
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    private func setupUI(){
        
        
        view.addSubview(salaryTField)
        view.addSubview(expensesTField)
        view.addSubview(navButton)
        
        
        
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
        
        navButton.snp.makeConstraints { make in
            make.top.equalTo(expensesTField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        navButton.addAction(UIAction(handler: {[weak self] _ in
            guard let self = self else { return }
            
            guard let salaryText = salaryTField.text,
                  let expensesText = expensesTField.text else { return }
            
            guard let salary = Double(salaryText),
                  let expenses = Double(expensesText) else { return }
            
            viewModel.setData(salary: salary, monthlyExpenses: expenses, dailyExpenses: [])
            
            let detailVC = DetailViewController(viewModel: viewModel)
            navigationController?.pushViewController(detailVC, animated: true)
            
        }), for: .touchUpInside)
    }
}
