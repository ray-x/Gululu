//
//  LoadingView.swift
//  Gululu
//
//  Created by Baker on 16/7/15.
//  Copyright © 2016年 w19787. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    var  lodingImageView : UIImageView?
    
    func beginAnimation() -> Void {
        
        frame = ScreenRect
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        tag = loadViewTag
        lodingImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 100))
        lodingImageView?.center = center
        addSubview(lodingImageView!)
        var imagesListArray :[UIImage] = []
        //use for loop
        for position in 1...18
        {
            let strImageName : String = "loading\(String(format: "%04d", position)).png"
            let image  = UIImage(named:strImageName)
            //UIImage scaleImage=UIImage.imagewithC
            imagesListArray.append(image!)
        }
        
        lodingImageView!.animationImages = imagesListArray
        lodingImageView!.animationDuration = 1
        UIView.setAnimationDelay(0.3)
        lodingImageView!.startAnimating()
        lodingImageView!.contentMode=UIViewContentMode.scaleAspectFit
    }
    
    func showLodingInView() {
        beginAnimation()
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    func stopAnimation() {
        if lodingImageView != nil {
            lodingImageView?.stopAnimating()
        }
        let window = UIApplication.shared.keyWindow?.subviews
        for view :UIView in  window!{
            if  view.tag == loadViewTag {
                view.removeFromSuperview()
            }
        }

    }

}
