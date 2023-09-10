//
//  NewLockView.swift
//  Gululu
//
//  Created by baker on 2018/4/16.
//  Copyright © 2018年 Ray Xu. All rights reserved.
//


class NewLockView: UIView , ILockView{
    func showLock() {
        if(checkSuccess)
        {
            let eclapsedTime = Date().timeIntervalSince(vailedDate)
            if eclapsedTime >= lockedTime {
                resetUI()
                UIApplication.shared.windows.first?.addSubview(self)
            }else{
                lock_done_success()
            }
        }else{
            UIApplication.shared.windows.first?.addSubview(self)
        }
    }
    
    func locked_done(block: ILockView.handleBlock?) {
        self.handleDone = block!
    }
    
    private var lockedTime : TimeInterval = 1

    var numArray : Array<Int> = []
    var numCount = 8
    var rightNum = 0
    let slider = UISlider()
    var timer: DispatchSourceTimer?
    var oneStepTime : DispatchTimeInterval = .milliseconds(1)
    let verifyCode_time : Int = 3000
    var current_time: Int = 0
    var vailedDate : Date = Date()
    var checkSuccess = false

    typealias handleBlock = () ->()
    var handleDone : handleBlock?
    
    func callBlock(block:handleBlock?) {
        self.handleDone = block
    }
    
    override init(frame: CGRect) {
        super.init(frame: (UIApplication.shared.windows.first?.frame)!)
        self.resetData()
        self.setViewBgColor()
        self.ceateCloseButton()
        self.createTipsLabel()
        self.create_slide_bar()
        self.addClickButton()
    }
    
    func resetUI()  {
        checkSuccess = false
        resetData()
        resetAllButton()
    }
    
