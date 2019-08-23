//
//  ChatsTableViewCell.swift
//  Likeful
//
//  Created by Gavin Wolfe on 12/4/17.
//  Copyright © 2017 Gavin Wolfe. All rights reserved.
//

import UIKit

class ChatsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        self.imagerView.frame = CGRect(x: 12, y: 10, width: 50, height: 50)
        self.backView.frame = CGRect(x: 10, y: 8, width: 54, height: 54)
        self.furtherBackView.frame = CGRect(x: 8, y: 6, width: 58, height: 58)

    }

    @IBOutlet weak var furtherBackView: UIView!
    @IBOutlet weak var unseenView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var imagerView: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
