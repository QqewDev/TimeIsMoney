//
//
// TimeIsMoney
// ExpensesCell.swift
//
// Created by Alexander Kist on 19.11.2023.
//

import UIKit
import SnapKit

private enum Constants {
    static let viewVerticalInset: CGFloat  = 10
    static let viewHorizontalInset: CGFloat = 20
}

final class ExpensesCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let stackView = UIStackView()

    private func setupViews() {
        stackView.axis = .horizontal

        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(priceLabel)

        contentView.backgroundColor = .systemBackground

        nameLabel.textColor = .mainGreen
        priceLabel.textColor = .mainGreen

        contentView.addSubview(stackView)
    }

    private func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).inset(Constants.viewVerticalInset)
            make.leading.equalTo(contentView.snp.leading).inset(Constants.viewHorizontalInset)
            make.trailing.equalTo(contentView.snp.trailing).inset(Constants.viewHorizontalInset)
            make.bottom.equalTo(contentView.snp.bottom).inset(Constants.viewVerticalInset)
        }
    }

    func configureViews(with expense: DailyExpenseRealmModel) {
        nameLabel.text = expense.name
        priceLabel.text = "\(expense.coast)₽"
    }
}
