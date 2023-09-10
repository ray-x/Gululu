//
//  GULabelUtil.swift
//  Gululu
//
//  Created by Baker on 16/8/7.
//  Copyright © 2016年 Ray Xu. All rights reserved.
//

import Foundation

class GULabelUtil {
    //
    
    func setJustPrivacyPolicyButton(_ needUnderLineStr: String?) -> NSMutableAttributedString? {
        guard isValidString(needUnderLineStr) else {
            return nil
        }
        let attributedString = NSMutableAttributedString(string: needUnderLineStr!)
        let para : NSMutableParagraphStyle = NSMutableParagraphStyle()
        para.alignment = .center
        let fout : UIFont = UIFont(name: BASEFONT, size: 14)!
        let firstAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white,NSAttributedStringKey.font:fout,NSAttributedStringKey.paragraphStyle:para]
        let whiteAttributes : [NSAttributedStringKey : Any]? = [NSAttributedStringKey(rawValue: NSAttributedStringKey.underlineStyle.rawValue): 1,NSAttributedStringKey.font:fout]
        
        attributedString.addAttributes(whiteAttributes!, range: NSMakeRange(0, needUnderLineStr!.count))
        attributedString.addAttributes(firstAttributes, range: NSMakeRange(0, needUnderLineStr!.count))
        
