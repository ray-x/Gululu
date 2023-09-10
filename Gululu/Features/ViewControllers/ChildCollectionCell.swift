//
//  ChildCollectionCell.swift
//  Gululu
//
//  Created by Ray Xu on 31/12/2015.
//  Copyright © 2015 Ray Xu. All rights reserved.
//

import UIKit

protocol ChildCollectionCellDelegate: NSObjectProtocol {
    func connectBottle(tag: Int)
    func tapChildAction(tag: Int)
}

class ChildCollectionCell: UICollectionViewCell, UICollectionViewDelegate {
    @IBOutlet weak var ChilldAvatar: ImageMaskView!
    @IBOutlet weak var childName: UILabel!
    @IBOutlet weak var addCupButton: UIButton!
    @IBOutlet weak var bTrailing: NSLayoutConstraint!
    @IBOutlet weak var bWidth: NSLayoutConstraint!
    
    var childid:String? = ""
    var childPetBottleStatus: ChildPetBottle?
    var delegate : ChildCollectionCellDelegate?
    
    override func awakeFromNib(){
        childName.adjustsFontSizeToFitWidth = true
        addCupButton.setBackgroundImage(UIImage(named:"addBottle"), for: .normal)
        addCupButton.addTarget(self, action:#selector(addBottleAction(_:) ), for: UIControlEvents.touchUpInside)
        
        let tapGeR = UITapGestureRecognizer()
        tapGeR.numberOfTapsRequired = 1
        tapGeR.addTarget(self, action: #selector(childAvtorTap))
        ChilldAvatar.addGestureRecognizer(tapGeR)
    }
    
    // MARK: - Reload ChildCollectionCell with child data
    func reloadChildCollectionCell(_ child: Children, tag: Int) {
        childName.text = child.childName
        if child.childID != nil  {
            loadChildProfile(child.childID!)
        }
        childid = child.childID
        childName.tag = tag
        
        childPetBottleStatus = GChild.share.checkPetAndBottleWithChild(child)
        switch childPetBottleStatus! {
        case .none, .pet:
            addCupButton.isHidden = true
            break
        case .both:
            addCupButton.isHidden = false
            addCupButton.setBackgroundImage(UIImage(named: "haveBottle") , for: .normal)
            addCupButton.tag = tag
            break
        }
    }
    
    // MARK: - Load profile with childID
    func loadChildProfile(_ childid: String) {
        let fileURL = AvatorHelper.share.getImageFromDocumentPathURLWithID(childid)
        if FileManager.default.fileExists(atPath: fileURL.path){
            ChilldAvatar.imagePath =  childid + ".jpg"
        }else{
            ChilldAvatar.imagePath = ""
        }
        ChilldAvatar.layoutSubviews()
    }
    
    // MARK: - Action of AddCupButton event
    @objc func addBottleAction(_ sender:UIButton) {
        switch childPetBottleStatus! {
        case .none ,.pet:
            return
        case .both:
            delegate?.connectBottle(tag: sender.tag)
        }
    }
    
    @objc func childAvtorTap(sender:UIGestureRecognizer){
        delegate?.tapChildAction(tag: childName.tag)
    }

}
