//
//
// TimeIsMoney
// HeaderView.swift
// 
// Created by Alexander Kist on 27.11.2023.
//

import UIKit
import SnapKit

class HeaderView: UIView {

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont.boldHeaderTitile()
        return label
    }()

    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = UIFont.regularHeaderSubTitile()
        return label
    }()

    init(title: String, subtitle: String) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        self.subTitleLabel.text = subtitle

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(logoImageView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)

        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(layoutMarginsGuide.snp.top).offset(25)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(80)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview()
        }

        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
        }
    }
}
