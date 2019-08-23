//
//  SelectedChatTableViewCell.swift
//  Likeful
//
//  Created by Gavin Wolfe on 12/4/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit

class SelectedChatTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