        return attributedString
    }
    
    static func setVerifyEmailTips(_ infoTextView:UITextView) -> Void {
        let labelStr = Localizaed("I haven't received the e-mail. ")
        let lineStr = Localizaed("Resend")
        let allStr = labelStr + lineStr
        let attributedString = NSMutableAttributedString(string: allStr)
        let para : NSMutableParagraphStyle = NSMutableParagraphStyle()
        para.alignment = .center
        let fout : UIFont = UIFont(name: BASEFONT, size: 14)!
        let firstAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white,NSAttributedStringKey.font:fout,NSAttributedStringKey.paragraphStyle:para]
        let whiteAttributes : [NSAttributedStringKey : Any]? = [NSAttributedStringKey(rawValue: NSAttributedStringKey.underlineStyle.rawValue): 1,NSAttributedStringKey.font:fout]
        
        let url = URL(fileURLWithPath: "sendValiedEmail")
        
        attributedString.addAttribute(NSAttributedStringKey.link, value:url , range:NSMakeRange(labelStr.count-1, lineStr.count))
        attributedString.addAttributes(whiteAttributes!, range: NSMakeRange(labelStr.count, lineStr.count))
        attributedString.addAttributes(firstAttributes, range: NSMakeRange(0, allStr.count))
        infoTextView.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue:UIColor.white]
        infoTextView.attributedText = attributedString
    }
    
    func setLogEmailInfoAttributedString(_ infoTextView:UITextView) -> Void {
        let labelStr = Localizaed("By continuing, you agree to our ")
        let lineStr = Localizaed("Privacy Policy.")
        let allStr = labelStr + lineStr
        let attributedString = NSMutableAttributedString(string: allStr)
        let para : NSMutableParagraphStyle = NSMutableParagraphStyle()
        para.alignment = .center
        let fout : UIFont = UIFont(name: BASEFONT, size: 14)!
        let firstAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white,NSAttributedStringKey.font:fout,NSAttributedStringKey.paragraphStyle:para]
        let whiteAttributes : [NSAttributedStringKey : Any]? = [NSAttributedStringKey(rawValue: NSAttributedStringKey.underlineStyle.rawValue): 1,NSAttributedStringKey.font:fout]
        
        let url = URL(fileURLWithPath: "showPrivacy")
        
        attributedString.addAttribute(NSAttributedStringKey.link, value:url , range:NSMakeRange(labelStr.count-1, lineStr.count))
        attributedString.addAttributes(whiteAttributes!, range: NSMakeRange(labelStr.count, lineStr.count))
        attributedString.addAttributes(firstAttributes, range: NSMakeRange(0, allStr.count))
        infoTextView.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue:UIColor.white]
        infoTextView.attributedText = attributedString
    }
    
    static func setPrivacyVCTips(_ infoTextView:UITextView) -> Void {
        let labelStr = Localizaed("I agree to the ")
        let termsStr = Localizaed("Terms of Use")
        let and = Localizaed(" and ")
        let lineStr = Localizaed("Privacy Policy")
        let allStr = labelStr + termsStr + and + lineStr
        let attributedString = NSMutableAttributedString(string: allStr)
        let para : NSMutableParagraphStyle = NSMutableParagraphStyle()
        para.alignment = .left
        let fout : UIFont = UIFont(name: BASEFONT, size: 14)!
        
        let firstAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white,NSAttributedStringKey.font:fout,NSAttributedStringKey.paragraphStyle:para]
        
        let whiteAttributes : [NSAttributedStringKey : Any]? = [NSAttributedStringKey(rawValue: NSAttributedStringKey.underlineStyle.rawValue): 1,NSAttributedStringKey.font:fout]
        
        let url1 = URL(fileURLWithPath: "showTerms")
        let url2 = URL(fileURLWithPath: "showPrivacy")
        
        attributedString.addAttribute(NSAttributedStringKey.link, value:url1 , range:NSMakeRange(labelStr.count - 1, termsStr.count))
        attributedString.addAttribute(NSAttributedStringKey.link, value:url2 , range:NSMakeRange(labelStr.count + termsStr.count + and.count - 1, lineStr.count))

        attributedString.addAttributes(whiteAttributes!, range: NSMakeRange(labelStr.count, termsStr.count))
        
        attributedString.addAttributes(whiteAttributes!, range: NSMakeRange(labelStr.count + termsStr.count + and.count, lineStr.count))

        attributedString.addAttributes(firstAttributes, range: NSMakeRange(0, allStr.count))
        infoTextView.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue:UIColor.white]
        infoTextView.attributedText = attributedString
        
    }
    
    func setAllLineAttributedString(_ infoTextView:UITextView,UrlStr:String) -> Void {
        let attributedString = NSMutableAttributedString(string: infoTextView.text)
        let fout : UIFont = UIFont(name: BASEFONT, size: 14)!
        
        let url = URL(fileURLWithPath: UrlStr)
        
        attributedString.addAttribute(NSAttributedStringKey.link, value:url , range:NSMakeRange(0, infoTextView.text.count))
        
        let para : NSMutableParagraphStyle = NSMutableParagraphStyle()
        para.alignment = .center
        
        let whiteAttributes: [NSAttributedStringKey : Any]? = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue) : UIColor.white,NSAttributedStringKey.underlineStyle:1,NSAttributedStringKey.font:fout,NSAttributedStringKey.paragraphStyle:para]
        
        attributedString.addAttributes(whiteAttributes!, range: NSMakeRange(0, infoTextView.text.count))
        
        infoTextView.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue:UIColor.white]
        
        infoTextView.attributedText = attributedString
    }
    
    func setViewNormolStyle(_ infoTextView:UITextView){
        let attributedString = NSMutableAttributedString(string: infoTextView.text)
        let fout : UIFont = UIFont(name: BASEFONT, size: 18)!
        let para : NSMutableParagraphStyle = NSMutableParagraphStyle()
        para.alignment = .center
        let whiteAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white,NSAttributedStringKey.font:fout,NSAttributedStringKey.paragraphStyle:para]
         attributedString.addAttributes(whiteAttributes, range: NSMakeRange(0, infoTextView.text.count))
         infoTextView.attributedText = attributedString
    }
    
    func setLabelWithUserNameLeftAttributedString(_ label:UILabel,originStr:String, userAccount:String?) -> Void {
        
        let attributedString = NSMutableAttributedString(string: label.text!)
        let fout : UIFont = UIFont(name: BASEFONT ,size: 18)!
        let para : NSMutableParagraphStyle = NSMutableParagraphStyle()
        para.alignment = .left
        let userNameInoriAttributes : [NSAttributedStringKey : Any]? = [NSAttributedStringKey(rawValue: NSAttributedStringKey.obliqueness.rawValue):0.25,NSAttributedStringKey.paragraphStyle:para]
        let emailRange  =  NSMakeRange(originStr.count+1, (userAccount?.count)!+1)
        attributedString.addAttributes(userNameInoriAttributes!, range: emailRange)
        
        let whiteAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white,NSAttributedStringKey.font:fout]
        attributedString.addAttributes(whiteAttributes, range: NSMakeRange(0,label.text!.count))
        label.attributedText = attributedString
    }
    
    func setLabelWithUserNameCenterAttributedString(_ label:UILabel,originStr:String) -> Void {
        let attributedString = NSMutableAttributedString(string: label.text!)
        let fout : UIFont = UIFont(name: BASEFONT ,size: 18)!
        let para : NSMutableParagraphStyle = NSMutableParagraphStyle()
        para.paragraphSpacing = 10
        para.alignment = .center
        let originStrAtt = [NSAttributedStringKey.paragraphStyle:para]
        attributedString.addAttributes(originStrAtt, range: NSMakeRange(0, originStr.count))
        let userNameInoriAttributes: [NSAttributedStringKey : Any]? = [NSAttributedStringKey(rawValue: NSAttributedStringKey.obliqueness.rawValue):0.25,NSAttributedStringKey.paragraphStyle:para]
        let emailRange  =  NSMakeRange(originStr.count+1, (GUser.share.email?.count)!+1)
        attributedString.addAttributes(userNameInoriAttributes!, range: emailRange)
        
        let whiteAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white,NSAttributedStringKey.font:fout]
        attributedString.addAttributes(whiteAttributes, range: NSMakeRange(0,label.text!.count))
        label.attributedText = attributedString
    }
    
    func setTextViewWithUserNameAttributedString(_ label:UITextView,originStr:String) -> Void {
        let attributedString = NSMutableAttributedString(string: label.text!)
        let fout : UIFont = UIFont(name: BASEFONT ,size: 18)!

        let userNameInoriAttributes = [NSAttributedStringKey.obliqueness:0.25]
        let emailRange  =  NSMakeRange(originStr.count+1, (GUser.share.email?.count)!)
        attributedString.addAttributes(userNameInoriAttributes, range: emailRange)
        
        let whiteAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white,NSAttributedStringKey.font:fout]
        attributedString.addAttributes(whiteAttributes, range: NSMakeRange(0,label.text.count))
        label.attributedText = attributedString
    }
    
    func setLabelWithUserNameAttributedStringCenter(_ label:UITextView,originStr:String) -> Void {
        let attributedString = NSMutableAttributedString(string: label.text!)
        let fout : UIFont = UIFont(name: BASEFONT ,size: 18)!
        let para : NSMutableParagraphStyle = NSMutableParagraphStyle()
        para.alignment = .center
        let userNameInoriAttributes = [NSAttributedStringKey.obliqueness:0.25]
        let emailRange  =  NSMakeRange(originStr.count+1, (GUser.share.email?.count)!)
        attributedString.addAttributes(userNameInoriAttributes, range: emailRange)
        
        let whiteAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white,NSAttributedStringKey.font:fout,NSAttributedStringKey.paragraphStyle:para]
        attributedString.addAttributes(whiteAttributes, range: NSMakeRange(0,label.text.count))
        label.attributedText = attributedString
    }
    
    func setSchoolModelVCNoticeLabel(_ label:UILabel) {
        let frontStr = Localizaed("School mode will take effect")
        let attributedString = NSMutableAttributedString(string: label.text!)
        let fout : UIFont = UIFont(name: BASEFONT ,size: 18)!
        let boardFout : UIFont = UIFont(name: BASEBOLDFONT,size: 18)!
        
        let frontAttributes = [NSAttributedStringKey.font:fout]
        let boardfrontAttributes = [NSAttributedStringKey.font:boardFout]
        
        attributedString.addAttributes(frontAttributes, range: NSMakeRange(0, frontStr.count))
        
        attributedString.addAttributes(boardfrontAttributes, range: NSMakeRange(frontStr.count, (label.text?.count)!-frontStr.count))
        label.attributedText = attributedString
    }
    
}
