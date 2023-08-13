//
//  CreditTableViewCell.swift
//  Media Project
//
//  Created by 마르 on 2023/08/13.
//

import UIKit

class CreditTableViewCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    @IBOutlet var roleName: UILabel!
    @IBOutlet var profileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.contentMode = .scaleToFill
        
        name.font = .boldSystemFont(ofSize: 15)
        roleName.font = .systemFont(ofSize: 14)
        roleName.textColor = .darkGray
        
    }


}
