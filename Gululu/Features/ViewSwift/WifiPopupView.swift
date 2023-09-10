//
//  WifiPopupView.swift
//  Gululu
//
//  Created by Ray Xu on 6/05/2016.
//  Copyright © 2016 Ray Xu. All rights reserved.
//

import UIKit

class WifiPopupView: UIView {
    var configView: UIView!
    fileprivate let popWidth = SCREEN_WIDTH
    fileprivate let popHeight = SCREEN_WIDTH * 0.22

    @IBOutlet weak var Message: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0.0, y: -popHeight, width: popWidth, height: popHeight))
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

    func xibSetup() {
        configView = loadViewFromNib()
        configView.frame = bounds
        configView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(configView)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "WifiPopupView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func presentWifiPopUpView() {
        let window = UIApplication.shared.windows.last
        window?.addSubview(self)
            
        UIView.animate(withDuration: 0.5, animations: {
            self.frame = CGRect(x: 0.0, y: 0.0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT*0.12)
            }, completion:{(success: Bool) in
                self.perform(#selector(self.dismissWifiPopUpView), with: self, afterDelay: 3.0)
        })
    }
    
    @objc func dismissWifiPopUpView() {
        if superview == nil { return }
    
        UIView.animate(withDuration: 0.5, animations: {
            self.frame = CGRect(x: 0.0, y: -self.frame.size.height, width: self.frame.size.width, height: self.frame.size.height)
            }, completion:{(success: Bool) in
                self.removeFromSuperview()
        })
    }
}

