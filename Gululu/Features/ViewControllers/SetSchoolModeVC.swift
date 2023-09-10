//
//  SetSchoolModeVC.swift
//  Gululu
//
//  Created by Wei on 16/4/22.
//  Copyright © 2016年 Ray Xu. All rights reserved.
//

import UIKit

enum ActiveLabelType{
	case am
	case pm
	case none
}

class SetSchoolModeVC: BaseViewController, SchoolTimesLabelDelegate, BHDatePickerDelegate, UIGestureRecognizerDelegate, UIViewControllerTransitioningDelegate{
	// MARK: Init SetSchoolModeVC
	// a boolean value to check if pushed by introductionSchoolModeViewController
	var boolIntroPush : Bool = false
	var backView = UIView()
	var switchStateLab = UILabel()
	var schoolSwitch = UISwitch()
	var amTimeLabel = SchoolTimesLabel()
	var pmTimeLabel = SchoolTimesLabel()
	var offDescripLabel = UILabel()
	var onDescripLabel = UILabel()
	var datePicker = BHDatePickerView()
	var pvHeight : CGFloat = 0.0
	var dateChanged = false
	var activeLabel = ActiveLabelType.none
	var amLabelY : CGFloat = 0.0
	var pmLabelY : CGFloat = 0.0
    var doneButton = UIButton()
    var cancleButton = UIButton()
    let helper  = GSchoolHepler.share
    var editKey = ""
        
    override func viewDidLoad(){
        super.viewDidLoad()
		layoutSetSchoolModeView()
    }

    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
	
	// MARK: ViewWillAppear && viewWillDisappear
	override func viewWillAppear(_ animated: Bool){
        normalModel()
        if checkInternetConnection(){
            getSchoolTime()
        }
    }
	
    func loadViewWithData() {
      
         if helper.schoolTime == nil || helper.schoolTime?.noonID == nil{
            switchStateLab.text = Localizaed("OFF")
            schoolSwitch.isOn = false
            hideSomeControlsWithSwitchOff()
            return
        }
        let labelNoonFH = helper.schoolTime?.noonFromHr!.intValue
        let labelNoonTH = helper.schoolTime?.noonToHr!.intValue
        
        amTimeLabel.text = String(format: "%02d:%02d - %02d:%02d", (helper.schoolTime?.morningFromHr!.intValue)!,(helper.schoolTime?.morningFromMin!.intValue)! , (helper.schoolTime?.morningToHr!.intValue)!, (helper.schoolTime?.morningToMin!.intValue)!)
        
        pmTimeLabel.text = String(format: "%02d:%02d - %02d:%02d", labelNoonFH!, (helper.schoolTime?.noonFromMin!.intValue)!, labelNoonTH!, (helper.schoolTime?.noonToMin!.intValue)!)
        
        if helper.schoolTime?.schoolModeEn == 1{
            switchStateLab.text = Localizaed("ON")
            schoolSwitch.isOn = true
            showSomeControlsWithSwitchOn()
        }else{
            switchStateLab.text = Localizaed("OFF")
            schoolSwitch.isOn = false
            hideSomeControlsWithSwitchOff()
        }
    }
	
	override func viewDidLayoutSubviews(){
		super.viewDidLayoutSubviews()
		view.layoutIfNeeded()
		if amLabelY == 0.0 { amLabelY = amTimeLabel.frame.origin.y }
		if pmLabelY == 0.0 { pmLabelY = pmTimeLabel.frame.origin.y }
	}

