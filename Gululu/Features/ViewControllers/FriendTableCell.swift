//
//  friendTableCell.swift
//  Gululu
//
//  Created by Ray Xu on 31/12/2015.
//  Copyright © 2015 Ray Xu. All rights reserved.
//

import UIKit

class FriendTableCell: UITableViewCell {

    @IBOutlet weak var idx:         UILabel!
    @IBOutlet weak var imageMask:   ImageMaskView!
    @IBOutlet weak var name:        UILabel!
    @IBOutlet weak var waterIdx:    UILabel!
    @IBOutlet weak var petImg:      UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: 0, green: CGFloat(147.0/255.0), blue: (200.0/255.0), alpha: 1.0)
        selectedBackgroundView = bgColorView
    }
    
    func reloadFriendTableViewCell(_ friendInfo: Friend, index: Int) {
        idx.text       = "\(index+1)"
        waterIdx.text  = friendInfo.habitScore
        
        if friendInfo.pet_model != nil{
            let petImageName = GPet.share.getPetImageName(friendInfo.pet_model)
            petImg.image = UIImage(named: petImageName)
        }
        
        name.text      = friendInfo.nickname
        if friendInfo.x_child_sn == activeChildID {
            name.font = UIFont(name: BASEBOLDFONT, size: 14)
        } else {
            name.font = UIFont(name: BASEFONT, size: 15)
        }
        
        let imagePath: String! = (friendInfo.x_child_sn)! + ".jpg"
        
        imageMask.imagePath = imagePath
       
        imageMask.layoutSubviews()
        
        if index % 2 == 0 {
            backgroundColor = UIColor(red: 0, green: CGFloat(149.0/255), blue: CGFloat(219.0/255), alpha: 1.0)
        } else {
            backgroundColor = UIColor(red: 0, green: CGFloat(174.0/255.0), blue: CGFloat(228.0/255.0), alpha: 1.0)
        }
    }
}
