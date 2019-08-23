//
//  NewMessageTableViewCell.swift
//  Likeful
//
//  Created by Gavin Wolfe on 12/8/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit

class NewMessageTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        self.imagerView.frame = CGRect(x: 14, y: 8, width: 50, height: 50)
        self.backView.frame = CGRect(x: 12, y: 6, width: 54, height: 54)
    }

    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imagerView: UIImageView!
    @IBOutlet weak var labelMain: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
