//
//  BHPopupView.swift
//  Gululu
//
//  Created by Wei on 16/8/25.
//  Copyright © 2016年 Ray Xu. All rights reserved.
//

import UIKit

class BHPopupView: UIView {
    
    let alertTitleLabel = UILabel()

    fileprivate let popWidth = SCREEN_WIDTH
    fileprivate let popHeight = SCREEN_WIDTH * 0.224
    
    init() {
        super.init(frame: CGRect(x: 0.0, y: -popHeight, width: popWidth, height: popHeight))
        self.layoutPopupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Layout popup view
    func layoutPopupView() {
        backgroundColor = UIColor(red: 213.0/255.0, green: 96.0/255.0, blue: 90.0/255.0, alpha: 0.95)
        
        let spacing = popWidth * 30.0 / 375.0
        alertTitleLabel.frame = CGRect(x: spacing, y: 0.0, width: popWidth - 2*spacing, height: popHeight   )
        alertTitleLabel.textAlignment = NSTextAlignment.center
        alertTitleLabel.textColor = .white
        alertTitleLabel.font = UIFont(name: BASEFONT, size: 18.0)
        alertTitleLabel.numberOfLines = 0
        addSubview(alertTitleLabel)
    }
    
    // MARK: - Net not work
    func showNetNotWorkMessage() {
        alertTitleLabel.text = "Please check network connection and try again."
        presentPopupView()
    }
    
    // MARK: - Show message
    func showAlertMessage(_ msg: String) {
        if msg != "" && msg.count > 0 {
            alertTitleLabel.text = msg
            presentPopupView()
        }
    }
    
    // MARK: - Present popup view and dismiss
    func presentPopupView() {
        DispatchQueue.main.async {
            let window = UIApplication.shared.windows.last
            
            if self.popupViewIsInSubviews(window!) {
                return
            } else {
                window?.addSubview(self)
                UIView.animate(withDuration: 0.3, animations: {
                    self.frame = CGRect(x: 0.0, y: 0.0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT*0.12)
                    }, completion:{(success: Bool) in
                        self.perform(#selector(self.dismissPopupView), with: self, afterDelay: 5.0)
                })
            }
        }
    }
    
    func popupViewIsInSubviews(_ window: UIWindow) -> Bool {
        for view in window.subviews {
            if view.isKind(of: BHPopupView.self) {
                return true
            }
        }
        return false
    }
    
    @objc func dismissPopupView() {
        if superview == nil { return }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.frame = CGRect(x: 0.0, y: -self.frame.size.height, width: self.frame.size.width, height: self.frame.size.height)
            }, completion:{(success: Bool) in
                self.removeFromSuperview()
        })
    }
}