	// MARK: Settings for SchoolModeVC push from IntroductionSchoolModeVC
	func layoutNavigationController(){
		
		let cancelImg = UIImage(named: "backarrow")
		let cancelBtn = UIButton(type: .custom)
		cancelBtn.setImage(cancelImg, for: .normal)
		cancelBtn.frame = CGRect(x: 0.0, y: 0.0, width: (cancelImg?.size.width)!, height: (cancelImg?.size.height)!)
		cancelBtn.addTarget(self, action: #selector(SetSchoolModeVC.navigationBackAction), for: .touchUpInside)
		navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelBtn)
			let swifpeGesture = UIScreenEdgePanGestureRecognizer(target:self, action: #selector(SetSchoolModeVC.navigationBackAction))
		swifpeGesture.edges = .left
		swifpeGesture.delegate = self
		view.addGestureRecognizer(swifpeGesture)
	}
	
	@objc func navigationBackAction(){
		if boolIntroPush{
            _ = navigationController?.popToRootViewController(animated: true)
		}else{
			_ = navigationController?.popViewController(animated: true)
		}
	}
	
	// MARK: Layout SetSchoolMode View
	func layoutSetSchoolModeView(){
        
		let backImageView = UIImageView()
		backImageView.image = UIImage(named: "settingBack")
		view.addSubview(backImageView)
		backImageView.snp.makeConstraints { (ConstraintMaker) in
			ConstraintMaker.edges.equalTo(view)
		}
		
		pvHeight = SCREEN_HEIGHT*0.37
		backView.backgroundColor = .clear
		view.addSubview(backView)
		backView.snp.makeConstraints { (ConstraintMaker) in
			ConstraintMaker.top.left.right.equalTo(view)
			ConstraintMaker.height.equalTo(view.snp.height).offset(pvHeight)
		}
        
        doneButton.frame = CGRect(x: 0, y: 0, width: 60, height: 150)
        doneButton.setTitle(DONE, for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.titleLabel?.font = UIFont(name: BASEBOLDFONT, size: 18)
        view.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(doneAction(_:)), for: .touchUpInside)
        doneButton.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.top.equalTo(view).offset(20)
            ConstraintMaker.right.equalTo(view).offset(-10)
            ConstraintMaker.height.equalTo(50)
            ConstraintMaker.width.equalTo(80)
        }
        
        cancleButton.frame = CGRect(x: 0, y: 0, width: 60, height: 150)
        cancleButton.setTitle(CANCEL, for: .normal)
        cancleButton.setTitleColor(.white, for: .normal)
        cancleButton.titleLabel?.font = UIFont(name: BASEFONT, size: 18)
        view.addSubview(cancleButton)
        cancleButton.addTarget(self, action: #selector(cancleAction(_:)), for: .touchUpInside)
        cancleButton.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.top.equalTo(view).offset(20)
            ConstraintMaker.left.equalTo(view).offset(10)
            ConstraintMaker.height.equalTo(50)
            ConstraintMaker.width.equalTo(80)
        }
        
		let bookImage = UIImage(named: "book")
		let bookImageView = UIImageView()
		bookImageView.image = bookImage
		backView.addSubview(bookImageView)
		bookImageView.snp.makeConstraints { (ConstraintMaker) in
			ConstraintMaker.centerX.equalTo(backView).dividedBy(1.64)
            ConstraintMaker.centerY.equalTo(backView).dividedBy(4.11)
            ConstraintMaker.width.equalTo(backView).dividedBy(4.69)
            ConstraintMaker.height.equalTo(backView.snp.width).dividedBy(5.77)
		}
		
		let titleLabel = UILabel()
        if GChild.share.getActiveChildName() != ""{
            titleLabel.text = String(format: Localizaed("%@'s \rSchool Mode"),GChild.share.getActiveChildName())
            
            if GUser.share.activeChild?.childName?.count > 10 {
                titleLabel.text = String(format: Localizaed("%@'s School Mode"),GChild.share.getActiveChildName())
            }
        }
		titleLabel.textColor = .white
		titleLabel.font = UIFont(name: BASEBOLDFONT, size: 22.0)
        titleLabel.numberOfLines = 2
		backView.addSubview(titleLabel)
		titleLabel.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.centerY.equalTo(backView).dividedBy(4.11)
			ConstraintMaker.left.equalTo(bookImageView.snp.right).offset(18.0)
            ConstraintMaker.right.equalTo(backView)
            ConstraintMaker.height.equalTo((bookImage?.size.height)!)
		}
		
