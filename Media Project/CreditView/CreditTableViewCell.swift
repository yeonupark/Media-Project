//
//  CreditTableViewCell.swift
//  Media Project
//
//  Created by 마르 on 2023/08/13.
//

import UIKit

//class CreditTableViewCell: UITableViewCell {
//
//    @IBOutlet var name: UILabel!
//    @IBOutlet var roleName: UILabel!
//    @IBOutlet var profileImage: UIImageView!
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        profileImage.contentMode = .scaleToFill
//
//        name.font = .boldSystemFont(ofSize: 15)
//        roleName.font = .systemFont(ofSize: 14)
//        roleName.textColor = .darkGray
//
//    }


//}

class CreditTableViewCell: BaseTableViewCell {
    
    let name = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 15)
        
        return view
    }()
    
    let roleName = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        view.textColor = .darkGray
        
        return view
    }()
    
    let profileImage = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        
        return view
    }()
    
    override func configureView() {
        
        contentView.addSubview(profileImage)
        contentView.addSubview(name)
        contentView.addSubview(roleName)
    }
    
    override func setConstraints() {
        
        profileImage.snp.makeConstraints { make in
            make.leadingMargin.topMargin.bottomMargin.equalTo(contentView).inset(8)
            make.width.equalTo(contentView).multipliedBy(0.2)
        }
        
        name.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview().offset(-10)
            make.height.equalTo(24)
        }
        
        roleName.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview().offset(10)
            make.height.equalTo(24)
        }
    }
    
}
