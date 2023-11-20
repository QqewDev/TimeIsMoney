//
//
// TimeIsMoney
// ExpensesListViewController.swift
// 
// Created by Alexander Kist on 18.11.2023.
//


import UIKit

final class ExpensesListViewController: UIViewController{
    
    init(viewModel: ExpensesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error")
    }
    
    //MARK: - Private properties
    private let viewModel: ExpensesListViewModel
    
    private var expensesTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setupTableView()
        setConstraints()
    }
    
    
    //MARK: - Private methods
    
    private func setupTableView(){
        expensesTableView.dataSource = self
        expensesTableView.showsVerticalScrollIndicator = false
        expensesTableView.showsHorizontalScrollIndicator = false
        expensesTableView.separatorStyle = .singleLine
        expensesTableView.backgroundColor = .clear
        expensesTableView.register(ExpensesCell.self, forCellReuseIdentifier: "\(ExpensesCell.self)")
        expensesTableView.tableHeaderView?.backgroundColor = .background
        expensesTableView.sectionIndexColor = .mainGreen
        expensesTableView.color
        
        view.addSubview(expensesTableView)
    }
    
    private func setConstraints(){
        expensesTableView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension ExpensesListViewController: UITableViewDataSource{
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.uniqueDates.count
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = viewModel.uniqueDates[section]
        return viewModel.items[date]?.count ?? 0
    }
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = viewModel.uniqueDates[section]
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
}


