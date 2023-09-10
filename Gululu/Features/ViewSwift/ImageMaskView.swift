//
//  ImageMaskView.swift
//  Gululu
//
//  Created by Ray Xu on 15/11/2015.
//  Copyright © 2015 Ray Xu. All rights reserved.
//

import UIKit

class ImageMaskView: UIView {
    let maskLayer = CAShapeLayer()
    var imageView = UIImageView()
    var imagePath: String?
    var image_web_url: String?
    fileprivate let count = 8
    fileprivate let inset: CGFloat = 10
    fileprivate var lw: CGFloat = 6
    fileprivate let lineColor = UIColor.white
    fileprivate var bezierPath: UIBezierPath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    fileprivate func setup() {
		self.addSubview(imageView)
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        if let path = bezierPath {
            lineColor.setStroke()
            path.stroke()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        lw = self.frame.width/10
        
        let w = bounds.width
        let h = bounds.height
        
        let path = UIBezierPath()
        let startPoint = CGPoint(x: w/2, y: lw/2)
        var end = CGPoint(x: w-lw/2, y: h/2)
        
        var start = startPoint
        path.move(to: start)
        
        var c1 = CGPoint(x: start.x + w/4, y: start.y)
        var c2 = CGPoint(x: end.x, y: end.y - h*6/16)
        path.addCurve(to: end, controlPoint1: c1, controlPoint2: c2)
        
        start = end
        end = CGPoint(x: w/2, y: h-lw/2)
        c1 = CGPoint(x: start.x , y: start.y + h*6/16)
        c2 = CGPoint(x: end.x + (w-lw)/4, y: end.y )
        path.addCurve(to: end, controlPoint1: c1, controlPoint2: c2)
        
        start = end
        end = CGPoint(x:lw/2, y:h/2)
        c1 = CGPoint(x: start.x-(w-lw)/4, y: start.y)
        c2 = CGPoint(x: end.x, y: end.y+h*6/16 )
        path.addCurve(to: end, controlPoint1: c1, controlPoint2: c2)
        
        start = end
        end = CGPoint(x: w/2, y: lw/2)
        c1 = CGPoint(x: start.x, y: start.y-h*6/16)
        c2 = CGPoint(x: end.x-(w-lw)/4, y: end.y )
        
        path.addCurve(to: startPoint, controlPoint1: c1, controlPoint2: c2)
        path.move(to: startPoint)
        path.lineWidth = lw
        path.close()
        
        imageView.frame = bounds
        bezierPath = path
        
        maskLayer.path = path.cgPath
        maskLayer.opacity=1.0

        if(image_web_url != nil){
            let placeImage = UIImage(named: "Portrait")
            imageView.sd_setImage(with:URL(string: image_web_url!), placeholderImage: placeImage)
        }else{
            getImageFromDocument()
        }
        imageView.layer.mask = maskLayer
        setNeedsDisplay()
    }
    
    func getImageFromDocument() {
        let profileImage:UIImage
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        if  imagePath == nil  || imagePath!.isEmpty || imagePath?.range(of: "http") != nil {
            profileImage = UIImage(named: "Portrait")!
        } else {
            let fileURL = (imagePath?.contains("Documents") == true ) ? URL(fileURLWithPath:  imagePath!) : documentsURL.appendingPathComponent(imagePath!)
            let fileManager = FileManager.default
            
            if fileManager.fileExists(atPath: fileURL.path){
                profileImage = UIImage(contentsOfFile: fileURL.path)!
            }else{
                profileImage = UIImage(named: "Portrait")!
            }
        }
        imageView.image =  profileImage
    }
    
    
}
