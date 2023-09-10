//
//  TineTextField.swift
//  Gululu
//
//  Created by Baker on 16/8/11.
//  Copyright © 2016年 Ray Xu. All rights reserved.
//

import Foundation
class TintTextField: UITextField {
    
    var tintedClearImage: UIImage?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
//        setupTintColor()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        setupTintColor()
    }
    
    func setupTintColor() {
//        clearButtonMode = UITextFieldViewMode.WhileEditing
//        borderStyle = UITextBorderStyle.RoundedRect
//        layer.cornerRadius = 8.0
//        layer.masksToBounds = true
//        layer.borderColor = tintColor.CGColor
//        layer.borderWidth = 1.5
//        backgroundColor = .clearColor()
//        textColor = tintColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tintClearImage()
    }
    
    fileprivate func tintClearImage() {
        for view in subviews {
            if view is UIButton {
                let button = view as! UIButton
                if let uiImage = button.image(for: .highlighted) {
                    if tintedClearImage == nil {
                        tintedClearImage = tintImage(uiImage, color: .white)
                    }
                    button.setImage(tintedClearImage, for: .normal)
                    button.setImage(tintedClearImage, for: .highlighted)
                    button.alpha = 0.8
                }
            }
        }
    }
}


func tintImage(_ image: UIImage, color: UIColor) -> UIImage {
    let size = image.size
    
    UIGraphicsBeginImageContextWithOptions(size, false, image.scale)
    let context = UIGraphicsGetCurrentContext()
    image.draw(at: CGPoint.zero, blendMode: CGBlendMode.normal, alpha: 1.0)
    
    context!.setFillColor(color.cgColor)
    context!.setBlendMode(CGBlendMode.sourceIn)
    context!.setAlpha(1.0)
    
    let rect = CGRect(
        x: CGPoint.zero.x,
        y: CGPoint.zero.y,
        width: image.size.width,
        height: image.size.height)
    UIGraphicsGetCurrentContext()!.fill(rect)
    let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return tintedImage!
}
