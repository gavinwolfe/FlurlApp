//
//  SavedTableViewCell.swift
//  Likeful
//
//  Created by Gavin Wolfe on 12/11/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit

class SavedTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
