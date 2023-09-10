//
//  BarView.swift
//  Gululu
//
//  Created by Ray Xu on 12/11/2015.
//  Copyright © 2015 Ray Xu. All rights reserved.
//

//
//  BarView.swift
//  Gululu
//
//  Created by Ray Xu on 12/11/2015.
//  Copyright © 2015 Ray Xu. All rights reserved.
//

import UIKit

@IBDesignable class BarView: UIView {

    var endingColor = UIColor(red: (0/255.0), green: (174/255.0), blue: (228.0/255.0), alpha: 1.0)
    var fullColor = UIColor(red: (0/255.0), green: (174/255.0), blue: (228.0/255.0), alpha: 1.0)
    var barLevel:Int=0
    fileprivate var startingColor = UIColor(red: (0/255.0), green: (109.0/255.0), blue: (255.0/255.0), alpha: 0.6)
    fileprivate var borderColor = UIColor.clear.cgColor
    fileprivate var rectanglePath = UIBezierPath()
    fileprivate var initbar:UIView?
    fileprivate var topLine:UIView?
    fileprivate var fBarLevel:CGFloat=0.1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame:CGRect, barLevel:Int)
    {
        super.init(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: frame.size.height))
        self.barLevel=barLevel
        
        topLine?.removeFromSuperview()
        topLine = UIView()
        topLine?.alpha = 0
        topLine!.layer.masksToBounds = true
        topLine!.layer.cornerRadius = 1.0
        topLine!.backgroundColor = .white
        addSubview(topLine!)
        topLine?.snp.makeConstraints({ (ConstraintMaker) in
            ConstraintMaker.left.top.equalTo(self).offset(6.0)
            ConstraintMaker.right.equalTo(self).offset(-6.0)
            ConstraintMaker.height.equalTo(2.0)
        })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let h = rect.height
        let w = rect.width

        layer.masksToBounds = true
        layer.cornerRadius = w/5
        layer.borderColor = borderColor
        layer.borderWidth = 2.0
        backgroundColor = UIColor(red: 88.0/255.0, green: 68.0/255.0, blue: 153.0/255.0, alpha: 0.8)
        
        if initbar != nil
        {
            initbar!.removeFromSuperview()
        }
        initbar = UIView(frame: CGRect(x: 2.0, y: h-2.0, width: w-4.0, height: 0.0))
        initbar!.layer.cornerRadius = (w-4.0)/5
        initbar!.layer.masksToBounds = true
        initbar!.backgroundColor = startingColor
        insertSubview(initbar!, belowSubview: topLine!)
        fBarLevel = CGFloat(barLevel)
        
        topLine?.alpha = 0
        
        if abs(fBarLevel-h) < 0.1 || fBarLevel >= h
        {
            fBarLevel = h
            topLine?.alpha = 1
        }
        else if fBarLevel<0.001
        {
            fBarLevel = 0.0
            topLine?.alpha = 0
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.initbar!.backgroundColor = self.endingColor
            if abs(self.fBarLevel) > 0
            {
                self.initbar!.frame = CGRect(x: 2.0, y: h-2.0, width: w-4.0, height: -CGFloat(self.fBarLevel)+4.0)
            }
            else
            {
                self.initbar!.frame = CGRect(x: 2.0, y: h-2.0, width: w-4.0, height: 0.0)
            }
        }) 
    }

}