		switchStateLab.textColor = .white
		switchStateLab.font = UIFont(name: BASEBOLDFONT, size: 22.0)
		switchStateLab.sizeToFit()
		backView.addSubview(switchStateLab)
		switchStateLab.snp.makeConstraints { (ConstraintMaker) in
			ConstraintMaker.centerY.equalTo(backView).dividedBy(1.76)
			ConstraintMaker.centerX.equalTo(backView)
		}
		
		schoolSwitch.addTarget(self, action: #selector(SetSchoolModeVC.switchChanged), for: .valueChanged)
		backView.addSubview(schoolSwitch)
		schoolSwitch.snp.makeConstraints { (ConstraintMaker) in
			ConstraintMaker.top.equalTo(switchStateLab.snp.bottom).offset(6.0)
			ConstraintMaker.centerX.equalTo(backView)
		}
		
		offDescripLabel.text = Localizaed("When school mode is on, Gululu will be silent and not interact with your child within the set period of time.")
		offDescripLabel.textAlignment = NSTextAlignment.center
		offDescripLabel.textColor = .white
		offDescripLabel.numberOfLines = 0
		offDescripLabel.font = UIFont(name: BASEFONT, size: 18.0)
		backView.addSubview(offDescripLabel)
		offDescripLabel.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.width.equalTo(backView).dividedBy(1.25)
            ConstraintMaker.centerX.equalTo(backView)
			ConstraintMaker.top.equalTo(backView.snp.centerY).dividedBy(1.21)
		}
		
		amTimeLabel.delegate = self
		backView.addSubview(amTimeLabel)
		amTimeLabel.snp.makeConstraints { (ConstraintMaker) in
			ConstraintMaker.centerX.equalTo(backView)
            ConstraintMaker.centerY.equalTo(backView).dividedBy(1.2)
		}

		pmTimeLabel.delegate = self
		backView.addSubview(pmTimeLabel)
		pmTimeLabel.snp.makeConstraints { (ConstraintMaker) in
			ConstraintMaker.centerX.equalTo(backView)
            ConstraintMaker.centerY.equalTo(backView).dividedBy(1.04)
		}
		
		onDescripLabel.text = Localizaed("School mode will take effect\r\nONLY ON WEEKDAYS.")
		onDescripLabel.textAlignment = NSTextAlignment.center
		onDescripLabel.textColor = .white
		onDescripLabel.numberOfLines = 0
		onDescripLabel.font = UIFont(name: BASEFONT, size: 18.0)
		backView.addSubview(onDescripLabel)
        GULabelUtil().setSchoolModelVCNoticeLabel(onDescripLabel)
		onDescripLabel.snp.makeConstraints { (ConstraintMaker) in
			ConstraintMaker.width.equalTo(backView).dividedBy(1.25)
            ConstraintMaker.centerX.equalTo(backView)
			ConstraintMaker.top.equalTo(backView.snp.centerY).dividedBy(0.91)
		}
		
		datePicker.delegate = self
		view.addSubview(datePicker)
		datePicker.snp.makeConstraints { (ConstraintMaker) in
			ConstraintMaker.left.right.equalTo(view)
			ConstraintMaker.bottom.equalTo(view).offset(pvHeight)
			ConstraintMaker.height.equalTo(pvHeight)
		}
        
