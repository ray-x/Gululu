//
//  ChildInfoCell.swift
//  Gululu
//
//  Created by Baker on 16/8/22.
//  Copyright © 2016年 Ray Xu. All rights reserved.
//

import UIKit

class ChildInfoCell: UITableViewCell {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
