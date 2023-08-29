//
//  ProfileTableViewCell.swift
//  PhotoGram
//
//  Created by 마르 on 2023/08/29.
//

import UIKit

class ProfileTableViewCell: BaseTableViewCell {
    
    let label = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 15)
        return view
    }()
    
    let textField = {
        let view = UITextField()
        view.font = .systemFont(ofSize: 15)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    override func configureView() {
        super.configureView()
        
        contentView.addSubview(label)
        contentView.addSubview(textField)
    }
    
    override func setConstraints() {
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
            make.width.equalTo(100)
        }
        textField.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(label.snp.trailing)
        }
    }
    
}
