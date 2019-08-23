//
//  ShareUserTableViewCell.swift
//  Likeful
//
//  Created by Gavin Wolfe on 12/11/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit

class ShareUserTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        self.imagerView.frame = CGRect(x: 12, y: 8, width: 50, height: 50)
    }
    @IBOutlet weak var labelMain: UILabel!
  
    @IBOutlet weak var changeView: UIView!
    
    @IBOutlet weak var imagerView: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
