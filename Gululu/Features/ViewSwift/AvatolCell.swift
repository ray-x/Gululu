//
//  AvatolCell.swift
//  Gululu
//
//  Created by baker on 2018/6/22.
//  Copyright © 2018年 Ray Xu. All rights reserved.
//

import UIKit

class AvatolCell: UICollectionViewCell {
    
   var avatorImage: ImageMaskView?
   
    //cell的高度APPHEIGHT*3/7
    override  init(frame: CGRect) {
        super.init(frame: frame)
        
        avatorImage = ImageMaskView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        self.contentView.addSubview(avatorImage!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
