//
//  TrendingTableViewCell.swift
//  Media Project
//
//  Created by 마르 on 2023/08/28.
//

import UIKit

class TrendingTableViewCell: BaseTableViewCell {
//    @IBOutlet var titleLabel: UILabel!
//    @IBOutlet var rateLabel: UILabel!
//    @IBOutlet var originalTitleLabel: UILabel!
//    @IBOutlet var dateLabel: UILabel!
//    @IBOutlet var posterImage: UIImageView!
//    @IBOutlet var genreLabel: UILabel!
//    @IBOutlet var view: UIView!
    
    let titleLabel = {
        let view = UILabel()
        view.backgroundColor = .white
        view.textColor = .black
        view.font = .boldSystemFont(ofSize: 16)
        
        return view
    }()
    
    let rateLabel = {
        let view = UILabel()
        view.textColor = .white
        
        return view
    }()
    
    let originalTitleLabel = {
        let view = UILabel()
        view.backgroundColor = .lightGray
        view.textColor = .systemPink
        view.font = .boldSystemFont(ofSize: 16)
        
        return view
    }()
    
    let dateLabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = .boldSystemFont(ofSize: 15)
        
        return view
    }()
    
    let genreLabel = {
        let view = UILabel()
        view.textColor = .white
        view.numberOfLines = 0
        view.textAlignment = .right
        view.font = .systemFont(ofSize: 14)
        
        return view
    }()
    
    let posterImage = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        
        return view
    }()
    
    override func configureView() {
        contentView.backgroundColor = .black
        
        for item in [titleLabel, originalTitleLabel, posterImage, genreLabel, dateLabel, rateLabel] {
            contentView.addSubview(item)
        }
    }
    
    override func setConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(12)
            make.height.equalTo(20)
        }
        originalTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.height.equalTo(20)
            make.trailing.equalToSuperview().inset(12)
            make.leading.equalTo(titleLabel.snp.trailing)
        }
        posterImage.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(12)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        genreLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.width.equalTo(160)
            make.top.equalTo(originalTitleLabel.snp.bottom).offset(12)
        }
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.top.equalTo(genreLabel.snp.bottom).offset(12)
        }
        rateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.top.equalTo(dateLabel.snp.bottom).offset(12)
        }
        
        
    }
}
