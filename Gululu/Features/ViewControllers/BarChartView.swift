//
//  BarChartView.swift
//  Gululu
//
//  Created by Ray Xu on 12/11/2015.
//  Copyright © 2015 Ray Xu. All rights reserved.
//

import UIKit

@IBDesignable class BarChartView: UIView {
    
    let lineLabel   = UILabel()
    let yHigh       = UILabel()
    
    let numBars=7
    
    var barWidth: Int = 0
    var barHeight: Int = 0
    var margin = 0
    let maxBars: Int = 10
    
    var barLocation: [(x:Int,y:Int)] = []
    var barIntHeight = [Int](repeating: 0, count: 7)
    var barViews: [BarView] = []
    
    var barColor: UIColor! = UIColor(red: (0/255.0), green: (174/255.0), blue: (228.0/255.0), alpha: 1.0)
    var barFullColor: UIColor! = UIColor(red: (20/255.0), green: (213/255.0), blue: (225.0/255.0), alpha: 1.0)

    override init(frame: CGRect){
        super.init(frame: frame)
        self.load_rect()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        self.load_rect()
    }
    
    func load_rect()  {
        lineLabel.tag = water_bar_line_tag
        self.addSubview(lineLabel)
        lineLabel.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.equalTo(self)
            ConstraintMaker.width.equalTo(FIT_SCREEN_WIDTH(40))
            ConstraintMaker.height.equalTo(2.0)
            ConstraintMaker.top.equalTo(FIT_SCREEN_WIDTH(0))
        }
        
        yHigh.sizeToFit()
        yHigh.numberOfLines = 2
        yHigh.textAlignment = NSTextAlignment.center
        yHigh.font = UIFont(name: BASEFONT, size: 14.0)
        yHigh.adjustsFontSizeToFitWidth = true
        yHigh.tag = water_bar_y_tag
        self.addSubview(yHigh)
        yHigh.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.width.equalTo(lineLabel)
            ConstraintMaker.left.equalTo(self)
            ConstraintMaker.top.equalTo(lineLabel.snp.bottom).offset(2.0)
        }
    }
    
    func set_yHeith_text(_ str: String)  {
        yHigh.text = str
    }
    
    func layoutXLabels(_ isTime: Bool, dataArr: NSArray, textColor: UIColor){
        
        for view in self.subviews{
            if view.isKind(of: UILabel.self){
                let label: UILabel = view as! UILabel
                if label.tag == 0 { label.removeFromSuperview() }
            }
        }
        
        lineLabel.backgroundColor = textColor
        yHigh.textColor = textColor
        barColor = textColor
        
        for i in 0 ... 8 {
            var posArr = NSArray()
            let label = UILabel()
            label.text = dataArr.object(at: i) as? String
            label.font = UIFont(name: BASEFONT, size: 14.0)
            label.sizeToFit()
            label.textColor = textColor
            self.addSubview(label)
            
            if isTime  {
                posArr = [4.57, 2.29, 1.51, 1.12, 0.90, 0.75, 0.64, 0.56, 0.01]
                if i == 8 {
                    label.alpha = 0
                }
            }  else  {
                posArr = [5.51, 3.00, 1.79, 1.28, 0.99, 0.81, 0.69, 0.60, 0.55]
                if i == 8 {
                    if (dataArr.object(at: 0) as? String) == (dataArr.object(at: 8) as! String) { label.alpha = 0 }
                }
            }
            
            label.snp.remakeConstraints({ (ConstraintMaker) in
                ConstraintMaker.centerX.equalTo(snp.centerX).dividedBy(posArr[i] as! Double)
                ConstraintMaker.top.equalTo( CGFloat(self.barHeight) + FIT_SCREEN_WIDTH(2))
            })
        }
    }
    
    override func draw(_ rect: CGRect) {
        let marginAndBar    = Int(FIT_SCREEN_WIDTH(42))
        let startX          = Int(FIT_SCREEN_WIDTH(48))
        let startY          = Int(FIT_SCREEN_WIDTH(0))
        
        margin         = marginAndBar*15/42
        barWidth       = marginAndBar*27/42
        
        if barViews.count != numBars {
            for i in 0 ..< numBars{
                barLocation.append((startX + i*marginAndBar, startY))
                let barIntLevel = barIntHeight[i]
                let rect = CGRect(x: CGFloat(barLocation[i].x), y: CGFloat(barLocation[i].y), width: CGFloat(barWidth), height: CGFloat(barHeight))
                
                barViews.append(BarView(frame:rect, barLevel:barIntLevel))
                barViews[i].backgroundColor = .clear
                barViews[i].endingColor = barColor
                barViews[i].fullColor = barFullColor
                addSubview(barViews[i])
            }
        } else  {
            for i in 0 ..< numBars{
                barViews[i].barLevel = barIntHeight[i]
                
                let rect = CGRect(x: CGFloat(barLocation[i].x), y: CGFloat(barLocation[i].y), width: CGFloat(barWidth), height: CGFloat(barHeight))
                barViews[i].backgroundColor = .clear
                barViews[i].endingColor = barColor
                barViews[i].fullColor = barFullColor
                barViews[i].draw(rect)
            }
        }
    }
}
