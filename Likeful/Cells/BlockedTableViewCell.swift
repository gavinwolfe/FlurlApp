//
//  BlockedTableViewCell.swift
//  Likeful
//
//  Created by Gavin Wolfe on 12/7/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit

class BlockedTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var mainLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
