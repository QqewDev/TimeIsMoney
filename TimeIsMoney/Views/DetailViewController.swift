//
//
// TimeIsMoney
// DetailViewController.swift
//
// Created by Alexander Kist on 16.11.2023.
//


import Foundation
import UIKit

final class DetailViewController: UIViewController{
    
    //MARK: Init
    init(viewModel: UserFinanceViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error")
    }
    
    //MARK: - Private properties
    private let viewModel: UserFinanceViewModel
    
    private var timer: Timer?
    
    private let salaryLabel = UILabel(numberOfLines: 0, font: UIFont.preferredFont(forTextStyle: .headline), textColor: .text)
    private let expensesLabel = UILabel(numberOfLines: 0, font: UIFont.preferredFont(forTextStyle: .title2), textColor: .text)
    
    private let availableMoneyLabel = UILabel(numberOfLines: 0, font: UIFont.preferredFont(forTextStyle: .title3), textColor: .text)
    
    private let earnedMoneyLabel = UILabel(numberOfLines: 0, font: UIFont.preferredFont(forTextStyle: .title1), textColor: .text)
    
    private let addExpenseButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить", for:  .normal)
        button.backgroundColor = .systemGreen
        return button
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadData()
        setupTimer()
    }
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        setConstraints()
        setupNavBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopTimer()
    }
    
    override func viewWillLayoutSubviews() {
        addExpenseButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    //MARK: - Private methods
    private func setupTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateUI), userInfo: nil, repeats: true)
    }
    
    @objc func updateUI() {
        earnedMoneyLabel.text = "Заработано:\n\(viewModel.earnedMoney)"
    }
    
    private func stopTimer(){
        timer?.invalidate()
        timer = nil
    }
    
    private func setupViews(){
        salaryLabel.text = "Зарплата:\n\(viewModel.salary)₽"
        expensesLabel.text = "Траты:\n\(viewModel.monthlyExpenses)₽"
        availableMoneyLabel.text = "Свободно:\n\(viewModel.availableMoney)₽"
        earnedMoneyLabel.text = "Заработано:\n\(viewModel.earnedMoney)"
        addExpenseButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        makeAddButtonCorners()

    }
    
    private func makeAddButtonCorners(){
        DispatchQueue.main.async {
            let maskPath = UIBezierPath(roundedRect: self.addExpenseButton.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10, height: 10))
            let shape = CAShapeLayer()
            shape.path = maskPath.cgPath
            self.addExpenseButton.layer.mask = shape
        }
    }
    
    @objc func addButtonTapped(){
        let addExpenseVC = AddExpenseViewController(viewModel: viewModel)
        if let sheet = addExpenseVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        present(addExpenseVC, animated: true)
    }
    
    private func setupNavBar() {
        title = "Сегодня"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(settingsButtonTapped))
        navigationItem.rightBarButtonItem = settingsButton
    }
    
    @objc func settingsButtonTapped(){
        let settingsVC = SettingsViewController(viewModel: viewModel)
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    
    private func setConstraints(){
        view.addSubview(salaryLabel)
        view.addSubview(expensesLabel)
        view.addSubview(availableMoneyLabel)
        view.addSubview(earnedMoneyLabel)
        view.addSubview(addExpenseButton)
        
        
        salaryLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        expensesLabel.snp.makeConstraints { make in
            make.top.equalTo(salaryLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        availableMoneyLabel.snp.makeConstraints { make in
            make.top.equalTo(expensesLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        earnedMoneyLabel.snp.makeConstraints { make in
            make.top.equalTo(availableMoneyLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        addExpenseButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
        }
    }
}
extension DetailViewController: UserFinanceViewModelDelegate {
    func didUpdatedData() {
        DispatchQueue.main.async {
            self.salaryLabel.text = "Зарплата:\n\(self.viewModel.salary)₽"
            self.expensesLabel.text = "Траты:\n\(self.viewModel.monthlyExpenses)₽"
            self.availableMoneyLabel.text = "Свободно:\n\(self.viewModel.availableMoney)₽"
            self.earnedMoneyLabel.text = "Заработано:\n\(self.viewModel.earnedMoney)"
        }
    }
}

