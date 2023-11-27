//
//
// TimeIsMoney
// DetailViewController.swift
//
// Created by Alexander Kist on 16.11.2023.
//

import Foundation
import UIKit

final class DetailViewController: UIViewController {

    // MARK: Init
    init(viewModel: UserFinanceViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("Error")
    }
    weak var coordinator: AppCoordinator?
    // MARK: - Private properties
    private enum Constants {
        static let titleText: String = "Сегодня"
        static let settingsImageName: String = "gearshape"
        static let expensesListImageName: String = "list.dash"
        static let addButtonTitle: String = "Внести трату"
        static let viewVerticalOffset: CGFloat = 20
        static let viewHorizontalInset: CGFloat = 20
        static let borderHeightMultiplier: CGFloat = 0.1
        static let mainColor: UIColor = .mainGreen
        static let bgTextColor: UIColor = .backgroundText
        static let backgroundColor: UIColor = .systemBackground
        static let buttonSize: CGFloat = 50
    }

    private let viewModel: UserFinanceViewModel

    private var timer: Timer?

    private let salaryInfoLabel = CustomLabel(isStatic: false, textColor: Constants.bgTextColor)

    private let expensesInfoLabel = CustomLabel(isStatic: false, textColor: Constants.bgTextColor)

    private let availableMoneyInfoLabel = CustomLabel(isStatic: false, textColor: Constants.bgTextColor)

    private let earnedMoneyInfoLabel = CustomLabel(isStatic: false, textColor: Constants.mainColor)

    private let notificationButton = CustomImageButton(imageName: "bell.fill", hasTint: false)

    private let addExpenseButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.addButtonTitle, for:  .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constants.mainColor
        return button
    }()

    // MARK: - Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadData()
        setupTimer()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.backgroundColor
        setupViews()
        setConstraints()
        setupNavBar()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopTimer()
    }

    // MARK: - Private methods
    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateUI), userInfo: nil, repeats: true)
    }

    @objc private func updateUI() {
        earnedMoneyInfoLabel.text = "Заработано:\n\(viewModel.earnedMoney)₽"
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func setupViews() {
        salaryInfoLabel.text = "Зарплата:\n\(viewModel.salary)₽"
        expensesInfoLabel.text = "Траты:\n\(viewModel.monthlyExpenses)₽"
        availableMoneyInfoLabel.text = "Свободно:\n\(viewModel.availableMoney)₽"
        earnedMoneyInfoLabel.text = "Заработано:\n\(viewModel.earnedMoney)"
        notificationButton.tintColor = viewModel.isNotificationsAllowed ? .mainGreen : .lightGray
        notificationButton.layer.borderColor = viewModel.isNotificationsAllowed ? UIColor.mainGreen.cgColor : UIColor.lightGray.cgColor
        addExpenseButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        notificationButton.addTarget(self, action: #selector(notificationButtonTapped), for: .touchUpInside)
        makeAddButtonCorners()

    }

    private func makeAddButtonCorners() {
        DispatchQueue.main.async {
            let maskPath = UIBezierPath(roundedRect: self.addExpenseButton.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10, height: 10))
            let shape = CAShapeLayer()
            shape.path = maskPath.cgPath
            self.addExpenseButton.layer.mask = shape
        }
    }

    @objc private func addButtonTapped() {
        coordinator?.showAddExpense(viewModel: viewModel)
    }
    @objc private func notificationButtonTapped() {
        viewModel.requestNotifications()
    }

    private func setupNavBar() {
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: Constants.settingsImageName), style: .plain, target: self, action: #selector(settingsButtonTapped))
        navigationItem.leftBarButtonItem = settingsButton
        navigationItem.leftBarButtonItem?.tintColor = Constants.mainColor

        title = Constants.titleText

        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Constants.mainColor]

        let expensesListButton = UIBarButtonItem(image: UIImage(systemName: Constants.expensesListImageName), style: .plain, target: self, action: #selector(expensesListButtonTapped))
        navigationItem.rightBarButtonItem = expensesListButton
        navigationItem.rightBarButtonItem?.tintColor = Constants.mainColor

    }

    @objc func settingsButtonTapped() {
        coordinator?.showSettings()
    }

    @objc func expensesListButtonTapped() {
        coordinator?.showExpensesList()
    }

    private func setConstraints() {
        view.addSubview(salaryInfoLabel)
        view.addSubview(expensesInfoLabel)
        view.addSubview(availableMoneyInfoLabel)
        view.addSubview(earnedMoneyInfoLabel)
        view.addSubview(addExpenseButton)
        view.addSubview(notificationButton)

        salaryInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.viewVerticalOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.viewHorizontalInset)
        }

        expensesInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(salaryInfoLabel.snp.bottom).offset(Constants.viewVerticalOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.viewHorizontalInset)
        }

        availableMoneyInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(expensesInfoLabel.snp.bottom).offset(Constants.viewVerticalOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.viewHorizontalInset)
        }

        earnedMoneyInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(availableMoneyInfoLabel.snp.bottom).offset(Constants.viewVerticalOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.viewHorizontalInset)
        }

        notificationButton.snp.makeConstraints { make in
            make.top.equalTo(earnedMoneyInfoLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(Constants.buttonSize)
        }

        addExpenseButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(Constants.borderHeightMultiplier)
        }
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

    func didGetPermissionForNotify() {
        DispatchQueue.main.async {
            self.notificationButton.tintColor = self.viewModel.isNotificationsAllowed ? .mainGreen : .lightGray
            self.notificationButton.layer.borderColor = self.viewModel.isNotificationsAllowed ? UIColor.mainGreen.cgColor : UIColor.lightGray.cgColor
        }
    }
}
