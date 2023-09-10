//
//  BHMaskView.swift
//  Gululu
//
//  Created by Wei on 6/11/16.
//  Copyright © 2016 Ray Xu. All rights reserved.
//

import UIKit

protocol BHMaskViewDelegate: NSObjectProtocol {
    func tapOnAddBottleButton()
}

class BHMaskView: UIView {
    let backView = UIView()
    var delegate : BHMaskViewDelegate?
    var btnTag: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layoutMaskView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutMaskView() {
        backView.backgroundColor = UIColor(red: 0.0/255.0, green: 174.0/255.0, blue: 228.0/255.0, alpha: 0.8)
        backView.isUserInteractionEnabled = true
        addSubview(backView)
        backView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.edges.equalTo(self)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        backView.addGestureRecognizer(tapGesture)
    }
    
    func setMaskLayer(_ point: CGPoint, tag: Int) {
        btnTag = tag
        
        let radius: CGFloat = FIT_SCREEN_WIDTH(addchildMaskRadius)
        
        let screen = BASE_FRAME.size
        let path = UIBezierPath(rect: CGRect(x: 0.0, y: 0.0, width: screen.width, height: screen.height))
        path.append(UIBezierPath(arcCenter: point, radius: radius, startAngle: 0.0, endAngle: CGFloat(2*Double.pi), clockwise: false))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        backView.layer.mask = shapeLayer
        
        let circleView = UIImageView()
        circleView.backgroundColor = .clear
        circleView.image = UIImage(named: "focus")
        circleView.center = CGPoint(x: point.x-radius, y: point.y-radius)
        circleView.frame.size = CGSize(width: 2*radius, height: 2*radius)
        circleView.isUserInteractionEnabled = true
        addSubview(circleView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(bindBottleAction))
        circleView.addGestureRecognizer(tapGesture)
            
        let tipButton = UIButton(type: .custom)
        tipButton.setTitle(Localizaed("Tap to add a bottle!"), for: .normal)
        tipButton.setTitleColor(.white, for: .normal)
        tipButton.titleLabel?.font = UIFont(name: BASEBOLDFONT, size: 22.0)
        tipButton.addTarget(self, action: #selector(bindBottleAction), for: .touchUpInside)
        addSubview(tipButton)
        
        tipButton.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.centerY.equalTo(circleView)
            ConstraintMaker.right.equalTo(circleView.snp.leftMargin).offset(-20.0)
        }

    }
        
    @objc func bindBottleAction() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.0
        }, completion: { (success) in
            self.removeFromSuperview()
            self.delegate?.tapOnAddBottleButton()
        }) 
    }
        
    @objc func tapAction() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.0
        }, completion: { (success) in
            self.removeFromSuperview()
        }) 
    }

}
