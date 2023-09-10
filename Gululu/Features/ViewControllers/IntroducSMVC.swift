//
//  IntroducSMVC.swift
//  Gululu
//
//  Created by Wei on 16/4/22.
//  Copyright © 2016年 Ray Xu. All rights reserved.
//

import UIKit

class IntroducSMVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		layoutIntroSchoolMode()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(animated)
		
        // TODO: Update school mode
	}
    
	func layoutIntroSchoolMode()
	{
		let backImageView = UIImageView()
		backImageView.image = UIImage(named: "Parents account")
		view.addSubview(backImageView)
		backImageView.snp.makeConstraints { (ConstraintMaker) in
			ConstraintMaker.edges.equalTo(UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0))
		}
		
		let bookImage = UIImage(named: "book")
		let bookImageView = UIImageView()
		bookImageView.image = bookImage
		view.addSubview(bookImageView)
		bookImageView.snp.makeConstraints { (ConstraintMaker) in
			ConstraintMaker.centerX.equalTo(view)
			ConstraintMaker.top.equalTo(view).offset(76.0)
			ConstraintMaker.size.equalTo(CGSize(width: (bookImage?.size.width)!, height: (bookImage?.size.height)!))
		}
		
		let introSMLable = UILabel()
		introSMLable.text = Localizaed("Introducing School Mode")
		introSMLable.textAlignment = NSTextAlignment.center
		introSMLable.sizeToFit()
		introSMLable.textColor = .white
		introSMLable.font = UIFont(name: BASEBOLDFONT, size: 22)
		view.addSubview(introSMLable)
		introSMLable.snp.makeConstraints { (ConstraintMaker) in
			ConstraintMaker.top.equalTo(bookImageView.snp.bottom).offset(63.0)
			ConstraintMaker.left.right.equalTo(view)
		}
		
		let descriptionLabel = UILabel()
		descriptionLabel.text = Localizaed("To help your child concentrating class, you can set Gululu to school mode. It will be silent and not interact with your child within the set period of time.")
		descriptionLabel.textAlignment = NSTextAlignment.center
		descriptionLabel.textColor = .white
		descriptionLabel.font = UIFont(name: BASEFONT, size: 18)
		descriptionLabel.numberOfLines = 0
		descriptionLabel.sizeToFit()
		view.addSubview(descriptionLabel)
		descriptionLabel.snp.makeConstraints { (ConstraintMaker) in
			ConstraintMaker.left.equalTo(view).offset(38.0)
			ConstraintMaker.right.equalTo(view).offset(-38.0)
			ConstraintMaker.top.equalTo(introSMLable.snp.bottom).offset(30)
		}
		
		let nmImage = UIImage(named: "leftoval")
		let nmBtn = UIButton(type: .custom)
		nmBtn.setBackgroundImage(nmImage, for: .normal)
		nmBtn.setTitle(Localizaed("Never\rmind"), for: .normal)
		nmBtn.titleLabel?.font = UIFont(name: BASEBOLDFONT, size: 22)
		nmBtn.titleLabel?.textAlignment = NSTextAlignment.center
		nmBtn.titleLabel?.numberOfLines = 0
		nmBtn.addTarget(self, action: #selector(neverMindBtnActon), for: .touchUpInside)
		view.addSubview(nmBtn)
		nmBtn.snp.makeConstraints { (ConstraintMaker) in
			ConstraintMaker.centerX.equalTo(view.snp.centerX).multipliedBy(0.52)
			ConstraintMaker.bottom.equalTo(view).offset(-35.0)
			ConstraintMaker.size.equalTo(CGSize(width: (nmImage?.size.width)!, height: (nmImage?.size.height)!))
		}
		
		let stImage = UIImage(named: "rightoval")
		let stBtn = UIButton(type: .custom)
		stBtn.setBackgroundImage(stImage, for: .normal)
		stBtn.setTitle(Localizaed("Setting"), for: .normal)
		stBtn.titleLabel?.font = UIFont(name: BASEBOLDFONT, size: 22)
		stBtn.titleLabel?.textAlignment = NSTextAlignment.center
		stBtn.titleLabel?.numberOfLines = 0
		stBtn.addTarget(self, action: #selector(settingBtnAction), for: .touchUpInside)
		view.addSubview(stBtn)
		stBtn.snp.makeConstraints { (ConstraintMaker) in
			ConstraintMaker.centerX.equalTo(view.snp.centerX).multipliedBy(1.48)
			ConstraintMaker.top.equalTo(nmBtn)
			ConstraintMaker.size.equalTo(CGSize(width: (stImage?.size.width)!, height: (stImage?.size.height)!))
		}
	}
	
	@objc func neverMindBtnActon(){
        _ = navigationController?.popToRootViewController(animated: true)
	}
	
	@objc func settingBtnAction(){
        let setScoolModeVC = SetSchoolModeVC()
        setScoolModeVC.boolIntroPush = true
        navigationController?.pushViewController(setScoolModeVC, animated: true)
	}

}


