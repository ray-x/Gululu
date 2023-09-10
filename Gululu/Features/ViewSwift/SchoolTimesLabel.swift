//
//  SchoolTimesLabel.swift
//  Gululu
//
//  Created by Wei on 16/4/25.
//  Copyright © 2016年 Ray Xu. All rights reserved.
//

import UIKit

protocol SchoolTimesLabelDelegate : NSObjectProtocol
{
	func selectedAreaAction(_ index: NSInteger, fpIndex: NSInteger, spIndex: NSInteger, timeLabel: SchoolTimesLabel)
}

class SchoolTimesLabel: UILabel
{
    var delegate : SchoolTimesLabelDelegate?
	var labelMutableStr = NSMutableAttributedString()
	var lastStartIndex = 0
	var lastAlphaLength = 0
	
	override init(frame: CGRect)
	{
		super.init(frame: frame)
		self.isUserInteractionEnabled = true
		self.sizeToFit()
		font = UIFont(name: BASEBOLDFONT, size: 28.0)!
		textColor = .white
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
	{
		for touch: AnyObject in touches
		{
			var sum = 0
			let pos = touch.location(in: self)
			let sizeArr  = NSMutableArray()
			let textLen = text!.count
			var fpIndex = 0
			var spIndex = 0
			
			for i in 0 ... (textLen-1)
			{
				let iStr = (text! as NSString).substring(with: NSRange(location: i, length: 1))
				if iStr == "-"
				{
					fpIndex = i
				}
				
                spIndex = textLen - 1
                
				let iStrSize = (iStr as NSString).size(withAttributes: [NSAttributedStringKey.font:font])
				sizeArr.add(iStrSize.width)
			}
			
			for i in 0 ... (textLen-1)
			{
				sum = sum + ((sizeArr.object(at: i) as AnyObject).intValue)
				if sum >= Int(pos.x)
				{
					self.delegate!.selectedAreaAction(i, fpIndex: fpIndex, spIndex: spIndex, timeLabel: self)
					return
				}
			}
		}
	}
	
	func turnToConfigTimeLabelEnd()
	{
		delegate!.selectedAreaAction(11, fpIndex: 6, spIndex: 13, timeLabel: self)
	}
	
	func setAlphaValueIfNecessary(_ startIndex: NSInteger, endIndex: NSInteger, changed: Bool, labelText: String)
	{
		if changed
		{
			lastStartIndex = startIndex
			lastAlphaLength = (endIndex - startIndex) + 1
			labelMutableStr = NSMutableAttributedString(string: labelText, attributes: [NSAttributedStringKey.font:UIFont(name: BASEBOLDFONT, size: 28.0)!])
			labelMutableStr.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5), range: NSRange(location:startIndex, length:(endIndex - startIndex + 1)))
			attributedText = labelMutableStr
		}
		else
		{
			lastStartIndex = 0
			lastAlphaLength = 0
			labelMutableStr = NSMutableAttributedString(string: labelText, attributes: [NSAttributedStringKey.font:UIFont(name: BASEBOLDFONT, size: 28.0)!])
			labelMutableStr.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSRange(location:0, length:((text?.count)!-1)))
			attributedText = labelMutableStr
		}
	}
	
	func changeLabelTextValue(_ newText: String)
	{
		labelMutableStr = NSMutableAttributedString(string: newText, attributes: [NSAttributedStringKey.font:UIFont(name: BASEBOLDFONT, size: 28.0)!])
		labelMutableStr.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5), range: NSRange(location:lastStartIndex, length:lastAlphaLength))
		attributedText = labelMutableStr
	}
}
