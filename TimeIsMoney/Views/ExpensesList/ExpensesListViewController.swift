//
//
// TimeIsMoney
// ExpensesListViewController.swift
//
// Created by Alexander Kist on 18.11.2023.
//

import UIKit

final class ExpensesListViewController: UIViewController {

    weak var coordinator: AppCoordinator?

    // MARK: - Init
    init(viewModel: ExpensesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Error")
    }

    // MARK: - Private properties
    private let viewModel: ExpensesListViewModel

    private var expensesTableView = UITableView()

    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Траты"
        setupTableView()
        setConstraints()
        setupNavBar()
    }

    // MARK: - Private methods
    private func setupTableView() {
        expensesTableView.dataSource = self
        expensesTableView.showsVerticalScrollIndicator = false
        expensesTableView.showsHorizontalScrollIndicator = false
        expensesTableView.backgroundColor = .systemBackground
        expensesTableView.register(ExpensesCell.self, forCellReuseIdentifier: "\(ExpensesCell.self)")
        expensesTableView.allowsSelection = false

        view.addSubview(expensesTableView)
    }

    private func setConstraints() {
        expensesTableView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func setupNavBar() {
        navigationController?.navigationBar.tintColor = .mainGreen
        navigationController?.navigationBar.barTintColor = .systemBackground
    }
}

extension ExpensesListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.uniqueDates.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = viewModel.uniqueDates[section]
        return viewModel.items[date]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = viewModel.uniqueDates[section]
        tableView.tintColor = .mainGreen
        return "Покупки за \(date)"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ExpensesCell.self)", for: indexPath) as? ExpensesCell else {
            return UITableViewCell()
        }
        let date = viewModel.uniqueDates[indexPath.section]
        if let expense = viewModel.items[date]?[indexPath.row] {
            cell.configureViews(with: expense)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let isSectionEmpty = viewModel.removeExpenseAtIndexPath(indexPath)
            if isSectionEmpty {
                tableView.deleteSections([indexPath.section], with: .automatic)
            } else {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}
