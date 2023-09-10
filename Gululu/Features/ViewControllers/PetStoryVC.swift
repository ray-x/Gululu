//
//  PetStoryVC.swift
//  Gululu
//
//  Created by baker on 2017/11/27.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit
import DOUAudioStreamer

class PetStoryVC: BaseViewController, UIScrollViewDelegate{

    @IBOutlet weak var bg: UIImageView!
    
    let helper = PetStoryHelper.share
    
    var middle_black_view = UIImageView()
    var slider = UISlider()
    var play_timer_label = UILabel()
    var total_timer_label = UILabel()
    var small_creature_image = UIImageView()
    var select_circle_image = UIImageView()
    var creature_view_button_top_sign = UIImageView()
    var play_btn = UIButton()
    var next_btn = UIButton()
    var pervious_btn = UIButton()
    let scrollerView = UIScrollView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        hideNavigation()
        create_tv_view()
        create_creature_view()
        middle_view_add_gesture()
        get_media_info_array()
    }
    
    func get_media_info_array()  {
        helper.get_child_pet_story { (result) in
            DispatchQueue.main.sync {
                self.set_creature_view_title_button_show(self.helper.ocean_button_tag)
                self.add_lock_creature_circle()
                self.set_first_circle_creature_button()
                self.checkout_switch_button_status()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
    }
    
    func middle_view_add_gesture() {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(creature_down_animation))
        middle_black_view.isUserInteractionEnabled = true
        middle_black_view.addGestureRecognizer(tap)
        creature_view_button_top_sign.image = UIImage(named: "pet_story_up")
    }
    
    func create_tv_view() {
        let tv_image_view = UIImageView(frame: CGRect(x: (SCREEN_HEIGHT-SCREEN_WIDTH*0.787)/2, y: SCREEN_WIDTH*0.05, width: SCREEN_WIDTH*0.787, height: SCREEN_WIDTH*0.7))
        tv_image_view.isUserInteractionEnabled = true
        tv_image_view.image = UIImage(named: "pet_story_TV")
        view.addSubview(tv_image_view)
        
        small_creature_image.frame = CGRect(x: SCREEN_WIDTH*0.074, y: SCREEN_WIDTH*0.233, width: SCREEN_WIDTH*0.465, height: SCREEN_WIDTH*0.358)
        small_creature_image.image = UIImage(named: "pet_story_creature_default")
        small_creature_image.tag = helper.small_creature_tag
        tv_image_view.addSubview(small_creature_image)
        
        let wifi_image = UIImageView(frame: CGRect(x: (SCREEN_HEIGHT-SCREEN_WIDTH*0.787)/2-SCREEN_WIDTH*0.14, y: SCREEN_WIDTH*0.066, width: SCREEN_WIDTH*0.18, height: SCREEN_WIDTH*0.18))
        wifi_image.tag = helper.wifi_view_tag
        wifi_image.image = UIImage(named: "pet_story_play_wifi_3")
        view.addSubview(wifi_image)
        var imagesListArray :[UIImage] = []
        //use for loop
        for position in 1...3{
            let strImageName : String = "pet_story_play_wifi_\(String(format: "%d", position)).png"
            let image  = UIImage(named:strImageName)
            imagesListArray.append(image!)
        }
        
        wifi_image.animationImages = imagesListArray
        wifi_image.animationDuration = 1
        
        play_btn.frame = CGRect(x: SCREEN_WIDTH*0.575, y: SCREEN_WIDTH*0.175, width: SCREEN_WIDTH*0.152, height: SCREEN_WIDTH*0.152)
        play_btn.tag = helper.play_btn_tag
        play_btn.setBackgroundImage(UIImage(named: "pet_story_play"), for: .normal)
        play_btn.addTarget(self, action: #selector(play(_:)), for: .touchUpInside)
        tv_image_view.addSubview(play_btn)
        
        next_btn.frame = CGRect(x: SCREEN_WIDTH*0.575, y: SCREEN_WIDTH*0.336, width: SCREEN_WIDTH*0.152, height: SCREEN_WIDTH*0.152)
        next_btn.setBackgroundImage(UIImage(named: "pet_story_next"), for: .normal)
        next_btn.addTarget(self, action: #selector(next_vedio), for: .touchUpInside)
        tv_image_view.addSubview(next_btn)

        pervious_btn.frame = CGRect(x: SCREEN_WIDTH*0.575, y: SCREEN_WIDTH*0.49, width: SCREEN_WIDTH*0.152, height: SCREEN_WIDTH*0.152)
        pervious_btn.setBackgroundImage(UIImage(named: "pet_story_pervious"), for: .normal)
        pervious_btn.addTarget(self, action: #selector(pervious), for: .touchUpInside)
        tv_image_view.addSubview(pervious_btn)
        
        let green_sing = UIImageView(frame: CGRect(x: SCREEN_WIDTH*0.437, y: SCREEN_WIDTH*0.609, width: SCREEN_WIDTH*0.028, height: SCREEN_WIDTH*0.028))
        green_sing.tag = helper.green_sign_tag
        green_sing.image = UIImage(named: "pet_story_play_green")
        let imagesListArray_green :[UIImage] = [UIImage(named: "pet_story_play_green")!, UIImage(named: "pet_story_play_black")!]
        green_sing.animationImages = imagesListArray_green
        green_sing.animationDuration = 0.9
        tv_image_view.addSubview(green_sing)
        
        let yellow_sing = UIImageView(frame: CGRect(x: SCREEN_WIDTH*0.472, y: SCREEN_WIDTH*0.609, width: SCREEN_WIDTH*0.028, height: SCREEN_WIDTH*0.028))
        yellow_sing.tag = helper.yellow_sign_tag
        yellow_sing.image = UIImage(named: "pet_story_play_yellow")
        let imagesListArray_yellow :[UIImage] = [UIImage(named: "pet_story_play_yellow")!, UIImage(named: "pet_story_play_black")!]
        yellow_sing.animationImages = imagesListArray_yellow
        yellow_sing.animationDuration = 1.0
        tv_image_view.addSubview(yellow_sing)
        
        let red_sign = UIImageView(frame: CGRect(x: SCREEN_WIDTH*0.508, y:SCREEN_WIDTH*0.609, width: SCREEN_WIDTH*0.028, height: SCREEN_WIDTH*0.028))
        red_sign.tag = helper.red_sign_tag
        red_sign.image = UIImage(named: "pet_story_play_red")
        let imagesListArray_red :[UIImage] = [UIImage(named: "pet_story_play_red")!, UIImage(named: "pet_story_play_black")!]
        red_sign.animationImages = imagesListArray_red
        red_sign.animationDuration = 0.8
        tv_image_view.addSubview(red_sign)
        
        slider.frame = CGRect(x: (SCREEN_HEIGHT-SCREEN_WIDTH*0.787)/2, y: SCREEN_WIDTH*0.77, width: SCREEN_WIDTH*0.787, height: 20)
        slider.setThumbImage(UIImage(named: "pet_story_slide_btn"), for: .normal)
        slider.addTarget(self, action: #selector(slideProcessChang(_:)), for: .valueChanged)
        let image = UIImage(named: "pet_story_slider_mix")?.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 2, 0))
        slider.setMinimumTrackImage(image, for: .normal)
        slider.setMaximumTrackImage(UIImage(named: "pet_story_slide_bg"), for: .normal)
        slider.setValue(0.0, animated: true)
        view.addSubview(slider)
        
        play_timer_label.frame = CGRect(x: (SCREEN_HEIGHT-SCREEN_WIDTH*0.787)/2-55, y: SCREEN_WIDTH*0.77, width: 55, height: 20)
        play_timer_label.textColor = RGB_COLOR(74, g: 255, b: 240, alpha: 1)
        play_timer_label.font = UIFont(name: BASEFONT, size: 20)
        play_timer_label.backgroundColor = .clear
        play_timer_label.textAlignment = .center
        play_timer_label.text = "00:00"
        view.addSubview(play_timer_label)
        
        total_timer_label.frame = CGRect(x: (SCREEN_HEIGHT+SCREEN_WIDTH*0.787)/2, y: SCREEN_WIDTH*0.77, width: 55, height: 20)
        total_timer_label.textColor = RGB_COLOR(74, g: 255, b: 240, alpha: 1)
        total_timer_label.text = "00:00"
        total_timer_label.textAlignment = .center
        total_timer_label.backgroundColor = .clear
        total_timer_label.font = UIFont(name: BASEFONT, size: 20)
        view.addSubview(total_timer_label)
        
    }
    
    func create_creature_view() {
        let creature_view = UIView(frame: CGRect(x: 0, y: SCREEN_WIDTH*0.81, width: SCREEN_HEIGHT, height: SCREEN_WIDTH*0.86))
        creature_view.tag = helper.creature_view_tag
        creature_view.backgroundColor = UIColor.clear
        
        let up_swipe_gesture = UISwipeGestureRecognizer()
        up_swipe_gesture.addTarget(self, action: #selector(creature_up_animation))
        up_swipe_gesture.direction = .up
        creature_view.addGestureRecognizer(up_swipe_gesture)
        
        let down_swipe_gesture = UISwipeGestureRecognizer()
        down_swipe_gesture.addTarget(self, action: #selector(creature_down_animation))
        down_swipe_gesture.direction = .down
        creature_view.addGestureRecognizer(down_swipe_gesture)
        
        view.addSubview(creature_view)

        add_five_button_title(creature_view)
        
        add_scrollerView(creature_view)
    }
    
    func add_five_button_title(_ creature_view: UIView) {
        
        let button_size = helper.get_button_size()
        let button_origin = helper.get_button_first_origin()
        
        let button1 = UIButton(frame: CGRect(x: helper.get_button_origin_x(1), y: button_origin.y, width: button_size.width , height: button_size.height))
        button1.setBackgroundImage(UIImage(named: "pet_story_ocean_lock"), for: .normal)
        button1.tag = helper.ocean_button_tag
        button1.addTarget(self, action: #selector(creature_view_button_click(_:)), for: .touchUpInside)
        creature_view.addSubview(button1)
        
        let button2 = UIButton(frame: CGRect(x: helper.get_button_origin_x(2), y: button_origin.y, width: button_size.width , height: button_size.height))
        button2.setBackgroundImage(UIImage(named: "pet_story_wonder_lock"), for: .normal)
        button2.tag = helper.wood_button_tag
        button2.addTarget(self, action: #selector(creature_view_button_click(_:)), for: .touchUpInside)
        creature_view.addSubview(button2)
        
        let button3 = UIButton(frame: CGRect(x: helper.get_button_origin_x(3), y: button_origin.y, width: button_size.width , height: button_size.height))
        button3.setBackgroundImage(UIImage(named: "pet_story_desert_lock"), for: .normal)
        button3.tag = helper.desert_button_tag
        button3.addTarget(self, action: #selector(creature_view_button_click(_:)), for: .touchUpInside)
        creature_view.addSubview(button3)
        
        let button4 = UIButton(frame: CGRect(x: helper.get_button_origin_x(4), y: button_origin.y, width: button_size.width , height: button_size.height))
        button4.setBackgroundImage(UIImage(named: "pet_story_four_lock"), for: .normal)
        button4.tag = helper.four_button_tag
        button4.addTarget(self, action: #selector(creature_view_button_click(_:)), for: .touchUpInside)
        creature_view.addSubview(button4)
        
        let button5 = UIButton(frame: CGRect(x: helper.get_button_origin_x(5), y: button_origin.y, width: button_size.width , height: button_size.height))
        button5.setBackgroundImage(UIImage(named: "pet_story_five_lock"), for: .normal)
        button5.tag = helper.five_button_tag
        button5.addTarget(self, action: #selector(creature_view_button_click(_:)), for: .touchUpInside)
        creature_view.addSubview(button5)
    }
    
    func add_scrollerView(_ creature_view: UIView) {
        scrollerView.backgroundColor = .clear
        scrollerView.tag = helper.scroller_view_tag
        scrollerView.isPagingEnabled = true
        scrollerView.frame = CGRect(x: 0, y: helper.scroller_view_y, width: SCREEN_HEIGHT, height: creature_view.frame.height - helper.scroller_view_y)
        scrollerView.delegate = self
        scrollerView.showsHorizontalScrollIndicator = false
        scrollerView.showsVerticalScrollIndicator = false
        scrollerView.bounces = false
        creature_view.addSubview(scrollerView)
    }
    
    func add_lock_creature_circle() {
        let scroller: UIScrollView = view.viewWithTag(helper.scroller_view_tag) as! UIScrollView
        let page = helper.get_locked_word_num()
        scroller.contentSize = CGSize(width: SCREEN_HEIGHT*CGFloat(page), height: SCREEN_WIDTH*0.86 - helper.scroller_view_y)

        let little_button_size = helper.get_creature_size()
        let middle_x = helper.get_creature_middle_x()
        let middle_y = SCREEN_WIDTH*0.053
        let base_X = (SCREEN_HEIGHT - little_button_size.width)/2
        for i in 0...helper.all_creature_lock(){
            let page = i/helper.page_creature_number
            let page_x = CGFloat(page) * SCREEN_HEIGHT
            let line = i/7 - page * 3
            let add_number = -4 - line*7 - page * helper.page_creature_number
            let x_number = i + add_number + 1
            let button_complient_x = CGFloat(x_number) * (little_button_size.width+middle_x)
            let button_x = button_complient_x + base_X + page_x
            let button_y = CGFloat(line + 1) * middle_y + CGFloat(line) * little_button_size.height
            
            let button_creature: UIButton = UIButton(frame: CGRect(x: button_x, y: button_y, width: little_button_size.width, height: little_button_size.height))
            button_creature.tag = helper.scroller_view_tag + i + 1
            button_creature.addTarget(self, action: #selector(play(_:)), for: .touchUpInside)
            
            let mediaInfo = helper.get_click_media_info(i + 1)
            let default_image = UIImage(named: "pet_story_little_lock")
            if mediaInfo.bionts_status == 0 || mediaInfo.bionts_status == nil{
                button_creature.setBackgroundImage(default_image, for: .normal)
            }else{
                button_creature.imageView?.sd_setImage(with: URL(string: mediaInfo.media_avatar!), placeholderImage: default_image, options: .highPriority, completed:{ (_,_,_,_) in
                    button_creature.setBackgroundImage(button_creature.imageView?.image, for: .normal)
                })
                button_creature.setBackgroundImage(button_creature.imageView?.image, for: .normal)
            }
            scroller.addSubview(button_creature)
        }
    }
    
    func set_first_circle_creature_button() {
        let button: UIButton? = scrollerView.viewWithTag(helper.scroller_view_tag + helper.currentTrackIndex) as? UIButton
        select_circle_image.image = UIImage(named: "pet_story_button_chose")
        select_circle_image.frame = CGRect(x: 0, y: 0, width: 0.227*SCREEN_WIDTH, height: 0.227*SCREEN_WIDTH)
        scrollerView.insertSubview(select_circle_image, at: 0)
        select_circle_image.isUserInteractionEnabled = true
        if (button != nil){
            select_circle_image.center = (button?.center)!
        }
    }
    
    @objc func creature_up_animation()  {
        let creature_view: UIView = view.viewWithTag(helper.creature_view_tag)!
        
        middle_black_view.frame = CGRect(x: 0, y: 0, width: SCREEN_HEIGHT, height: SCREEN_WIDTH)
        middle_black_view.image = UIImage(named: "pet_story_middle_bg")
        middle_black_view.alpha = 0.0
        view.insertSubview(middle_black_view, belowSubview: creature_view)

        if creature_view.frame.origin.y > SCREEN_WIDTH/2{
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
                self.middle_black_view.alpha = 1.0
                creature_view.transform = creature_view.transform.translatedBy(x: 0, y: -SCREEN_WIDTH*0.7)
            }, completion:{ _ in
                self.helper.creature_up = true
                self.creature_view_button_top_sign.image = UIImage(named: "pet_story_down")
            })
        }else{
            middle_black_view.alpha = 1.0
        }
    }
    
    @objc func creature_down_animation()  {
        let creature_view: UIView = view.viewWithTag(helper.creature_view_tag)!
        if creature_view.frame.origin.y < SCREEN_WIDTH/2{
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
                self.middle_black_view.alpha = 0.0
                creature_view.transform = creature_view.transform.translatedBy(x: 0, y: SCREEN_WIDTH*0.7)
            }, completion: { _ in
                self.helper.creature_up = false
                self.creature_view_button_top_sign.image = UIImage(named: "pet_story_up")
            })
        }
    }
    
    func start_play_animation()  {
        let wifi_image: UIImageView = view.viewWithTag(helper.wifi_view_tag) as! UIImageView
        let yellow_sing: UIImageView = view.viewWithTag(helper.yellow_sign_tag) as! UIImageView
        let red_sign: UIImageView = view.viewWithTag(helper.red_sign_tag) as! UIImageView
        let green_sing: UIImageView = view.viewWithTag(helper.green_sign_tag) as! UIImageView

        wifi_image.startAnimating()
        yellow_sing.startAnimating()
        red_sign.startAnimating()
        green_sing.startAnimating()
    }
    
    func end_play_animation() {
        let wifi_image: UIImageView = view.viewWithTag(helper.wifi_view_tag) as! UIImageView
        let yellow_sing: UIImageView = view.viewWithTag(helper.yellow_sign_tag) as! UIImageView
        let red_sign: UIImageView = view.viewWithTag(helper.red_sign_tag) as! UIImageView
        let green_sing: UIImageView = view.viewWithTag(helper.green_sign_tag) as! UIImageView
        
        wifi_image.stopAnimating()
        yellow_sing.stopAnimating()
        red_sign.stopAnimating()
        green_sing.stopAnimating()
    }
    
    func set_creature_view_title_button_show(_ tag: Int) {
        let creature_view: UIView = view.viewWithTag(helper.creature_view_tag)!
        helper.select_button_tag = tag
        creature_view.addSubview(creature_view_button_top_sign)
        
        let ocean_button: UIButton = creature_view.viewWithTag(helper.ocean_button_tag) as! UIButton
        if helper.ocean_locked{
            if tag == helper.ocean_button_tag{
                set_button_light_status(ocean_button, imageName: "pet_story_ocean_light")
            }else{
                set_button_normal_status(ocean_button, imageName: "pet_story_ocean_normal")
            }
        }
        
        let wood_button: UIButton = creature_view.viewWithTag(helper.wood_button_tag) as! UIButton
        if helper.wood_locked{
            if tag == helper.wood_button_tag{
                set_button_light_status(wood_button, imageName: "pet_story_wonder_light")
            }else{
                set_button_normal_status(wood_button, imageName: "pet_story_wonder_normal")
            }
        }

        let desert_button: UIButton = creature_view.viewWithTag(helper.desert_button_tag) as! UIButton
        if helper.desert_locked{
            if tag == helper.desert_button_tag{
                set_button_light_status(desert_button, imageName: "pet_story_desert_light")
            }else{
                set_button_normal_status(desert_button, imageName: "pet_story_desert_normal")
            }
        }
    }
    
    func set_button_normal_status(_ button: UIButton, imageName: String) {
        button.transform = CGAffineTransform.identity
        button.transform = button.transform.scaledBy(x: 1, y: 1)
        button.setBackgroundImage(UIImage(named: imageName), for: .normal)
    }
    
    func set_button_light_status(_ button: UIButton, imageName: String)  {
        creature_view_button_top_sign.snp.removeConstraints()

        button.transform = CGAffineTransform.identity
        button.transform = button.transform.scaledBy(x: 1.136, y: 1.608)
        button.setBackgroundImage(UIImage(named: imageName), for: .normal)

        creature_view_button_top_sign.snp.makeConstraints({ (contentView) in
            contentView.centerX.equalTo(button)
            contentView.bottom.equalTo(button.snp.top)
            contentView.size.equalTo(CGSize(width: button.frame.width/4.464, height: button.frame.width/6.41))
        })
    }
    
    func check_creature_up_ro_down(_ sender: UIButton)  {
        if sender.tag < helper.four_button_tag{
            if helper.creature_up{
                if helper.select_button_tag == sender.tag{
                    creature_down_animation()
                }
            }else{
                creature_up_animation()
            }
            set_creature_view_title_button_show(sender.tag)
        }
    }

    @objc func creature_view_button_click(_ sender: UIButton){
        let scroller: UIScrollView = view.viewWithTag(helper.scroller_view_tag) as! UIScrollView
        
        if sender.tag == helper.ocean_button_tag{
            if helper.ocean_locked{
                check_creature_up_ro_down(sender)
                scroller.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }else{
                show_world_not_locked(Localizaed("The world is unlocked, keep drinking water to unlock more interesting stories."))
            }
        }else if sender.tag == helper.wood_button_tag{
            if helper.wood_locked{
                check_creature_up_ro_down(sender)
                scroller.setContentOffset(CGPoint(x: SCREEN_HEIGHT, y: 0), animated: true)
            }else{
                show_world_not_locked(Localizaed("The world is unlocked, keep drinking water to unlock more interesting stories."))
            }
        }else if sender.tag == helper.desert_button_tag{
            if helper.desert_locked{
                check_creature_up_ro_down(sender)
                scroller.setContentOffset(CGPoint(x: SCREEN_HEIGHT*2, y: 0), animated: true)
            }else{
                show_world_not_locked(Localizaed("The world is unlocked, keep drinking water to unlock more interesting stories."))
            }
        }else{
            show_world_not_locked(Localizaed("The world is unlocked, keep drinking water to unlock more interesting stories."))
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let scrollViewW: CGFloat = scrollView.frame.width
        let pageX: CGFloat = scrollView.contentOffset.x
        let page: Int = Int((pageX + scrollViewW/2) / scrollViewW)
        set_creature_view_title_button_show(page + helper.creature_view_tag + 1)
    }
    
    func show_world_not_locked(_ info: String) {
        let mainSB = UIStoryboard(name: "PetParadise", bundle: nil)
        let alter_view: PetStoryAlterView = mainSB.instantiateViewController(withIdentifier: "pet_story_alter_view") as! PetStoryAlterView
        view.addSubview(alter_view.view)
        alter_view.view.center = CGPoint(x: view.center.y, y: view.center.x)
        alter_view.view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        
        let bgImage = UIImageView(frame: CGRect(x: SCREEN_HEIGHT*0.05, y:(SCREEN_HEIGHT-SCREEN_WIDTH*0.557)/2, width: SCREEN_WIDTH*0.909, height: SCREEN_WIDTH*0.557))
        bgImage.image = UIImage(named: "pet_story_alter_bg")
        bgImage.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
        alter_view.view.addSubview(bgImage)
        
        let titleInfo = UILabel(frame: CGRect(x: SCREEN_WIDTH*0.13, y: SCREEN_WIDTH*0.05, width: SCREEN_WIDTH*0.632, height:  SCREEN_WIDTH*0.267))
        titleInfo.font = UIFont(name: BASEFONT, size: 20)
        titleInfo.numberOfLines = 0
        titleInfo.textColor = RGB_COLOR(114, g: 255, b: 190, alpha: 1)
        titleInfo.text = info
        bgImage.addSubview(titleInfo)
        
        let confirm_button = UIButton(frame: CGRect(x: SCREEN_WIDTH*0.55, y: (SCREEN_HEIGHT-SCREEN_WIDTH*0.1)/2, width: SCREEN_WIDTH*0.333, height: SCREEN_WIDTH*0.1))
        confirm_button.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
        confirm_button.addTarget(self, action: #selector(remove_alter_view), for: .touchUpInside)
        confirm_button.setBackgroundImage(UIImage(named: "pet_story_alter_button"), for: .normal)
        confirm_button.setTitle(Localizaed("Got it"), for: .normal)
        confirm_button.titleLabel?.textColor = .white
        confirm_button.titleLabel?.font = UIFont(name: BASEFONT, size: 23)
        alter_view.view.addSubview(confirm_button)
    }
    
    @objc func remove_alter_view(){
        for view:UIView in self.view.subviews {
            if view.tag == pet_story_show_alter_tag{
                view.removeFromSuperview()
            }
        }
    }
    
    @IBAction func back(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype  = kCATransitionFromBottom
        navigationController?.view.layer.add(transition, forKey: nil)
        _ = navigationController?.popViewController(animated: false)
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
