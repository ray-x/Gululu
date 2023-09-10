//
//  SearchCell.swift
//  Gululu
//
//  Created by Baker on 2017/10/31.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var child_head_image: ImageMaskView!
    @IBOutlet weak var child_name: UILabel!
    @IBOutlet weak var child_habit_score: UILabel!
    @IBOutlet weak var child_pet_image: UIImageView!
    @IBOutlet weak var add_button: UIButton!
    
    @IBOutlet weak var add_button_height: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: 0, green: CGFloat(147.0/255.0), blue: (200.0/255.0), alpha: 1.0)
        selectedBackgroundView = bgColorView
    }
    
    func reloadFriendTableViewCell(_ friendInfo: Friend, index: Int) {
        child_habit_score.text  = friendInfo.habitScore
        
        if friendInfo.pet_model != nil{
            let petImageName = GPet.share.getPetImageName(friendInfo.pet_model)
            child_pet_image.image = UIImage(named: petImageName)
        }
        
        child_name.text      = friendInfo.nickname
        if friendInfo.x_child_sn == activeChildID {
            child_name.font = UIFont(name: BASEBOLDFONT, size: 14)
        } else {
            child_name.font = UIFont(name: BASEFONT, size: 15)
        }
        
        if friendInfo.x_child_sn == activeChildID{
            add_button.isHidden = true
        }else{
            add_button.isHidden = false
        }
        
        if friendInfo.add_friend_status == .adding{
            set_waite_add_friend()
        }else if friendInfo.add_friend_status == .add{
            set_can_add_friend()
        }else if friendInfo.add_friend_status == .ok{
            set_cannot_add_friend()
        }else{
            set_can_add_friend()
        }
        
        let imagePath: String! = (friendInfo.x_child_sn)! + ".jpg"
        child_head_image.imagePath = imagePath
        child_head_image.layoutSubviews()
        
        if index % 2 == 0 {
            backgroundColor = UIColor(red: 0, green: CGFloat(149.0/255), blue: CGFloat(219.0/255), alpha: 1.0)
        } else {
            backgroundColor = UIColor(red: 0, green: CGFloat(174.0/255.0), blue: CGFloat(228.0/255.0), alpha: 1.0)
        }
    }
    
    func set_cannot_add_friend() {
        add_button_height.constant = 27

        add_button.layer.masksToBounds = true
        add_button.layer.borderWidth = 0.0
        add_button.layer.cornerRadius = 4

        add_button.setTitle(Localizaed("Added"), for: .normal)
        add_button.isEnabled = false
        add_button.setBackgroundImage(UIImage(named: ""), for: .normal)
        add_button.backgroundColor = RGB_COLOR(0, g: 135, b: 208, alpha: 1)
        add_button.setTitleColor(.white, for: .normal)
    }
    
    func set_can_add_friend()  {
        add_button_height.constant = add_button.frame.width*38/55

        add_button.layer.masksToBounds = false
        add_button.setTitle(Localizaed("Add"), for: .normal)
        add_button.isEnabled = true
        add_button.setBackgroundImage(UIImage(named: "Button6"), for: .normal)
        add_button.backgroundColor = .clear
        add_button.setTitleColor(.white, for: .normal)
    }
    
    func set_waite_add_friend() {
        add_button_height.constant = 27

        add_button.layer.masksToBounds = true
        add_button.layer.cornerRadius = 4
        
        add_button.setTitle(Localizaed("Sent"), for: .normal)
        add_button.isEnabled = false
        add_button.setBackgroundImage(UIImage(named: ""), for: .normal)
        add_button.backgroundColor = RGB_COLOR(116, g: 101, b: 180, alpha: 1)
        add_button.setTitleColor(.white, for: .normal)
    }

}
