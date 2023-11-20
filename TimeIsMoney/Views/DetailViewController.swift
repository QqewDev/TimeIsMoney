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
    
    private lazy var salaryInfoLabel = makeLabel(textColor: .backgroundText, font: UIFont.preferredFont(forTextStyle: .largeTitle))
    private lazy var expensesInfoLabel = makeLabel(textColor: .backgroundText, font: UIFont.preferredFont(forTextStyle: .largeTitle))
    private lazy var availableMoneyInfoLabel = makeLabel(textColor: .backgroundText, font: UIFont.preferredFont(forTextStyle: .largeTitle))
    private lazy var earnedMoneyInfoLabel = makeLabel(textColor: .mainGreen, font: UIFont.preferredFont(forTextStyle: .largeTitle))
    
    private let addExpenseButton: UIButton = {
        let button = UIButton()
        button.setTitle("Внести трату", for:  .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .mainGreen
        return button
    }()
    
    
    //MARK: - Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadData()
        setupTimer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Сегодня"
        navigationItem.largeTitleDisplayMode = .automatic
        setupViews()
        setConstraints()
        setupNavBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopTimer()
    }
    
    override func viewWillLayoutSubviews() {
//        addExpenseButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    //MARK: - Private methods
    private func setupTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateUI), userInfo: nil, repeats: true)
    }
    
    @objc func updateUI() {
        earnedMoneyInfoLabel.text = "Заработано:\n\(viewModel.earnedMoney)₽"
    }
    
    private func stopTimer(){
        timer?.invalidate()
        timer = nil
    }
    
    private func setupViews(){
        salaryInfoLabel.text = "Зарплата:\n\(viewModel.salary)₽"
        expensesInfoLabel.text = "Траты:\n\(viewModel.monthlyExpenses)₽"
        availableMoneyInfoLabel.text = "Свободно:\n\(viewModel.availableMoney)₽"
        earnedMoneyInfoLabel.text = "Заработано:\n\(viewModel.earnedMoney)"
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
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(settingsButtonTapped))
        navigationItem.leftBarButtonItem = settingsButton
        navigationItem.leftBarButtonItem?.tintColor = .mainGreen
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.mainGreen]

        let expensesListButton = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .plain, target: self, action: #selector(expensesListButtonTapped))
        navigationItem.rightBarButtonItem = expensesListButton
        navigationItem.rightBarButtonItem?.tintColor = .mainGreen

    }
    
    @objc func settingsButtonTapped(){
        let settingsVC = SettingsViewController(viewModel: viewModel)
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @objc func expensesListButtonTapped(){
        let expensesListVM = ExpensesListViewModel()
        let expensesListVC = ExpensesListViewController(viewModel: expensesListVM)
        navigationController?.pushViewController(expensesListVC, animated: true)
    }
    
    
    private func setConstraints(){
        view.addSubview(salaryInfoLabel)
        view.addSubview(expensesInfoLabel)
        view.addSubview(availableMoneyInfoLabel)
        view.addSubview(earnedMoneyInfoLabel)
        view.addSubview(addExpenseButton)
        
        
        salaryInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        expensesInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(salaryInfoLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        availableMoneyInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(expensesInfoLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        earnedMoneyInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(availableMoneyInfoLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        addExpenseButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
        }
    }
    
    private func makeLabel(textColor: UIColor, font: UIFont) -> UILabel {
        let label = UILabel()
        label.textColor = textColor
        label.font = font
        label.numberOfLines = 0
        return label
    }
}
extension DetailViewController: UserFinanceViewModelDelegate {
    func didUpdatedData() {
        DispatchQueue.main.async {
            self.salaryInfoLabel.text = "Зарплата:\n\(self.viewModel.salary)₽"
            self.expensesInfoLabel.text = "Траты:\n\(self.viewModel.monthlyExpenses)₽"
            self.availableMoneyInfoLabel.text = "Свободно:\n\(self.viewModel.availableMoney)₽"
            self.earnedMoneyInfoLabel.text = "Заработано:\n\(self.viewModel.earnedMoney)₽"
        }
    }
}

