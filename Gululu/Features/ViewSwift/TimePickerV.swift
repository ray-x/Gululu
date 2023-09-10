//
//  TimePickerV.swift
//  Gululu
//
//  Created by Ray Xu on 14/01/2016.
//  Copyright © 2016 Ray Xu. All rights reserved.
//

import UIKit

class TimePickerV: UIView {
    var pickerView:TimePickerV!
    @IBOutlet weak var BarButton: UIBarButtonItem!
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var Distance: UIBarButtonItem!
    var timeBeg:Date!
    var timeEnd:Date!
    
    func loadViewFromNib() -> TimePickerV
	{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TimePickerV", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0]
        return view as! TimePickerV
    }
    
    func xibSetup()
    {
        pickerView=loadViewFromNib()
        pickerView.frame = bounds
        pickerView.Distance.width = self.frame.width*0.7
        pickerView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(pickerView)
    }
    
    required init?(coder aDecoder: NSCoder)
	{
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect)
	{
        super.init(frame: frame)
		
        xibSetup()
    }
}
