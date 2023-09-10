//
//  WaterBarSubview.swift
//  Gululu
//
//  Created by Ray Xu on 5/12/2015.
//  Copyright © 2015 Ray Xu. All rights reserved.
//

import UIKit

enum WaterShowModel {
    case day,week,defauleModel
}

@IBDesignable class WaterBarChart: UIView{
    
    @IBOutlet weak var dayButton: UIButton!
    @IBOutlet weak var weekButton: UIButton!
    @IBOutlet weak var waterBarView: BarChartView!
    
    var barView: UIView!
    
    var intakeDayInWeek = [Int](repeating: 0, count: 7)
    var intakeHourInDay = [Int](repeating: 0, count: 7)
    
    var waterShowModel : WaterShowModel = .defauleModel

    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "WaterBarChart", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    func xibSetup(){
        barView = loadViewFromNib()
        barView.frame = bounds
        barView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(barView)
    }
    
    override init(frame:CGRect){
        super.init(frame: frame)
        xibSetup()
        awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    override func awakeFromNib(){
        super.awakeFromNib()
        dayButton.setTitle(Localizaed("Today"), for: .normal)
        weekButton.setTitle(Localizaed("7 Days"), for: .normal)

        dayButton.addTarget(self, action: #selector(setDayDrinkLog(_:)), for: .touchUpInside)
        dayButton.alpha = 1.0
        
        weekButton.addTarget(self, action: #selector(setWeekLog(_:)), for: .touchUpInside)
        weekButton.alpha = 0.4
        
        let timeColor = UIColor(red: 0.0/255.0, green: 185.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        let timeArray = ["7AM", "9", "11", "1", "3", "5", "7", "9PM", ""]
        waterBarView.barHeight = Int(self.frame.height*0.5)
        waterBarView.layoutXLabels(true, dataArr: timeArray as NSArray, textColor: timeColor)
    }
    
    @objc func setDayDrinkLog(_ sender:UIButton){
        loadDayStryleView()
    }
    
    func loadDayStryleView() -> Void {
        waterShowModel = .day
        dayButton.alpha = 1.0
        weekButton.alpha = 0.4
    

        let timeArray = ["7AM", "9", "11", "1", "3", "5", "7", "9PM", ""]
        let dayColor = UIColor(red: (0.0/255.0), green: (185.0/255.0), blue: (242.0/255.0), alpha: 1.0)
        waterBarView?.set_yHeith_text(GChild.share.getDayDrinkWater())
        waterBarView.layoutXLabels(true, dataArr: timeArray as NSArray, textColor: dayColor)
        
        if intakeHourInDay.count == 0{
            intakeHourInDay = [0,0,0,0,0,0,0]
        }
        let recommend = GChild.share.getActiveChildRecommentWater(nil)
        waterBarView?.barIntHeight = intakeHourInDay.map({
            $0*(waterBarView?.barHeight)!/((recommend+4)/7)
        })
        
        waterBarView?.draw((waterBarView?.frame)!)
    }
    
    @objc func setWeekLog(_ sender:UIButton){
        loadWeekStyleView()
    }
    
    func loadWeekStyleView() -> Void {
        waterShowModel = .week
        dayButton.alpha = 0.4
        weekButton.alpha = 1.0
        
        let weekColor = UIColor(red: (63.0/255.0), green: (189.0/255.0), blue: (174.0/255.0), alpha: 1.0)
        let strArray: NSArray = BKDateTime.getDateArray()
        waterBarView?.set_yHeith_text(GChild.share.getWeekDrinkWater())
        waterBarView?.layoutXLabels(false, dataArr: strArray, textColor: weekColor)
        
        if intakeDayInWeek.count == 0{
            intakeDayInWeek = [0,0,0,0,0,0,0]
        }
        
        let recommend = GChild.share.getActiveChildRecommentWater(nil)
        waterBarView.barIntHeight = intakeDayInWeek.map({
            ($0*(waterBarView?.barHeight)!+recommend/2)/recommend
        })
        
        waterBarView.draw((waterBarView.frame))
    }

}
