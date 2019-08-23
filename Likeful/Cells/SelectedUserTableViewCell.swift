//
//  SelectedUserTableViewCell.swift
//  Likeful
//
//  Created by Gavin Wolfe on 12/3/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit

class SelectedUserTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
      
    }

    @IBOutlet weak var imagerView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

