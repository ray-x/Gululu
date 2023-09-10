//
//  CSBImage.swift
//  Gululu
//
//  Created by baker on 2017/12/13.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import Foundation

class BKImage: NSObject {
    
    static func scaleImageSize(_ image: UIImage) -> UIImage{
        UIGraphicsBeginImageContext(CGSize(width: 640.0, height: 640.0))
        image.draw(in: CGRect(x: 0, y: 0, width: 640.0, height: 640.0))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    static func getImageWithColor(_ color:UIColor)->UIImage{
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}
