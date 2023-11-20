//
//
// TimeIsMoney
// HeaderView.swift
//
// Created by Alexander Kist on 20.11.2023.
//


import UIKit

final class HeaderView: UITableViewHeaderFooterView {
    
    let title = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    private func setupViews(){
        backgroundColor = .background
        
        title.textColor = .mainGreen
        title.font = UIFont.preferredFont(forTextStyle: .headline)
       
        addSubview(title)
        
        title.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
        
        title.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
    }
    
    func configure(with text: String){
        title.text = text
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
