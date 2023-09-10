//
//  BootPageVC.swift
//  Gululu
//
//  Created by Baker on 16/8/12.
//  Copyright © 2016年 Ray Xu. All rights reserved.
//

import UIKit

class BootPageVC: BaseViewController {

    @IBOutlet weak var hideButton: UIButton!
    
    @IBOutlet weak var tipsLabel: UILabel!
    
    @IBOutlet weak var bgMaskImageView: UIImageView!
    
    @IBOutlet weak var bootMoveImage: UIImageView!
    
    @IBOutlet weak var myPetImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bgMaskImageView.isUserInteractionEnabled = true
        myPetImage.isHidden = true
        moveLoopImageAnimation()
        mypetImageBeat()
        // Do any additional setup after loading the view.
    }
    
    func moveLoopImageAnimation() {
        UIView.animate(withDuration: 2, delay: 0, options: .repeat, animations: {
            self.bootMoveImage.frame.origin.x -= CGFloat(SCREEN_WIDTH-140)
        }, completion: nil)
    }
    
    func mypetImageBeat() {
        UIView.animate(withDuration: 2, delay: 0, options: .repeat, animations: {
            self.myPetImage.transform = CGAffineTransform(scaleX: 1.1, y: 0.9)
            }, completion: {(success: Bool) -> Void in
                    UIView.animate(withDuration: 0.15, animations: {
                    self.myPetImage.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
