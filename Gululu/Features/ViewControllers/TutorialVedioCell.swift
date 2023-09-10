//
//  TutorialVedioCell.swift
//  Gululu
//
//  Created by Baker on 17/6/29.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

class TutorialVedioCell: UITableViewCell {

    @IBOutlet weak var ThumbImageView: UIImageView!
    @IBOutlet weak var btnPlay: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ThumbImageView.layer.masksToBounds = true
        ThumbImageView.layer.cornerRadius = 6
        btnPlay.layer.masksToBounds = true
        btnPlay.layer.cornerRadius = 6
        contentView.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    

}
