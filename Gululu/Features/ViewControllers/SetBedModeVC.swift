//
//  SetBedModeVC.swift
//  Gululu
//
//  Created by Wei on 16/4/25.
//  Copyright © 2016年 Ray Xu. All rights reserved.
//

import UIKit

class SetBedModeVC: BaseViewController, BHDatePickerDelegate {
	var backView = UIView()
	var switchStateLab = UILabel()
	var bedTimeSwitch = UISwitch()
	var sleepTimeLabel = UILabel()
	var wakeupTImeLabel = UILabel()
	var offDescripLabel = UILabel()
	var onDescripLabel = UILabel()
	var datePicker = BHDatePickerView()
	var pvHeight : CGFloat = 0.0
	var slLabelY : CGFloat = 0.0
	var wuLabelY : CGFloat = 0.0
    var doneButton = UIButton()
    var cancleButton = UIButton()
    let helper = GSleepHelper.share
    
    override func viewDidLoad(){
        super.viewDidLoad()
		layoutSetBedModeView()
    }

    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
	
	override func viewWillAppear(_ animated: Bool){
		super.viewWillAppear(animated)
        normalModel()
        if checkInternetConnection(){
            getSleepTime()
        }
	}
    
    func loadViewWithData() {
        
        let  sleepTimeInCoreData : WakeSleep? = createObject(WakeSleep.self , objectID: activeChildID)
        if sleepTimeInCoreData == nil {
            switchStateLab.text = Localizaed("OFF")
            bedTimeSwitch.isOn = false
            hideSomeControlsWithSwitchOff()
            return
        }

        if sleepTimeInCoreData!.sleepHr?.intValue < 12 {
            let sleepValue = (sleepTimeInCoreData!.sleepHr?.intValue)! + 12
            sleepTimeInCoreData!.sleepHr = NSNumber(value: sleepValue as Int)
        }
       
        let bedTime = Localizaed("Bedtime")
        let wakeUP = Localizaed("Wake up")
        sleepTimeLabel.text = String(format: "%@:  %02d:%02d", bedTime,(sleepTimeInCoreData!.sleepHr!.intValue),(sleepTimeInCoreData!.sleepMin!.intValue))
        wakeupTImeLabel.text = String(format:"%@:  %02d:%02d", wakeUP,(sleepTimeInCoreData!.wakeHr!.intValue), (sleepTimeInCoreData!.wakeMin!.intValue))
        
        if (sleepTimeInCoreData!.sleepEn == 1){
            switchStateLab.text = Localizaed("ON")
            bedTimeSwitch.isOn = true
            showSomeControlsWithSwitchOn()
        }else{
            switchStateLab.text = Localizaed("OFF")
            bedTimeSwitch.isOn = false
            hideSomeControlsWithSwitchOff()
        }
    }
    
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}
    
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if slLabelY == 0.0 { slLabelY = sleepTimeLabel.frame.origin.y }
		if wuLabelY == 0.0 { wuLabelY = wakeupTImeLabel.frame.origin.y }
	}
	
	// MARK: Layout SetSleepMode View
	func layoutSetBedModeView() {
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

		
		let bedTimeImage = UIImage(named: "bedtime")
		let bedTImeImageView = UIImageView()
		bedTImeImageView.image = bedTimeImage
		backView.addSubview(bedTImeImageView)
		bedTImeImageView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.centerX.equalTo(backView).dividedBy(1.50)
            ConstraintMaker.centerY.equalTo(backView).dividedBy(4.11)
            ConstraintMaker.width.equalTo(backView).dividedBy(6.25)
            ConstraintMaker.height.equalTo(backView.snp.width).dividedBy(5.36)
		}
		
		let titleLabel = UILabel()
        titleLabel.text = String(format: Localizaed("%@'s \rBedtime"),GChild.share.getActiveChildName())

        if GUser.share.activeChild?.childName?.count > 10 {
            titleLabel.text = String(format: Localizaed("%@'s Bedtime"),GChild.share.getActiveChildName())
        }
		titleLabel.textColor = .white
		titleLabel.font = UIFont(name: BASEBOLDFONT, size: 22.0)
        titleLabel.numberOfLines = 2
		titleLabel.sizeToFit()
		backView.addSubview(titleLabel)
		titleLabel.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.centerY.equalTo(backView).dividedBy(4.11)
            ConstraintMaker.left.equalTo(bedTImeImageView.snp.right).offset(18.0)
            ConstraintMaker.right.equalTo(backView)
            ConstraintMaker.height.equalTo((bedTimeImage?.size.height)!)
		}
		
		switchStateLab.textColor = .white
		switchStateLab.font = UIFont(name: BASEBOLDFONT, size: 22.0)
		switchStateLab.sizeToFit()
		backView.addSubview(switchStateLab)
		switchStateLab.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.centerY.equalTo(backView).dividedBy(1.76)
            ConstraintMaker.centerX.equalTo(backView)
		}
		
		bedTimeSwitch.addTarget(self, action: #selector(SetBedModeVC.switchChanged), for: .valueChanged)
		backView.addSubview(bedTimeSwitch)
		bedTimeSwitch.snp.makeConstraints { (ConstraintMaker) in
			ConstraintMaker.top.equalTo(switchStateLab.snp.bottom).offset(6.0)
			ConstraintMaker.centerX.equalTo(backView)
		}
		
		offDescripLabel.text = Localizaed("Pet will fall asleep after bedtime, in order to help your child form healthy sleep habits.")
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

		sleepTimeLabel.isUserInteractionEnabled = true
		sleepTimeLabel.sizeToFit()
		sleepTimeLabel.font = UIFont(name: BASEBOLDFONT, size: 28.0)!
		sleepTimeLabel.textColor = .white
		sleepTimeLabel.textAlignment = NSTextAlignment.right
		backView.addSubview(sleepTimeLabel)
		sleepTimeLabel.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.centerX.equalTo(backView)
            ConstraintMaker.centerY.equalTo(backView).dividedBy(1.2)
		}
		
		let sleepTimeLabelTap = UITapGestureRecognizer(target: self, action: #selector(updateSleepTimeAction))
		sleepTimeLabel.addGestureRecognizer(sleepTimeLabelTap)
		
		wakeupTImeLabel.isUserInteractionEnabled = true
		wakeupTImeLabel.sizeToFit()
		wakeupTImeLabel.font = UIFont(name: BASEBOLDFONT, size: 28.0)!
		wakeupTImeLabel.textColor = .white
		wakeupTImeLabel.textAlignment = NSTextAlignment.right
		backView.addSubview(wakeupTImeLabel)
		wakeupTImeLabel.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.centerX.equalTo(backView)
            ConstraintMaker.centerY.equalTo(backView).dividedBy(1.04)
		}
		let wakeupTimeLabelTap = UITapGestureRecognizer(target: self, action: #selector(updateWakeupTimeAction))
		wakeupTImeLabel.addGestureRecognizer(wakeupTimeLabelTap)
		
		onDescripLabel.text = Localizaed("Pet will not play with your child within the set period of time.")
		onDescripLabel.textAlignment = NSTextAlignment.center
		onDescripLabel.textColor = .white
		onDescripLabel.numberOfLines = 0
		onDescripLabel.font = UIFont(name: BASEFONT, size: 18.0)
		backView.addSubview(onDescripLabel)
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
        bedTimeSwitch.isOn = false
        offDescripLabel.alpha = 1.0
        onDescripLabel.alpha = 0.0
        sleepTimeLabel.alpha = 0.0
        wakeupTImeLabel.alpha = 0.0
	}
	
	// MARK: Set Controls with Switch ON/OFF
	func showSomeControlsWithSwitchOn(){
		offDescripLabel.alpha = 0.0
		onDescripLabel.alpha = 1.0
		sleepTimeLabel.alpha = 1.0
		wakeupTImeLabel.alpha = 1.0
	}
	
	func hideSomeControlsWithSwitchOff(){
		offDescripLabel.alpha = 1.0
		onDescripLabel.alpha = 0.0
		sleepTimeLabel.alpha = 0.0
		wakeupTImeLabel.alpha = 0.0
	}
	
	// MARK: Bed Switch Value Changed
	@objc func switchChanged() {
        editModel()
		if bedTimeSwitch.isOn{
			switchStateLab.text = Localizaed("ON")
			UIView.animate(withDuration: 0.5, animations: {
				self.showSomeControlsWithSwitchOn()
			})
		}else{
			setDatePickerViewHidden(true, label: nil)
			switchStateLab.text = Localizaed("OFF")
			UIView.animate(withDuration: 0.5, animations: {
				self.hideSomeControlsWithSwitchOff()
			})
		}
	}
	
	// MARK: BHDatePickerView Delegate
	func resetDateLabelText(_ dateStr: String){
        guard dateStr.count == 5 else {
            return
        }
		let hourValue = (dateStr as NSString).substring(with: NSRange(location: 0, length: 2))
		let minValue = (dateStr as NSString).substring(with: NSRange(location: 3, length: 2))
        let timeValue : Float = Float(hourValue)! + (Float(minValue)!/60)

        let wak  = Localizaed("Wake up")
        let bed = Localizaed("Bedtime")

        if 5.0 <= timeValue && timeValue <= 11.0 {
            wakeupTImeLabel.text = "\(wak):  \(hourValue):\(minValue)"
        }else if 19.0 <= timeValue && timeValue <= 23.0 {
            sleepTimeLabel.text = "\(bed):  \(hourValue):\(minValue)"
        }
        helper.setDataDicValueFormKey(dateStr, timeValue: timeValue)
	}
	
	func hideDatePickerView(){
		setDatePickerViewHidden(true, label: nil)
	}
	
	func trunToEndTimeSetting(){
        updateWakeupTimeAction()
	}
	
	// MARK: Set DatePickerView Hidden or not
	func setDatePickerViewHidden(_ hidden: Bool, label: UILabel?){
		if hidden{
            backView.snp.remakeConstraints({ (ConstraintMaker) in
                ConstraintMaker.left.top.equalTo(0)
                ConstraintMaker.size.equalTo(CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT + pvHeight))
            })
            
            datePicker.snp.remakeConstraints({ (ConstraintMaker) in
                ConstraintMaker.left.right.equalTo(view)
                ConstraintMaker.bottom.equalTo(view).offset(pvHeight)
                ConstraintMaker.height.equalTo(pvHeight)
            })
			sleepTimeLabel.textColor = .white
			wakeupTImeLabel.textColor = .white
		}else{
            var moveDis : CGFloat = 0.0
            if label == sleepTimeLabel{
                if slLabelY >= SCREEN_HEIGHT - pvHeight{
                    moveDis = abs(slLabelY + pvHeight - SCREEN_HEIGHT) + 20
                }
            }else if label == wakeupTImeLabel{
                if wuLabelY >= SCREEN_HEIGHT - pvHeight{
                    moveDis = abs(wuLabelY + pvHeight - SCREEN_HEIGHT) + 20
                }
            }
            
            backView.snp.remakeConstraints({ (ConstraintMaker) in
                ConstraintMaker.left.equalTo(0)
                ConstraintMaker.top.equalTo(-moveDis)
                ConstraintMaker.size.equalTo(CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT  + pvHeight))
            })
            
            datePicker.snp.remakeConstraints { (ConstraintMaker) in
                ConstraintMaker.left.right.equalTo(view)
                ConstraintMaker.bottom.equalTo(view)
                ConstraintMaker.height.equalTo(pvHeight)
            }
		}
	}
	
	// MARK: Sleep & Wakeup Label Tap Actions
	@objc func updateSleepTimeAction() {
		sleepTimeLabel.textColor = .white
		wakeupTImeLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
		setDatePickerViewHidden(false, label: sleepTimeLabel)
		let realTime = helper.getLabelTimeStrValue(sleepTimeLabel)
		datePicker.toolBtn.setTitle(NEXT, for: .normal)
		datePicker.setDatePcikerMinAndMaxDate("19:00", maxStr: "23:00", curStr: realTime)
        editModel()
	}
	
	@objc func updateWakeupTimeAction(){
		wakeupTImeLabel.textColor = .white
		sleepTimeLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
		setDatePickerViewHidden(false, label: wakeupTImeLabel)
		let realTime = helper.getLabelTimeStrValue(wakeupTImeLabel)
		datePicker.toolBtn.setTitle(DONE, for: .normal)
		datePicker.setDatePcikerMinAndMaxDate("05:00", maxStr: "11:00", curStr: realTime)
        editModel()
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
        if checkInternetConnection(){
            helper.setSleepTimeValue()
            helper.setSwitchOnSleep(bedTimeSwitch.isOn)
            updateSleepTime()
        }
    }
    
    @objc func cancleAction(_ id:UIButton){
        hideDatePickerView()
        navigationController?.setNavigationBarHidden(false, animated: true)
        _ = navigationController?.popViewController(animated: true)
    }
    
    func showNoticeAlter() -> Void {
        let mainSB = UIStoryboard(name: "Settings", bundle: nil)
        let verifyCodeVC: SyncTimeAlterView = mainSB.instantiateViewController(withIdentifier: "syncTimeVC") as! SyncTimeAlterView
        verifyCodeVC.idSelf = self
        view.addSubview(verifyCodeVC.view)
        verifyCodeVC.oKButton.addTarget(self, action: #selector(removetest(_:)), for: .touchUpInside)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            verifyCodeVC.turnoverImage.stopAnimating()
            verifyCodeVC.turnoverImage.isHidden = true
            verifyCodeVC.topImageView.image = UIImage(named: "syncDone")
        }
    }
    
    @objc func removetest(_ id:UIButton) -> Void {
        for view :UIView in  view.subviews{
            if  view.tag == syncViewTag {
                view.removeFromSuperview()
            }
        }
    }
}

extension SetBedModeVC{

    func updateSleepTime() {
        helper.readSleepTimeFromDB()
        guard  Common.checkInternetConnection() else {
            loadViewWithData()
            return
        }
        LoadingView().showLodingInView()
        helper.updateSleepTime({ result in
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
    
    func getSleepTime() -> Void {
        helper.readSleepTimeFromDB()
        guard  Common.checkInternetConnection() else {
            loadViewWithData()
            return
        }
        LoadingView().showLodingInView()
        helper.getSleepTime({ result in
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
        alertView.initAlertContent("", message: Localizaed("Get sleep time error"), leftBtnTitle: DONE, rightBtnTitle: "")
        alertView.presentBHAlertView()
    }
    
}
