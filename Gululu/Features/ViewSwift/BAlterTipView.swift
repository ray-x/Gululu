//
//  BAlterTipView.swift
//  Gululu
//
//  Created by Baker on 2017/10/31.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

class BAlterTipView: UIView {
    
    let popX = SCREEN_WIDTH * 0.1
    let popWidth = SCREEN_WIDTH * 0.8
    
    let popY = SCREEN_HEIGHT * 0.1
    let pop_Height = SCREEN_HEIGHT * 0.8
    
    let cornerRadius: CGFloat = 15.0
    var popHeight: CGFloat = 0
    let line_heigth: CGFloat = 20
    var direction : Int?// direction. 0 = down, 1 = up, 2 = left, 3 = right
    let view_only_tag = 20000
    
    func load_view(_ tips: String, direction: Int) {
        
//        let view =
        if !isValidString(tips){
           return
        }
        self.direction = direction
        layer.masksToBounds = true
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 3.0
        layer.cornerRadius = cornerRadius
        backgroundColor = RGB_COLOR(116, g: 101, b: 180, alpha: 1)
        self.tag = view_only_tag
        
        let tipsLabel = InsetLabel()
        tipsLabel.text = tips
        tipsLabel.textColor = .white
        tipsLabel.numberOfLines = 0
        tipsLabel.textAlignment = .center
        tipsLabel.font = UIFont(name: BASEFONT, size: 15)
        
        let width = Common.getLabWidth(labelStr: tips, font: tipsLabel.font, height: line_heigth)
        let line = width/popWidth + 1
        popHeight = 20*line + cornerRadius*2
        self.finish_animation()
        if direction >= 2{
            tipsLabel.frame = CGRect(x: cornerRadius/2, y: cornerRadius/2, width: pop_Height-cornerRadius, height: line*line_heigth)
        }else{
            tipsLabel.frame = CGRect(x: cornerRadius/2, y: cornerRadius/2, width: popWidth-cornerRadius, height: line*line_heigth)
        }

        if direction == 2 {
            tipsLabel.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
            tipsLabel.center = CGPoint(x: popHeight/2+5, y: SCREEN_HEIGHT/2-78)
        }else if direction == 3{
            tipsLabel.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
            tipsLabel.center = CGPoint(x: popHeight/2+5, y: SCREEN_HEIGHT/2-78)
        }
        self.addSubview(tipsLabel)
        presentUpView()
    }
    
    func presentUpView() {
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.5, animations: {
            self.handle_frame()
        }, completion:{(success: Bool) in
            self.perform(#selector(self.dismissView), with: self, afterDelay: 3.0)
        })
    }
    
    func handle_frame() {
        if direction == 0{
            frame = CGRect(x: popX, y:SCREEN_HEIGHT - popHeight + cornerRadius , width: popWidth, height: popHeight)
        }else if direction == 1{
            frame = CGRect(x: popX, y: -cornerRadius, width: popWidth, height: popHeight)
        }else if direction == 2{
            frame = CGRect(x: -cornerRadius, y: popY, width: popHeight, height: pop_Height)
        }else{
            frame = CGRect(x: SCREEN_WIDTH, y: popY, width: popHeight, height: pop_Height)
        }
    }
    
    @objc func dismissView() {
        if superview == nil { return }
        UIView.animate(withDuration: 0.5, animations: {
            self.finish_animation()
        }, completion:{(success: Bool) in
            self.removeFromSuperview()
        })
    }
    
    func finish_animation()  {
        if direction == 0{
            frame = CGRect(x: popX, y: SCREEN_HEIGHT, width: popWidth, height: popHeight)
        }else if direction == 1{
            frame = CGRect(x: popX, y:-popHeight, width: popWidth, height: popHeight)
        }else if direction == 2{
            frame = CGRect(x: -popHeight, y: popY, width: popHeight, height: pop_Height)
        }else{
            frame = CGRect(x: popHeight + SCREEN_WIDTH, y: popY, width: popHeight, height: pop_Height)
        }
    }

}
