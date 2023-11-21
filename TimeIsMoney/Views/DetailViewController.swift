//
//
// TimeIsMoney
// DetailViewController.swift
//
// Created by Alexander Kist on 16.11.2023.
//

import Foundation
import UIKit

private enum Constants {
    static let titleText: String = "Сегодня"
    static let settingsImageName: String = "gearshape"
    static let expensesListImageName: String = "list.dash"
    static let addButtonTitle: String = "Внести трату"
    static let viewVerticalOffset: CGFloat = 20
    static let viewHorizontalInset: CGFloat = 20
    static let borderHeightMultiplier: CGFloat = 0.1
    static let mainColor: UIColor = .mainGreen
}

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

    // MARK: - Private properties
    private let viewModel: UserFinanceViewModel

    private var timer: Timer?

    private lazy var salaryInfoLabel = makeLabel(textColor: .backgroundText, font: UIFont.preferredFont(forTextStyle: .largeTitle))
    private lazy var expensesInfoLabel = makeLabel(textColor: .backgroundText, font: UIFont.preferredFont(forTextStyle: .largeTitle))
    private lazy var availableMoneyInfoLabel = makeLabel(textColor: .backgroundText, font: UIFont.preferredFont(forTextStyle: .largeTitle))
    private lazy var earnedMoneyInfoLabel = makeLabel(textColor: Constants.mainColor, font: UIFont.preferredFont(forTextStyle: .largeTitle))

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
        view.backgroundColor = .systemBackground
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
        addExpenseButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
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
        let addExpenseVC = AddExpenseViewController(viewModel: viewModel)
        if let sheet = addExpenseVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        present(addExpenseVC, animated: true)
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
        let settingsVC = SettingsViewController(viewModel: viewModel)
        navigationController?.pushViewController(settingsVC, animated: true)
    }

    @objc func expensesListButtonTapped() {
        let expensesListVM = ExpensesListViewModel()
        let expensesListVC = ExpensesListViewController(viewModel: expensesListVM)
        navigationController?.pushViewController(expensesListVC, animated: true)
    }

    private func setConstraints() {
        view.addSubview(salaryInfoLabel)
        view.addSubview(expensesInfoLabel)
        view.addSubview(availableMoneyInfoLabel)
        view.addSubview(earnedMoneyInfoLabel)
        view.addSubview(addExpenseButton)

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

        addExpenseButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(Constants.borderHeightMultiplier)
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
