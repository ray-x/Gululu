//
//  BHAlertView.swift
//  Gululu
//
//  Created by Wei on 6/7/16.
//  Copyright © 2016 Ray Xu. All rights reserved.
//

import UIKit

protocol BHAlertViewDelegate {
    func rightButtonDelegateAction()
    func cancleButtonDelegateAction()
}

class BHAlertView: UIView
{
    var delegate : BHAlertViewDelegate?
    let backView = UIView()
    let titleLabel = UILabel()
    let messageLabel = UILabel()
    let messageImage = UIImageView()
    let leftButton = UIButton(type: .custom)
    let rightButton = UIButton(type: .custom)
    let hLine = UILabel()
    let vLine = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutBHAlertView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutBHAlertView() {
        backView.layer.masksToBounds = true
        backView.layer.cornerRadius = 50.0
        backView.layer.borderWidth = 3.0
        backView.layer.borderColor = UIColor.white.cgColor
        backView.backgroundColor = UIColor(red: 0.0/255.0, green: 174.0/255.0, blue: 228.0/255.0, alpha: 1.0)
        addSubview(backView)

        backView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.width.equalTo(SCREEN_WIDTH*306/375)
            ConstraintMaker.centerX.equalTo(self)
            ConstraintMaker.centerY.equalTo(self).offset(-30.0)
        }
        
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: BASEBOLDFONT, size: 18.0)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = NSTextAlignment.center
        backView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.top.equalTo(backView).offset(30.0)
            ConstraintMaker.centerX.equalTo(backView)
            ConstraintMaker.width.equalTo(SCREEN_WIDTH*260/375)
        }
        
        hLine.backgroundColor = .white
        hLine.alpha = 0.8
        backView.addSubview(hLine)
        
        leftButton.titleLabel?.textColor = .white
        leftButton.titleLabel?.font = UIFont(name: BASEBOLDFONT, size: 18.0)
        leftButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        leftButton.addTarget(self, action: #selector(highlightAction(_:)), for: .touchDown)
        leftButton.addTarget(self, action: #selector(touchDragOutsideAction(_:)), for: .touchDragOutside)
        backView.addSubview(leftButton)
        
        rightButton.titleLabel?.textColor = .white
        rightButton.titleLabel?.font = UIFont(name: BASEBOLDFONT, size: 18.0)
        rightButton.addTarget(self, action: #selector(rightAction), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(highlightAction(_:)), for: .touchDown)
        rightButton.addTarget(self, action: #selector(touchDragOutsideAction(_:)), for: .touchDragOutside)
        backView.addSubview(rightButton)
        
        vLine.backgroundColor = .white
        vLine.alpha = 0.8
        backView.addSubview(vLine)
        vLine.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.top.equalTo(hLine)
            ConstraintMaker.centerX.bottom.equalTo(backView)
            ConstraintMaker.width.equalTo(1.0)
        }
    }
    
    func initAlertContent(_ title: String, message: String, leftBtnTitle: String, rightBtnTitle: String) {
        titleLabel.text = title
        leftButton.setTitle(leftBtnTitle, for: .normal)
        rightButton.setTitle(rightBtnTitle, for: .normal)
        
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.font = UIFont(name: BASEFONT, size: 18.0)
        messageLabel.numberOfLines = 0
        backView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.width.equalTo(SCREEN_WIDTH*240/375)
            ConstraintMaker.centerX.equalTo(backView)
            ConstraintMaker.top.equalTo(titleLabel.snp.bottom).offset(15.0)
        }
        
        hLine.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.right.equalTo(backView)
            ConstraintMaker.height.equalTo(1.0)
            ConstraintMaker.top.equalTo(messageLabel.snp.bottom).offset(22.0)
        }
        
        layoutAlertButtons(leftBtnTitle, rightBtnTitle: rightBtnTitle)
    }
    
    func initAlertImage(_ title: String, image: UIImage, leftBtnTitle: String, rightBtnTitle: String) {
        titleLabel.text = title
        leftButton.setTitle(leftBtnTitle, for: .normal)
        
        messageImage.image = image
        backView.addSubview(messageImage)
        messageImage.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.centerX.equalTo(backView)
            ConstraintMaker.top.equalTo(titleLabel.snp.bottom).offset(20.0)
            ConstraintMaker.size.equalTo(CGSize(width: image.size.width, height: image.size.height))
        }
        
        hLine.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.right.equalTo(backView)
            ConstraintMaker.height.equalTo(1.0)
            ConstraintMaker.top.equalTo(messageImage.snp.bottom).offset(22.0)
        }
        
        layoutAlertButtons(leftBtnTitle, rightBtnTitle: rightBtnTitle)
    }
    
    func layoutAlertButtons(_ leftBtnTitle: String, rightBtnTitle: String) {
        if rightBtnTitle == "" || rightBtnTitle.count == 0 {
            vLine.isHidden = true
            leftButton.titleEdgeInsets = UIEdgeInsetsMake(-3.0, 0.0, 0.0, 0.0)
            leftButton.snp.makeConstraints { (ConstraintMaker) in
                ConstraintMaker.left.right.bottom.equalTo(backView)
                ConstraintMaker.top.equalTo(hLine.snp.bottom)
                ConstraintMaker.height.equalTo(50.0)
            }
        } else if leftBtnTitle == "" || leftBtnTitle.count == 0 {
            vLine.isHidden = true
            rightButton.titleEdgeInsets = UIEdgeInsetsMake(-3.0, 0.0, 0.0, 0.0)
            rightButton.snp.makeConstraints { (ConstraintMaker) in
                ConstraintMaker.left.right.bottom.equalTo(backView)
                ConstraintMaker.top.equalTo(hLine.snp.bottom)
                ConstraintMaker.height.equalTo(50.0)
            }
        } else {
            vLine.isHidden = false
            leftButton.titleEdgeInsets = UIEdgeInsetsMake(-3.0, 12.0, 0.0, 0.0)
            leftButton.titleLabel?.font = UIFont(name: BASEFONT, size: 18.0)
            leftButton.snp.makeConstraints { (ConstraintMaker) in
                ConstraintMaker.left.bottom.equalTo(backView)
                ConstraintMaker.right.equalTo(vLine.snp.left)
                ConstraintMaker.top.equalTo(hLine.snp.bottom)
                ConstraintMaker.height.equalTo(50.0)
            }
            
            rightButton.setTitle(rightBtnTitle, for: .normal)
            rightButton.titleEdgeInsets = UIEdgeInsetsMake(-3.0, -5.0, 0.0, 0.0)
            rightButton.snp.makeConstraints({ (ConstraintMaker) in
                ConstraintMaker.left.equalTo(vLine.snp.right)
                ConstraintMaker.right.bottom.equalTo(backView)
                ConstraintMaker.top.equalTo(leftButton)
                ConstraintMaker.height.equalTo(50.0)
            })
        }
    }
    
    @objc func cancelAction() {
        dismissBHAlertView()
        if (delegate != nil) {
            delegate?.cancleButtonDelegateAction()
        }
    }
    
    @objc func rightAction() {
        dismissBHAlertView()
         if (delegate != nil) {
            delegate?.rightButtonDelegateAction()
        }
    }
    
    @objc func highlightAction(_ button: UIButton) {
        button.backgroundColor = UIColor(red: 0.0/255.0, green: 156.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        button.titleLabel?.alpha = 0.5
    }
    
    @objc func touchDragOutsideAction(_ button: UIButton) {
        button.backgroundColor = .clear
        button.titleLabel?.alpha = 1.0
    }
    
    func presentBHAlertView() {
        let window = UIApplication.shared.keyWindow
        if popupViewIsInSubviews(window!) {
            return
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.5)
                self.backView.alpha = 1
                }, completion:{(success: Bool) in
                    window?.addSubview(self)
            })
        }
        
    }
    
    func popupViewIsInSubviews(_ window: UIWindow) -> Bool {
//        for view in window.subviews {
//            if view.isKind(of: BHAlertView.self) {
//                return true
//            }
//        }
        return false
    }
    
    func dismissBHAlertView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.0)
            self.backView.alpha = 0
            }, completion:{(success: Bool) in
                self.removeFromSuperview()
        })
    }
}
