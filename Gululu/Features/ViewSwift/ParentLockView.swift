//
//  ParentLockView.swift
//  Gululu
//
//  Created by baker on 2018/6/13.
//  Copyright © 2018年 Ray Xu. All rights reserved.
//

import Foundation

class ParentLockView: UIView , UITextFieldDelegate, ILockView {
    
    var handleDone : handleBlock?

    func locked_done(block: ILockView.handleBlock?) {
        self.handleDone = block!
    }
    
    func showLock() {
        setLockedTimeInSetting()
        if(checkSuccess)
        {
            let eclapsedTime = Date().timeIntervalSince(vailedDate)
            if eclapsedTime >= lockedTime {
                reseatUI()
                UIApplication.shared.windows.first?.addSubview(self)
            }else{
                lock_done_success()
            }
        }else{
            UIApplication.shared.windows.first?.addSubview(self)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.endEditing(true)
    }
    
    private var lockedTime : TimeInterval = 1

    private var inputText = UITextField()
    private var warningText = UILabel()
    private var minAge = 13
    private var MaxAge = 100
    private var checkSuccess = false
    private var vailedDate : Date = Date()
    
//    typealias handleBlock = ()->()
//
//
//    func callBlock(block:handleBlock?) {
//        self.handleDone = block
//    }
        
    override init(frame: CGRect) {
        super.init(frame: (UIApplication.shared.windows.first?.frame)!)
        setViewBgColor()
        ceateCloseButton()
        setTitleLabel()
        setInputTextView()
        setEnterButton()
        setWarningText()
//        handleDone = ILockView.showLock()
    }
    
    func setLockedTimeInSetting() {
        if Common.checkPreferredLanguagesIsEn(){
            lockedTime = 1
        }else{
            lockedTime = 10
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reseatUI()  {
        checkSuccess = false
        warningText.isHidden = true
        inputText.text = nil
    }
    
    func resetDate()
    {
        vailedDate = Date()
    }
    
    func ceateCloseButton() {
        let close_button = UIButton(frame: CGRect(x: SCREEN_WIDTH-45, y: 20, width: 45, height: 85))
        close_button.setImage(UIImage(named: "back_error"), for: .normal)
        close_button.addTarget(self, action: #selector(close(_:)), for: .touchUpInside)
        self.addSubview(close_button)
    }
    
    @objc func close(_ sender: AnyObject) {
        self.removeFromSuperview()
    }
    
    func setTitleLabel()  {
        let titleLabel = UILabel(frame:CGRect(x: 30, y: SCREEN_HEIGHT * 0.2, width: SCREEN_WIDTH-60, height: 80))
        titleLabel.text = Localizaed("Please enter your birth year:");
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: BASEFONT, size: 20)
        titleLabel.textAlignment = .center
        self.addSubview(titleLabel)
    }
    
    func setInputTextView() {
        inputText = UITextField(frame: CGRect(x: (SCREEN_WIDTH-150)/2, y: SCREEN_HEIGHT * 0.2 + 100, width: 150, height: 50))
        inputText.layer.borderColor = UIColor.white.cgColor
        inputText.layer.borderWidth = 2.0
        inputText.borderStyle = .line
        inputText.delegate = self
        inputText.textColor = .white
        inputText.layer.cornerRadius = 2
        inputText.keyboardType = .numberPad
        inputText.returnKeyType = .go
        inputText.attributedPlaceholder =  NSAttributedString(string: "YYYY", attributes:[NSAttributedStringKey.foregroundColor : UIColor(red: 255, green: 255, blue: 255, alpha: 0.5), NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 40)])
        inputText.font = UIFont(name: BASEFONT, size: 40)
        inputText.textAlignment = .center
        self.addSubview(inputText)
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(string == "")
        {
            return true
        }else{
            if(inputText.text?.count == 4){
                return false
            }
            warningText.isHidden = true
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkEnter()
        return true
    }
    
    
    func setEnterButton() {
        let enter_button = UIButton(frame:CGRect(x: (SCREEN_WIDTH - FIT_SCREEN_WIDTH(80))/2 , y: SCREEN_HEIGHT * 0.7, width: FIT_SCREEN_WIDTH(80), height: FIT_SCREEN_WIDTH(70)))
        enter_button.setBackgroundImage(UIImage(named: "button copy 2"), for: .normal)
        enter_button.setTitle(Localizaed("Enter"), for: .normal)
        enter_button.addTarget(self, action: #selector(checkEnter), for: .touchUpInside)
        self.addSubview(enter_button)
    }
    
    @objc func checkEnter()
    {
        if(inputText.text?.count == 0)
        {
            return
        }
        if(checkInputStringValied(inputText.text!)){
            lock_done_success()
        }else{
            warningText.isHidden = false
        }
    }
    
    func lock_done_success() {
        self.removeFromSuperview()
        self.checkSuccess = true
        self.resetDate()
        self.handleDone!()
    }
    
    func setWarningText() {
        warningText = UILabel(frame:CGRect(x: 30, y: SCREEN_HEIGHT * 0.5, width: SCREEN_WIDTH - 60, height: 80))
        warningText.font = UIFont(name: BASEFONT, size: 20)
        warningText.numberOfLines = 0
        warningText.textColor = RGB_COLOR(184, g: 102, b: 129, alpha: 0.8)
        warningText.textAlignment = .center
        warningText.text = Localizaed("We are sorry. You are not eligible to enter this page.")
        warningText.isHidden = true
        self.addSubview(warningText)
    }
    
    func checkInputStringValied(_ input: String) -> Bool {
        let currnetYearStr = BKDateTime.getCurDateYear()
        let currnetYear: Int = Int(currnetYearStr)!
        let inputYear: Int = Int(input)!
        let diffYear = currnetYear - inputYear
        if(diffYear > minAge && diffYear <= MaxAge)
        {
            return true
        }else{
            return false
        }
    }
    
    func setViewBgColor() {
        self.backgroundColor = MAIN_COLOR()
    }
}
