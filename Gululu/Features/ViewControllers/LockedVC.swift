//
//  LockedVC.swift
//  Gululu
//
//  Created by Baker on 16/12/1.
//  Copyright © 2016年 Ray Xu. All rights reserved.
//

import UIKit


class LockedVC: BaseViewController{

    var cilckStrArray : Array<String>? = []
    var numStrArray : Array<String>? = []
    @objc dynamic var isRight : Bool = false
    var vailedDate : Date = Date()
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewBgColor()
        resetNumStrArray()
        createFourLabel()
        tipLabel.text = Localizaed("To access, tap the numbers in numerical order:")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setViewBgColor() {
        //定义渐变的颜色，多色渐变太魔性了，我们就用两种颜色
        let topColor = UIColor(red: (21/255.0), green: (158/255.0), blue: (221/255.0), alpha: 1)
        let buttomColor = UIColor(red: (21/255.0), green: (158/255.0), blue: (221/255.0), alpha: 0.3)

        //将颜色和颜色的位置定义在数组内
        let gradientColors: [CGColor] = [topColor.cgColor, buttomColor.cgColor]
        let gradientLocations: [CGFloat] = [0.45, 0.72]
        
        //创建CAGradientLayer实例并设置参数
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]?
        
        //设置其frame以及插入view的layer
        gradientLayer.frame = view.frame
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func resetNumStrArray() {
        numStrArray?.removeAll()
        var arr = [0,1,2,3,4,5,6,7,8,9]
        for _ in 0...3 {
            var numInt = Int(arc4random()%10)
            if numInt > arr.count-1{
                numInt = arr.count-1
            }
            let num : String = String(format:"%d",arr[numInt])
            numStrArray?.append(num)
            arr.remove(at: numInt)
        }
    }
    
    func createFourLabel() {
        for i in 0...3 {
            let width1 : CGFloat = 52
            let x1 : CGFloat = CGFloat(i)*69 + (SCREEN_WIDTH-259)/2
            let rect : CGRect = CGRect(x: x1, y: CGFloat(180), width: width1, height: width1)
            let button : UIButton = UIButton(frame:rect)
            button.tag = i+lockViewTag
            button.layer.masksToBounds = true
            button.layer.cornerRadius = width1/2
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.borderWidth = 4.0
            button.titleLabel?.font = UIFont(name: BASEBOLDFONT, size: 26)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .clear
            button.setTitle(numStrArray?[i], for: .normal)
            button.addTarget(self, action: #selector(numberClick(_:)), for: .touchUpInside)
            view.addSubview(button)
        }
    }
    
    @objc func numberClick(_ sender: AnyObject) {
        let button : UIButton = sender as! UIButton
        let str : String? = String(format:"%@",button.currentTitle!)
        if str != nil{
            if checkRightClick(clickLocation:(cilckStrArray?.count)!, clickNum: str!){
                button.backgroundColor = UIColor(red: (63/255.0), green: (189/255.0), blue: (174/255.0), alpha: 1)
                button.isEnabled = false
                cilckStrArray?.append(str!)
                if cilckStrArray?.count == 4{
                    isRight = true
                }
            }else{
                button.backgroundColor = UIColor(red: (213/255.0), green: (96/255.0), blue: (80/255.0), alpha: 1)
                for i in 0...3{
                    let button : UIButton = view.viewWithTag(i+lockViewTag) as! UIButton
                    button.isEnabled = false
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                    self.resetAllButton()
                }
            }
        }
    }
    
    func checkRightClick(clickLocation:Int,clickNum:String) -> Bool {
        let sortArray = numStrArray?.sorted()
        let str = sortArray?[clickLocation]
        if str == clickNum{
            return true
        }
        return false
    }
    

    func resetAllButton(){
        resetNumStrArray()
        for i in 0...3{
            let button : UIButton = view.viewWithTag(i+lockViewTag) as! UIButton
            button.setTitle(numStrArray?[i], for: .normal)
            button.backgroundColor = .clear
            button.isEnabled = true
        }
        cilckStrArray?.removeAll()
    }
    
}
