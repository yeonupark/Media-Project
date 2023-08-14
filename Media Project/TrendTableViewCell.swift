//
//  TrendTableViewCell.swift
//  Media Project
//
//  Created by 마르 on 2023/08/12.
//

import UIKit

class TrendTableViewCell: UITableViewCell {

    @IBOutlet var rateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var posterImage: UIImageView!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        designCell()
    }
    
    func designCell() {
        view?.backgroundColor = .black
        
        posterImage.contentMode = .scaleToFill
        
        titleLabel.backgroundColor = .white
        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 16)
        
        dateLabel.textColor = .white
        dateLabel.font = .boldSystemFont(ofSize: 15)
        
        genreLabel.textColor = .white
        genreLabel.numberOfLines = 0
        genreLabel.textAlignment = .right
        genreLabel.font = .systemFont(ofSize: 14)
        
        rateLabel.textColor = .white
    }
    
}
