//
//  UpgradeCell.swift
//  Gululu
//
//  Created by Baker on 17/1/3.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

class UpgradeCell: UITableViewCell {

    @IBOutlet weak var upgradeImage: UIImageView!
    @IBOutlet weak var upgradeTitle: UILabel!
    @IBOutlet weak var upgradeDetailInfo: UILabel!
    @IBOutlet weak var selectSignImage: UIImageView!
    
    @IBOutlet weak var detailInfoRightCon: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
        layer.cornerRadius = 6

        upgradeImage.layer.masksToBounds = true
        upgradeImage.layer.cornerRadius = upgradeImage.frame.size.width/2
        selectSignImage.image = UIImage(named: "upgradeCellAdd")
        upgradeDetailInfo.snp.remakeConstraints({ (ConstraintMaker) in
            ConstraintMaker.height.equalTo(36)
        })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func onCellSelectAnimation(_ animation : Bool) {

        selectSignImage.image = UIImage(named: "upgradeCellCut")
        detailInfoRightCon.constant = 15
        
        upgradeImage.layer.masksToBounds = true
        upgradeImage.layer.cornerRadius = 0
        
        let height = Common.getLabHeigh(labelStr: upgradeDetailInfo.text!, font: upgradeDetailInfo.font, width: upgradeDetailInfo.frame.width + 75)
        upgradeDetailInfo.snp.remakeConstraints({ (ConstraintMaker) in
            ConstraintMaker.height.equalTo(height+12)
        })
        
        let imageFrame = CGRect(x: 0, y: 0, width: frame.size.width, height: MainUpgrade.shareInstance.withToHeight*frame.width)
        if animation{
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
                self.upgradeImage.frame = imageFrame
            }, completion: nil)
        }else{
            self.upgradeImage.frame = imageFrame
        }
    }

    func offCellSelectAnimation(_ animation : Bool) {
        
        selectSignImage.image = UIImage(named: "upgradeCellAdd")
        detailInfoRightCon.constant = 98
        
        upgradeImage.layer.masksToBounds = true
        upgradeImage.layer.cornerRadius = 30
        upgradeDetailInfo.snp.remakeConstraints({ (ConstraintMaker) in
            ConstraintMaker.height.equalTo(36)
        })
        
        let imageFrame = CGRect(x: 16, y: 10, width: 60, height: 60)
        if animation{
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
                self.upgradeImage.frame = imageFrame
                self.upgradeImage.alpha = 0.0
            }, completion: nil)
        }else{
            self.upgradeImage.frame = imageFrame
        }
    }
    
}
