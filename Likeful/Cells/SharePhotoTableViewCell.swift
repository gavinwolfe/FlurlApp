//
//  SharePhotoTableViewCell.swift
//  Likeful
//
//  Created by Gavin Wolfe on 2/23/18.
//  Copyright © 2018 Gavin Wolfe. All rights reserved.
//

import UIKit

class SharePhotoTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    let labelMain = UILabel()
    let imagerView = UIImageView()

    
    override func layoutSubviews() {
        labelMain.frame = CGRect(x: 70, y: 20, width: 200, height: 24)
        imagerView.frame = CGRect(x: 5, y: 5, width: 60, height: 60)
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
