//
//  ProfileView.swift
//  PhotoGram
//
//  Created by 마르 on 2023/08/29.
//

import UIKit

class ProfileView: BaseView {
    
    let imageView = {
        let view = UIImageView()
        view.image = UIImage(named: "500")
        view.clipsToBounds = true
        view.layer.cornerRadius = 50
        
        return view
    }()
    
    let descriptionLabel = {
        let view = UILabel()
        view.text = "이미지 수정"
        view.textColor = .systemBlue
        view.font = .systemFont(ofSize: 13)
        
        return view
    }()
    
    let tableView = {
        let view = UITableView()
        view.register(ProfileTableViewCell.self, forCellReuseIdentifier: "ProfileTableViewCell")
        
        return view
    }()
    
    override func configureView() {
        addSubview(imageView)
        addSubview(descriptionLabel)
        addSubview(tableView)
    }
    
    override func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.size.equalTo(100)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.height.equalTo(20)
        }
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
        }
    }
}
