//
//  CDViewCell.swift
//  Card_hjw
//
//  Created by hejianwu on 16/10/26.
//  Copyright © 2016年 ShopNC. All rights reserved.
//

import UIKit

class CDViewCell: UICollectionViewCell {
    
    var petImageView = FLAnimatedImageView()
    var petName : String = ""
    
    //cell的高度APPHEIGHT*3/7
    override  init(frame: CGRect) {
        super.init(frame: frame)
        
        petImageView = FLAnimatedImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        petImageView.contentMode = .scaleAspectFit
        addSubview(petImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
