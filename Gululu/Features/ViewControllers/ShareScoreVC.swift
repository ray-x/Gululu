//
//  ShareScoreVC.swift
//  Gululu
//
//  Created by baker on 2017/11/13.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

class ShareScoreVC: UIViewController {
    
    @IBOutlet weak var share_score_view: UIView!
    @IBOutlet weak var head_image: ImageMaskView!
    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var share_title_image: UIImageView!
    @IBOutlet weak var share_pet_image: UIImageView!
    
    
    @IBOutlet weak var share_bg_image: UIImageView!
    @IBOutlet weak var share_title_bg_image: UIImageView!
    @IBOutlet weak var share_little_bg_image: UIImageView!
    @IBOutlet weak var share_info: UILabel!
    
    @IBOutlet weak var share_bottom_image_bg: UIImageView!
    @IBOutlet weak var share_bottom_img: UIImageView!
    @IBOutlet weak var share_score_btn: UIButton!
    @IBOutlet weak var share_score_little_label: UILabel!
    @IBOutlet weak var drink_week_view: UIView!
    @IBOutlet weak var dissmissButton: UIButton!
    @IBOutlet weak var saveImageButton: UIButton!
    
    let helper = ShareScoreHelper.share
    var intscore = 100
    var drink_banner_color = UIColor()
    var default_banner_color = UIColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.tag = main_share_score_tag
        share_score_view.tag = main_share_score_img_tag
        
        //head image
        let imagePath: String! = activeChildID + ".jpg"
        head_image.imagePath = imagePath
        head_image.layoutSubviews()
        //name
        
        let (bg_image, little_bg_image, title_bg_image, banner_color, default_banner_color_fuc, bottom_color) = helper.get_share_day_all_image()
        share_bg_image.image = UIImage(named: bg_image)
        share_little_bg_image.image = UIImage(named: little_bg_image)
        share_title_bg_image.image = UIImage(named: title_bg_image)
        drink_banner_color = banner_color
        default_banner_color = default_banner_color_fuc
        share_bottom_image_bg.image = BKImage.getImageWithColor(bottom_color)
        share_bottom_image_bg.layer.masksToBounds = true
        share_bottom_image_bg.layer.cornerRadius = share_bottom_image_bg.frame.height/2
        name_label.text = GChild.share.getActiveChildName()
//        shareButton.setTitle(Localizaed("Share"), for: .normal)
        let defauletValue = GChild.share.readHabitIndex()
        set_score_content(defauletValue)
    }
    
    func set_score_content(_ score: Int) {
        let (image_name, info) = helper.get_share_title_img_and_info(score)
        share_title_image.image = UIImage(named: image_name)
        share_info.text = info

        if score < 100{
            share_score_little_label.isHidden = false
            share_score_btn.setTitle(String(score), for: .normal)
            share_score_btn.titleLabel?.font = UIFont(name: BASEBOLDFONT, size: 80)
            share_score_btn.titleLabel?.layer.masksToBounds = true
            share_score_btn.titleLabel?.layer.shadowOpacity = 0.9
            share_score_btn.titleLabel?.layer.shadowColor = UIColor.black.cgColor
            share_score_btn.titleLabel?.layer.shadowOffset = CGSize(width: 1, height: 5)
            share_score_btn.titleLabel?.layer.shadowRadius = 4.0
        }else{
            share_score_little_label.isHidden = true
            share_score_btn.setTitle("", for: .normal)
            share_score_btn.titleLabel?.layer.masksToBounds = false
            share_score_btn.setImage(UIImage(named: "main_share_100"), for: .normal)
        }
        if Common.checkPreferredLanguagesIsEn(){
            share_score_little_label.isHidden = true
        }else{
            share_score_little_label.isHidden = false
            share_score_little_label.text = Localizaed("score")
        }
        share_pet_image.image = UIImage(named: helper.get_share_pet_img_name())
        share_bottom_img.image = UIImage(named:  helper.get_share_bottom_img())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        add_bar_in_drink_view()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func add_bar_in_drink_view() {
        let barHeight = drink_week_view.frame.height - 20

        let big_x = drink_week_view.frame.width
        let middle = FIT_SCREEN_WIDTH(10)
        let barItemW = (big_x-8*middle)/9
        let barItemY = CGFloat(0)
        if GChild.share.drinkWaterDayArray.count == 0 {
            GChild.share.drinkWaterDayArray = [0,0,0,0,0,0,0]
        }
        let recommend = GChild.share.getActiveChildRecommentWater(nil)

        let barIntHeight = GChild.share.drinkWaterDayArray.map({
            ($0*Int(barHeight)+recommend/2)/recommend
        })
        let dataArr: NSArray = BKDateTime.getDateArray()
        
        for i in 0 ... 8{
            
            let barItemX = (barItemW+middle)*CGFloat(i)
            
            if i>0 && i<8{
                let barIntLevel = barIntHeight[i-1]
                let rect = CGRect(x: barItemX , y: barItemY , width: barItemW, height: barHeight)
                let barViewItem = BarView(frame:rect, barLevel:barIntLevel)
                
                barViewItem.backgroundColor = default_banner_color
                barViewItem.endingColor = drink_banner_color
                barViewItem.fullColor = .clear
                drink_week_view.addSubview(barViewItem)
            }
            
            let label = UILabel()
            label.frame = CGRect(x: barItemX , y: barHeight , width: barItemW, height: 20)
            label.text = dataArr.object(at: i) as? String
            label.font = UIFont(name: BASEFONT, size: 12.0)
            label.sizeToFit()
            label.textColor = .white
            drink_week_view.addSubview(label)
            if i == 8 {
                if (dataArr.object(at: 0) as? String) == (dataArr.object(at: 8) as! String) { label.alpha = 0 }
            }
            
        }
    }

}
