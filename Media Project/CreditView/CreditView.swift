//
//  CreditView.swift
//  Media Project
//
//  Created by 마르 on 2023/08/28.
//

import UIKit

struct cast {
    let originName: String
    let character: String
    let image: String
}

class CreditView: BaseView {

    let titleLabel = {
        let view = UILabel()
        view.backgroundColor = .white
        view.font = .boldSystemFont(ofSize: 15)
        view.numberOfLines = 0
        
        return view
    }()
    
    let contentTextView = {
        let view = UITextView()
        view.backgroundColor = .white
        view.isEditable = false
        
        return view
    }()
    
    let posterImage = {
        let view = UIImageView()
        
        return view
    }()
    
    let tableView = {
        let view = UITableView()
        view.register(CreditTableViewCell.self, forCellReuseIdentifier: "CreditTableViewCell")
        
        return view
    }()
    
    override func configureView() {
        
        for item in [titleLabel, contentTextView, posterImage, tableView] {
            addSubview(item)
        }
    }
    
    override func setConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(24)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.height.equalTo(130)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        posterImage.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
            make.leading.equalTo(contentTextView.snp.trailing).offset(8)
            make.bottom.equalTo(contentTextView.snp.bottom)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(contentTextView.snp.bottom).offset(20)
        }
    }
}
