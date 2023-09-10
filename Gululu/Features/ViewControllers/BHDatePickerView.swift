//
//  BHDatePickerView.swift
//  Gululu
//
//  Created by Wei on 16/4/23.
//  Copyright © 2016年 Ray Xu. All rights reserved.
//

import UIKit

protocol BHDatePickerDelegate : NSObjectProtocol
{
	func resetDateLabelText(_ dateStr: String)
	func hideDatePickerView()
	func trunToEndTimeSetting()
}

class BHDatePickerView: UIView
{
    var delegate : BHDatePickerDelegate?
	var datePicker = UIDatePicker()
	var toolBtn = UIButton()

	override init(frame: CGRect)
	{
		super.init(frame: frame)
		layoutDatePickerView()
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
	}

	func layoutDatePickerView()
	{
		backgroundColor = .clear
		
		toolBtn.setTitle(NEXT, for: .normal)
		toolBtn.frame = CGRect(x: 0.0, y: 0.0, width: 64.0, height: 44.0)
		toolBtn.backgroundColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 0.0)
		toolBtn.setTitleColor(.blue, for: .normal)
		toolBtn.addTarget(self, action: #selector(toolBtnAction), for: .touchUpInside)
		
		let toolBar = UIToolbar()
		toolBar.backgroundColor = .white
		let emptyLab = UILabel()
		emptyLab.frame = CGRect(x: 0.0, y: 0.0, width: (SCREEN_WIDTH - 94.0), height: 44.0)
		emptyLab.backgroundColor = .white
		let emptyBtn = UIBarButtonItem(customView: emptyLab)
		let rightBtn = UIBarButtonItem(customView: toolBtn)
		addSubview(toolBar)
		toolBar.snp.makeConstraints { (ConstraintMaker) in
			ConstraintMaker.left.right.top.equalTo(self)
			ConstraintMaker.height.equalTo(44.0)
		}
		
		let backLabel = UILabel()
		backLabel.backgroundColor = .white
		toolBar.addSubview(backLabel)
		backLabel.snp.makeConstraints { (ConstraintMaker) in
			ConstraintMaker.edges.equalTo(toolBar)
		}
		
		toolBar.items = [emptyBtn, rightBtn]
		
		let lineLable = UILabel()
		lineLable.backgroundColor = .lightGray
		toolBar.addSubview(lineLable)
		lineLable.snp.makeConstraints { (ConstraintMaker) in
			ConstraintMaker.left.right.bottom.equalTo(toolBar)
			ConstraintMaker.height.equalTo(1.0)
		}
		
		datePicker.backgroundColor = .white
		datePicker.datePickerMode = .time
		datePicker.minuteInterval = 5
        datePicker.locale = Locale(identifier: "en_GB")
		datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
		addSubview(datePicker)
		datePicker.snp.makeConstraints { (ConstraintMaker) in
			ConstraintMaker.top.equalTo(toolBar.snp.bottom)
			ConstraintMaker.left.right.bottom.equalTo(self)
		}
	}
	
	@objc func toolBtnAction()
	{
		if toolBtn.titleLabel?.text == NEXT
		{
			datePickerValueChanged()
			delegate?.trunToEndTimeSetting()
		}
		else if toolBtn.titleLabel?.text == DONE
		{
			datePickerValueChanged()
			delegate?.hideDatePickerView()
		}
	}
	
	// MARK: UIDatePicker Events
	func setDatePcikerMinAndMaxDate(_ minStr: String, maxStr: String, curStr: String)
	{
        let localMinStr = String(format: "%@",minStr)
        let localMaxStr = String(format: "%@",maxStr)
        let localCurStr = String(format: "%@",curStr)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "en_GB")
        let minDate = formatter.date(from: localMinStr)
        let maxDate = formatter.date(from: localMaxStr)
        let curDate = formatter.date(from: localCurStr)
        if curDate != nil{
            datePicker.minimumDate = minDate
            datePicker.maximumDate = maxDate
            datePicker.setDate(curDate!, animated: true)
        }
	}
	
	@objc func datePickerValueChanged()
	{
		let dateformatter = DateFormatter()
		dateformatter.dateStyle = DateFormatter.Style.none
		dateformatter.dateFormat = "HH:mm"
		let dateStr = dateformatter.string(from: datePicker.date)
		delegate!.resetDateLabelText(dateStr)
	}
}
