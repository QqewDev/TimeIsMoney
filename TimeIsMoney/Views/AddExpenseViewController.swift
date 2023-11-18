//
//
// TimeIsMoney
// AddExpenseViewController.swift
// 
// Created by Alexander Kist on 16.11.2023.
//


import UIKit


class AddExpenseViewController: UIViewController {
    
    //MARK: Init
    init(viewModel: UserFinanceViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error")
    }
    
    //MARK: - Private properties
    private let viewModel: UserFinanceViewModel
    
    private let purchaseTitleField: UITextField = {
        let tField = UITextField()
        tField.borderStyle = .roundedRect
        tField.placeholder = "Название покупки"
        return tField
    }()
    
    private let purchaseCostField: UITextField = {
        let tField = UITextField()
        tField.borderStyle = .roundedRect
        tField.placeholder = "Стоимость покупки"
        tField.keyboardType = .decimalPad
        return tField
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сохранить", for: .normal)
        button.backgroundColor = .systemGreen
        return button
    }()
    
    private let purchaseDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGreen
        setupViews()
        setConstraints()
    }
    
    
    private func setupViews(){
        view.addSubview(purchaseCostField)
        view.addSubview(purchaseTitleField)
        view.addSubview(saveButton)
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc func saveButtonTapped(_ sender: UIButton) {
        viewModel.handleAddedExpense(title: purchaseTitleField.text, cost: purchaseCostField.text, purchaseDate: Date())
        dismiss(animated: true, completion: nil)
    }
    
    private func setConstraints(){
        purchaseTitleField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        purchaseCostField.snp.makeConstraints { make in
            make.top.equalTo(purchaseTitleField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(purchaseCostField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    
}
