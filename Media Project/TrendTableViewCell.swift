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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel?.textColor = .red
    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
    
}
