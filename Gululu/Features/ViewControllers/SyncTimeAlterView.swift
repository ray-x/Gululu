//
//  SyncTimeAlterView.swift
//  Gululu
//
//  Created by Baker on 16/8/9.
//  Copyright © 2016年 Ray Xu. All rights reserved.
//

import UIKit

class SyncTimeAlterView: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var turnoverImage: UIImageView!
    @IBOutlet weak var oKButton: UIButton!
    
    @IBOutlet weak var moreStepLabel: UILabel!
    @IBOutlet weak var detailInfoLabel: UILabel!
    
    var idSelf : UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moreStepLabel.text =  Localizaed("One more step:")
        detailInfoLabel.text = Localizaed("Please put your Gululu on the charging dock, and wait for the data sync to finish.")
        oKButton.setTitle(OK, for: .normal)
        view.tag = syncViewTag
        backView.layer.masksToBounds = true
        backView.layer.cornerRadius = 45
        backView.layer.borderWidth = 3
        backView.layer.borderColor = UIColor.white.cgColor
        
        oKButton.layer.masksToBounds = true
        oKButton.layer.borderWidth = 1
        oKButton.layer.borderColor = UIColor.white.cgColor
        
        turnoverImage.center = CGPoint(x: 0.3*SCREEN_WIDTH, y: 0.1*SCREEN_HEIGHT)
        
        startAnimation()
    }
    
    func startAnimation() -> Void {
        turnoverImage.isHidden = false
        // 创建动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        // 设置动画属性
        anim.toValue = 3 * -Double.pi
        anim.repeatCount = MAXFLOAT
        anim.duration = 1.5
        anim.isRemovedOnCompletion = false
        // 将动画添加到图层上
        turnoverImage.layer.add(anim, forKey: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
