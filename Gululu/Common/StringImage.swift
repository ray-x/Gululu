//
//  StringImage.swift
//  Gululu
//
//  Created by Baker on 17/4/12.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

extension UIImage{
    
    enum WaterMarkCorner{
        case TopLeft
        case TopRight
        case BottomLeft
        case BottomRight
    }
    //func addNameInMask() {
    //    maskHeadImage.image = maskHeadImage.image?.waterMarkedImage(waterMarkText: "1234", corner: .TopLeft, margin: CGPoint(x: 20, y: 20), waterMarkTextColor: .white, waterMarkTextFont: UIFont.systemFont(ofSize: 20), backgroundColor: .red)
    //}
    
    func waterMarkedImage(waterMarkText:String, corner:WaterMarkCorner = .BottomRight,
                          margin:CGPoint = CGPoint(x: 20, y: 20), waterMarkTextColor:UIColor = .white,
                          waterMarkTextFont:UIFont = UIFont.systemFont(ofSize: 20),
                          backgroundColor:UIColor = .clear) -> UIImage{
        
        let textAttributes = [NSAttributedStringKey.foregroundColor:waterMarkTextColor,
                              NSAttributedStringKey.font:waterMarkTextFont]
        let textSize = NSString(string: waterMarkText).size(withAttributes: textAttributes)
        var textFrame = CGRect(x: 0, y: 0, width: textSize.width, height: textSize.height)
        
        let imageSize = self.size
        switch corner{
        case .TopLeft:
                textFrame.origin = margin
            case .TopRight:
                textFrame.origin = CGPoint(x: imageSize.width - textSize.width - margin.x, y: margin.y)
            case .BottomLeft:
                textFrame.origin = CGPoint(x: margin.x, y: imageSize.height - textSize.height - margin.y)
            case .BottomRight:
                textFrame.origin = CGPoint(x: imageSize.width - textSize.width - margin.x,
                                           y: imageSize.height - textSize.height - margin.y)
        }
        
        UIGraphicsBeginImageContext(imageSize)
        self.draw(in:CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        NSString(string: waterMarkText).draw(in: textFrame, withAttributes: textAttributes)
        let waterMarkedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return waterMarkedImage!
    }
    
    func sycnImageinlayerImage(layerImage : UIImageView, plantImageName : String?) -> UIImage {
        guard plantImageName != nil else {
            return layerImage.image!
        }
        UIGraphicsBeginImageContext((layerImage.image?.size)!)
        layerImage.image?.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: (layerImage.image?.size)!))
        let plantImage = UIImage(named: plantImageName!)
        plantImage?.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: (layerImage.image?.size)!))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    static func cutFullImageWithView(scrollView:UIScrollView) -> UIImage
    {
        // 记录当前的scrollView的偏移量和坐标
        let currentContentOffSet:CGPoint = scrollView.contentOffset
        let currentFrame:CGRect = scrollView.frame;
        
        // 设置为zero和相应的坐标
        scrollView.contentOffset = CGPoint.zero
        scrollView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        
        // 参数①：截屏区域  参数②：是否透明  参数③：清晰度
        UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, true, UIScreen.main.scale)
        scrollView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        // 重新设置原来的参数
        scrollView.contentOffset = currentContentOffSet
        scrollView.frame = currentFrame
        
        UIGraphicsEndImageContext();
        
        return image;
    }
    
}