    func resetAllButton()  {
        for i in 1...numArray.count{
            let button: UIButton = self.viewWithTag(i + lockNewViewTag) as! UIButton
            button.setTitle(String(numArray[i-1]), for: .normal)
        }
        let label: UILabel = self.viewWithTag(lockNewViewTag + 100) as! UILabel
        label.text = getNumberTips()
        slider.setValue(0, animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addClickButton() {
        for index in 0...numArray.count-1{
            let width1 : CGFloat = 50
            let x0 = (SCREEN_WIDTH-260)/2
            let x1 : CGFloat = CGFloat(index%4)*70 + x0
            let y1 : CGFloat = SCREEN_HEIGHT/2 + CGFloat(index/4)*70 - 50
            let rect : CGRect = CGRect(x: x1, y: y1, width: width1, height: width1)
            let button : UIButton = UIButton(frame:rect)
            button.tag = index + lockNewViewTag + 1
            button.layer.masksToBounds = true
            button.layer.cornerRadius = width1/2
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.borderWidth = 4.0
            button.titleLabel?.font = UIFont(name: BASEBOLDFONT, size: 26)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .clear
            button.setTitle(String(numArray[index]), for: .normal)
            
            button.addTarget(self, action: #selector(numberClickDown(_:)), for: .touchDown)

            button.addTarget(self, action: #selector(numberClickCancel(_:)), for: .touchUpInside)
            self.addSubview(button)
        }
    }
    
    func setViewBgColor() {
        //定义渐变的颜色，多色渐变太魔性了，我们就用两种颜色
        let topColor = UIColor(red: (21/255.0), green: (158/255.0), blue: (221/255.0), alpha: 1)
        let buttomColor = UIColor(red: (21/255.0), green: (158/255.0), blue: (221/255.0), alpha: 0.3)
        
        //将颜色和颜色的位置定义在数组内
        let gradientColors: [CGColor] = [topColor.cgColor, buttomColor.cgColor]
        let gradientLocations: [CGFloat] = [0.6, 0.72]
        
        //创建CAGradientLayer实例并设置参数
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]?
        
        //设置其frame以及插入view的layer
        gradientLayer.frame = self.frame
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func ceateCloseButton() {
        let close_button = UIButton(frame: CGRect(x: SCREEN_WIDTH-45, y: 0, width: 45, height: 85))
        close_button.setImage(UIImage(named: "back_error"), for: .normal)
        close_button.addTarget(self, action: #selector(close(_:)), for: .touchUpInside)
        self.addSubview(close_button)
    }
    
    func createTipsLabel() {
        let tips_label = UILabel()
        tips_label.text = getNumberTips()
        tips_label.textColor = .white
        tips_label.tag = lockNewViewTag + 100
        tips_label.textAlignment = .center
        tips_label.numberOfLines = 0
        self.addSubview(tips_label)
        
        tips_label.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.centerX.equalTo(self)
            ConstraintMaker.centerY.equalTo(self).dividedBy(2)
            ConstraintMaker.size.equalTo(CGSize(width: SCREEN_WIDTH - 50, height: FIT_SCREEN_HEIGHT(50)))
        }
    }
    
    func create_slide_bar() {
        slider.setThumbImage(UIImage(), for: .normal)
        slider.setMaximumTrackImage(UIImage(named: "lock_view_slide_bg"), for: .normal)
//        let image = UIImage(named: "lock_view_slide_white")?.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 2, 0, 2))
        slider.setMinimumTrackImage(UIImage(named: "lock_view_slide_white"), for: .normal)
        slider.setValue(0.0, animated: true)
        self.addSubview(slider)
        
        slider.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.centerX.equalTo(self)
            ConstraintMaker.centerY.equalTo(self).dividedBy(1.5)
            ConstraintMaker.size.equalTo(CGSize(width: SCREEN_WIDTH - 20, height: FIT_SCREEN_HEIGHT(30)))
        }

    }
    
    @objc func numberClickDown(_ sender: AnyObject) {
        let clickButton: UIButton = sender as! UIButton
        let clickNum = clickButton.currentTitle

        if (Int(clickNum!) != rightNum)
        {
           self.removeFromSuperview()
        }else{
            startTime()
        }
    }
    
    @objc func numberClickCancel(_ sender: AnyObject) {
        deinitTimer()
        DispatchQueue.main.async {
            self.slider.setValue(0, animated: true)
        }
        
    }
    
    func startTime(){
        timer = DispatchSource.makeTimerSource(queue: .main)
        timer?.schedule(deadline: .now(), repeating: oneStepTime)
        timer?.setEventHandler {
            self.current_time = self.current_time + 1
            let sliderValue: Float = Float(self.current_time)/Float(self.verifyCode_time)
            DispatchQueue.main.async {
                self.slider.setValue(sliderValue, animated: true)
            }
            if self.current_time >=  self.verifyCode_time{
                self.deinitTimer()
            }
        }
        timer?.resume()
    }
    
    func deinitTimer() {
        if self.current_time == 3000{
            lock_done_success()
        }
        self.current_time = 0
        if let time = timer {
            time.cancel()
        }
    }
    
    func lock_done_success()  {
        if let block  =  self.handleDone {
            self.removeFromSuperview()
            self.checkSuccess = true
            block()
        }
    }
    
    @objc func close(_ sender: AnyObject) {
        self.removeFromSuperview()
    }
    
    func resetData() {
        numArray.removeAll()
        var arr = [0,1,2,3,4,5,6,7,8,9]
        var count = arr.count
        for _ in 0...numCount-1 {
            var numInt = Int(arc4random()%UInt32(count))
            if numInt > arr.count-1{
                numInt = arr.count-1
            }
            numArray.append(arr[numInt])
            arr.remove(at: numInt)
            count  = count - 1
        }
        let numInt = Int(arc4random()%UInt32(numArray.count))
        rightNum = numArray[numInt]
    }
    
    func getNumStr(num: Int) -> String {
        switch num {
        case 0:
            return Localizaed("Zero")
        case 1:
            return Localizaed("One")
        case 2:
            return Localizaed("Two")
        case 3:
            return Localizaed("Three")
        case 4:
            return Localizaed("Four")
        case 5:
            return Localizaed("Five")
        case 6:
            return Localizaed("Six")
        case 7:
            return Localizaed("Seven")
        case 8:
            return Localizaed("Eight")
        case 9:
            return Localizaed("Nine")
        default:
            return Localizaed("Zero")
        }
    }
    
    func getNumberTips() -> String {
        let  tipsStr = String(format:Localizaed("To access, please press the number \"%@\" for 3 seconds."), getNumStr(num: rightNum))
        return tipsStr
    }
    
    
    
}
