//
//  WaterLayerView.swift
//  Gululu
//
//  Created by Baker on 16/9/1.
//  Copyright © 2016年 Ray Xu. All rights reserved.
//

import UIKit

class WaterLayerView: UIView {

    var firstWaveColor : UIColor?
    var secondWaveColor : UIColor?
    var percent : CGFloat = 0
    
    var waveDisplaylink = CADisplayLink()
    let firstWaveLayer = CAShapeLayer()
    let secondWaveLayer = CAShapeLayer()
    
    var waveAmplitude : CGFloat = 0
    var waveCycle : CGFloat = 0
    var waveSpeed : CGFloat = 0
    var waveGrowth : CGFloat = 0
    
    var waterWaveHeight : CGFloat = 0
    var waterWaveWidth : CGFloat = 0
    var offsetX : CGFloat = 0
    var currentWavePointY : CGFloat = 0
    var myvariable : Float = 0.0
    var increase : Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        layer.masksToBounds  = true
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(){
        
        waterWaveHeight = frame.size.height/2
        waterWaveWidth  = frame.size.width
        
        if (waterWaveWidth > 0) {
            waveCycle =  1.29 * CGFloat(Double.pi) / waterWaveWidth
        }
        
        if (currentWavePointY <= 0) {
            currentWavePointY = frame.size.height
        }
        
        firstWaveColor = UIColor(red:65/255.0, green:255/255.0,blue:212/255.0 ,alpha:0.3 )
        secondWaveColor = UIColor(red:65/255.0, green:255/255.0,blue:212/255.0 ,alpha:0.3 )
        
        waveGrowth = 1.85
        waveSpeed = 0.4/CGFloat(Double.pi)

        resetProperty()
        
        firstWaveLayer.fillColor = firstWaveColor?.cgColor
        layer.addSublayer(firstWaveLayer)
        
        secondWaveLayer.fillColor = secondWaveColor?.cgColor
        layer.addSublayer(secondWaveLayer)
        
        waveDisplaylink = CADisplayLink(target: self, selector: #selector(getCurrentWave(_:)))
        waveDisplaylink.add(to: RunLoop.main, forMode:RunLoopMode.commonModes)
        
    }
    
    func resetProperty() {
        currentWavePointY = frame.size.height
        myvariable = 1.6
        increase = false
        offsetX = 0
    }
    
    func setnewPercent(_ newPercent:CGFloat) {
        if (newPercent < percent) {
            // down
            waveGrowth = waveGrowth > 0 ? -waveGrowth : waveGrowth
        }else if (newPercent > percent) {
            // up
            waveGrowth = waveGrowth > 0 ? waveGrowth : -waveGrowth
        }
        percent = newPercent
    }
    
    func animateWave(){
        if increase {
            myvariable += 0.01
        }else{
            myvariable -= 0.01
        }
        if (myvariable <= 1) {
            increase = true
        }
        
        if myvariable >= 1.6 {
            increase = false
        }
        waveAmplitude = CGFloat(myvariable*5)
    }
    
    @objc func getCurrentWave(_ displayLink : CADisplayLink) {
        
        animateWave()
        
        if waveGrowth > 0 && currentWavePointY > 2 * waterWaveHeight * (1 - percent) {
            currentWavePointY -= waveGrowth
        }else if (waveGrowth < 0 && currentWavePointY < 2 * waterWaveHeight * (1 - percent)){
            currentWavePointY -= waveGrowth
        }
        
        offsetX += waveSpeed/2
        setCurrentFirstWaveLayerPath()
        setCurrentSecondWaveLayerPath()
    }
    
    func setCurrentFirstWaveLayerPath() {
        let path : CGMutablePath = CGMutablePath()
        var y : CGFloat  = currentWavePointY
        path.move(to: CGPoint(x: 0, y: y))
        for  x : Int in 0...Int(waterWaveWidth) {
            y = waveAmplitude * sin(waveCycle * CGFloat(x) + offsetX) + currentWavePointY
            path.addLine(to: CGPoint(x: CGFloat(x), y: y))
        }
        path.addLine(to: CGPoint(x: waterWaveWidth, y: frame.size.height))
        path.addLine(to: CGPoint(x: 0, y: frame.size.height))
        path.closeSubpath()
        
        firstWaveLayer.path = path
    }
    
    func setCurrentSecondWaveLayerPath() {
        let path : CGMutablePath = CGMutablePath()
        var y : CGFloat  = currentWavePointY
        path.move(to: CGPoint(x: 0, y: y))

        for  x : Int in 0...Int(waterWaveWidth) {
            y = waveAmplitude * cos(waveCycle * CGFloat(x) + offsetX) + currentWavePointY
            path.addLine(to: CGPoint(x: CGFloat(x), y: y))
        }
        path.addLine(to: CGPoint(x: waterWaveWidth, y: frame.size.height))
        path.addLine(to: CGPoint(x: 0, y: frame.size.height))
        path.closeSubpath()
        
        secondWaveLayer.path = path
    }

    func reset() {
        stopWave()
        resetProperty()
        firstWaveLayer.removeFromSuperlayer()
        secondWaveLayer.removeFromSuperlayer()
    }
    
    func stopWave() {
        waveDisplaylink.invalidate()
    }
    
}
