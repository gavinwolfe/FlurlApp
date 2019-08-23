//
//  MainTableViewCell.swift
//  Likeful
//
//  Created by Gavin Wolfe on 12/2/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        self.imagerView.frame = CGRect(x: 13, y: 7, width: 52, height: 52)
        self.backView.frame = CGRect(x: 11, y: 5, width: 56, height: 56)
        self.furtherBackView.frame = CGRect(x: 9, y: 3, width: 60, height: 60)
        self.buttonFeed.frame = CGRect(x: 9, y: 3, width: 60, height: 60)
    }
    @IBOutlet weak var furtherBackView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imagerView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var notSeenViewer: UIImageView!
    @IBOutlet weak var buttonFeed: UIButton!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