        switchStateLab.text = Localizaed("OFF")
        schoolSwitch.isOn = false
        offDescripLabel.alpha = 1.0
        onDescripLabel.alpha = 0.0
        amTimeLabel.alpha = 0.0
        pmTimeLabel.alpha = 0.0
	}
	
	func getConfigTimesLabelDate(_ timeLabel: SchoolTimesLabel, isStartTime: Bool) -> String{
		var timeStr = String()
		if isStartTime{
			timeStr = (timeLabel.text! as NSString).substring(with: NSRange(location: 0, length: 5))
		}else{
			timeStr = (timeLabel.text! as NSString).substring(with: NSRange(location: 8, length: 5))
		}
		return timeStr
	}
	
	// MARK: Events of School Switch Value Changed
	@objc func switchChanged(){
        editModel()
		if schoolSwitch.isOn{
			switchStateLab.text = Localizaed("ON")
			UIView.animate(withDuration: 0.5, animations: {
				self.showSomeControlsWithSwitchOn()
			})
		}else{
			switchStateLab.text = Localizaed("OFF")
			UIView.animate(withDuration: 0.5, animations: {
				self.hideSomeControlsWithSwitchOff()
			})
		}
	}
	
	// MARK: Set Control's Alpha By Switch's State
	func hideSomeControlsWithSwitchOff(){
		dateChanged = false
		hideTimePickerView()
		offDescripLabel.alpha = 1.0
		onDescripLabel.alpha = 0.0
		amTimeLabel.alpha = 0.0
		pmTimeLabel.alpha = 0.0
	}
	
	func showSomeControlsWithSwitchOn(){
		offDescripLabel.alpha = 0.0
		onDescripLabel.alpha = 1.0
		amTimeLabel.alpha = 1.0
		pmTimeLabel.alpha = 1.0
	}
	
	// MARK: ConfigTimesLabel Deleagte
	func selectedAreaAction(_ index: NSInteger, fpIndex: NSInteger, spIndex: NSInteger, timeLabel: SchoolTimesLabel){
        editModel()
		if index <= fpIndex{
			dateChanged = true
			timeLabel.setAlphaValueIfNecessary(fpIndex, endIndex: spIndex, changed: true, labelText: timeLabel.text!)
			setOtherTimeLableToNormal(timeLabel, firstPara: true)
			hideTimePickerView()
		}else if fpIndex < index && index <= spIndex{
			dateChanged = true
			timeLabel.setAlphaValueIfNecessary(0, endIndex: fpIndex, changed: true, labelText: timeLabel.text!)
			setOtherTimeLableToNormal(timeLabel, firstPara: false)
			hideTimePickerView()
		}else{
			activeLabel = .none
			dateChanged = false
			hideTimePickerView()
			timeLabel.setAlphaValueIfNecessary(fpIndex, endIndex: spIndex, changed: false, labelText: timeLabel.text!)
		}
	}
	
	func setOtherTimeLableToNormal(_ timeLabel: SchoolTimesLabel, firstPara: Bool){
		let curStr = getConfigTimesLabelDate(timeLabel, isStartTime: firstPara)
		if timeLabel == amTimeLabel{
			activeLabel = .am
			pmTimeLabel.setAlphaValueIfNecessary(0, endIndex: (pmTimeLabel.text!.count - 1), changed: true, labelText: pmTimeLabel.text!)
			if firstPara{
                editKey = "0"
				datePicker.setDatePcikerMinAndMaxDate("06:00", maxStr: helper.dateStrDic.object(forKey: "1") as! String, curStr: curStr)
				datePicker.toolBtn.setTitle(NEXT, for: .normal)
			}else{
                editKey = "1"
				datePicker.setDatePcikerMinAndMaxDate(helper.dateStrDic.object(forKey: "0") as! String, maxStr: helper.dateStrDic.object(forKey: "3") as! String, curStr: curStr)
				datePicker.toolBtn.setTitle(DONE, for: .normal)
			}
		}else if timeLabel == pmTimeLabel{

			
			activeLabel = .pm
			amTimeLabel.setAlphaValueIfNecessary(0, endIndex: (amTimeLabel.text!.count - 1), changed: true, labelText: amTimeLabel.text!)
			if firstPara{
                editKey = "2"
				datePicker.setDatePcikerMinAndMaxDate(helper.dateStrDic.object(forKey: "1") as! String, maxStr: helper.dateStrDic.object(forKey: "3") as! String, curStr: curStr)
                datePicker.datePickerValueChanged()
				datePicker.toolBtn.setTitle(NEXT, for: .normal)
			}else{
                editKey = "3"
				datePicker.setDatePcikerMinAndMaxDate(helper.dateStrDic.object(forKey: "2") as! String, maxStr: "20:00", curStr: curStr)
                datePicker.datePickerValueChanged()
				datePicker.toolBtn.setTitle(DONE, for: .normal)
			}
		}
	}
	
	// MARK: BHDatePickerView Delegate
	func resetDateLabelText(_ dateStr: String){
        guard dateStr.count == 5 else {
            return
        }
        helper.setKeyTotheDateStrDic(editKey, timeValue: dateStr)
        for (key, value) in helper.dateStrDic {
            let hourValue = (value as! NSString).substring(with: NSRange(location: 0, length: 2))
            let minValue = (value as! NSString).substring(with: NSRange(location: 3, length: 2))
            if (key as AnyObject) as! String == "0"{
                let oldStr = ((amTimeLabel.text)! as NSString).substring(with: NSRange(location: 5, length: (amTimeLabel.text?.count)! - 5))
                amTimeLabel.changeLabelTextValue("\(hourValue):\(minValue)\(oldStr)")
            }else if (key as AnyObject) as! String == "1"{
                let oldStr = ((amTimeLabel.text)! as NSString).substring(with: NSRange(location: 0, length: 8))
                amTimeLabel.changeLabelTextValue("\(oldStr)\(hourValue):\(minValue)")
            }else if (key as AnyObject) as! String == "2"{
                let oldStr = ((pmTimeLabel.text)! as NSString).substring(with: NSRange(location: 5, length: (pmTimeLabel.text?.count)! - 5))
                pmTimeLabel.changeLabelTextValue("\(hourValue):\(minValue)\(oldStr)")
            }else if (key as AnyObject) as! String == "3"{
                let oldStr = ((pmTimeLabel.text)! as NSString).substring(with: NSRange(location: 0, length: 8))
                pmTimeLabel.changeLabelTextValue("\(oldStr)\(hourValue):\(minValue)")
            }
        }
	}
	
	func hideDatePickerView(){
		dateChanged = false
		hideTimePickerView()
	}
	
	func trunToEndTimeSetting(){
		if activeLabel == .am{
			amTimeLabel.turnToConfigTimeLabelEnd()
		}else if activeLabel == .pm{
			pmTimeLabel.turnToConfigTimeLabelEnd()
		}
	}
	
	// MARK: Hide DatePicker
	func hideTimePickerView(){
		if dateChanged{
            var moveDis : CGFloat = 0.0
            if activeLabel == .am
            {
                if amLabelY >= SCREEN_HEIGHT - pvHeight
                {
                    moveDis = abs(amLabelY + pvHeight - SCREEN_HEIGHT) + 20
                }
            }
            else if activeLabel == .pm
            {
                if pmLabelY >= SCREEN_HEIGHT - pvHeight
                {
                    moveDis = abs(pmLabelY + pvHeight - SCREEN_HEIGHT) + 20
                }
            }
            
            backView.snp.remakeConstraints({ (ConstraintMaker) in
                ConstraintMaker.left.equalTo(0)
                ConstraintMaker.top.equalTo(-moveDis)
                ConstraintMaker.size.equalTo(CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT + pvHeight))
            })
            
            datePicker.snp.remakeConstraints { (ConstraintMaker) in
                ConstraintMaker.left.right.equalTo(view)
                ConstraintMaker.bottom.equalTo(view)
                ConstraintMaker.height.equalTo(pvHeight)
            }
		}
		else
		{
            backView.snp.remakeConstraints({ (ConstraintMaker) in
                ConstraintMaker.left.top.equalTo(0)
                ConstraintMaker.size.equalTo(CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT + pvHeight))
            })
            
            datePicker.snp.remakeConstraints({ (ConstraintMaker) in
                ConstraintMaker.left.right.equalTo(view)
                ConstraintMaker.bottom.equalTo(view).offset(pvHeight)
                ConstraintMaker.height.equalTo(pvHeight)
            })
            if amTimeLabel.text != nil {
                amTimeLabel.setAlphaValueIfNecessary(0, endIndex: 0, changed: false, labelText: amTimeLabel.text!)
                pmTimeLabel.setAlphaValueIfNecessary(0, endIndex: 0, changed: false, labelText: pmTimeLabel.text!)
            }
			
		}
	}
	
    func editModel(){
        doneButton.isHidden = false
        cancleButton.isHidden = false
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationItem.hidesBackButton = true
    }
    
    func normalModel(){
        doneButton.isHidden = true
        cancleButton.isHidden = true
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.hidesBackButton = false
    }
     
    @objc func doneAction(_ id:UIButton){
        if checkInternetConnection() {
            helper.setSchoolTimeValue()
            helper.setSwitchOnshcool(schoolSwitch.isOn)
            updateSchoolTime()
        }
    }
    
    @objc func cancleAction(_ id:UIButton){
        hideTimePickerView()
        navigationController?.setNavigationBarHidden(false, animated: true)
        _ = navigationController?.popViewController(animated: true)
    }
    
    func showNoticeAlter(){
        let mainSB = UIStoryboard(name: "Settings", bundle: nil)
        let verifyCodeVC: SyncTimeAlterView = mainSB.instantiateViewController(withIdentifier: "syncTimeVC") as! SyncTimeAlterView
        verifyCodeVC.idSelf = self
        UIApplication.shared.keyWindow?.addSubview(verifyCodeVC.view)
        verifyCodeVC.oKButton.addTarget(self, action: #selector(removetest(_:)), for: .touchUpInside)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            verifyCodeVC.turnoverImage.stopAnimating()
            verifyCodeVC.turnoverImage.isHidden = true
            verifyCodeVC.topImageView.image = UIImage(named: "syncDone")
        }
    }
    
    @objc func removetest(_ id:UIButton){
        let window = UIApplication.shared.keyWindow?.subviews
        for view :UIView in  window!{
            if  view.tag == syncViewTag {
                view.removeFromSuperview()
            }
        }
    }
}

extension SetSchoolModeVC{
    
    func updateSchoolTime() {
        helper.readSchoolTimeFromDB()
        guard  Common.checkInternetConnection() else {
            loadViewWithData()
            return
        }
        LoadingView().showLodingInView()
        helper.updateSchoolTime({ result in
            DispatchQueue.main.async {
                LoadingView().stopAnimation()
                switch result{
                case .Success:
                    self.loadViewWithData()
                    self.normalModel()
                    self.showNoticeAlter()
                case .Error:
                    self.showErrorAlter()
                }
            }
        })
    }
    
    func getSchoolTime() -> Void {
        helper.readSchoolTimeFromDB()
        guard  Common.checkInternetConnection() else {
            loadViewWithData()
            return
        }
        LoadingView().showLodingInView()
        helper.getSchoolTime({ result in
            DispatchQueue.main.async {
                LoadingView().stopAnimation()
                self.loadViewWithData()
                if result.boolValue == false {
                    self.showErrorAlter()
                }
            }
        })
    }
    
    func showErrorAlter() {
        let alertView = BHAlertView(frame: view.frame)
        alertView.initAlertContent("", message: Localizaed("Get school time error"), leftBtnTitle: DONE, rightBtnTitle: "")
        alertView.presentBHAlertView()
    }
    
}
