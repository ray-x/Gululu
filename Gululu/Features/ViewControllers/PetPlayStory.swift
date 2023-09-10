//
//  PetPlayStory.swift
//  Gululu
//
//  Created by baker on 2017/11/30.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit
import DOUAudioStreamer
////import Flurry_iOS_SDK

class PetPlayStory: NSObject {

}

extension PetStoryVC{
    
    @objc func play(_ sender: UIButton){
        if sender.tag == helper.play_btn_tag{
            if helper.streamer?.status == DOUAudioStreamerStatus.paused || helper.streamer?.status == DOUAudioStreamerStatus.idle{
                streamer_just_player()
                return
            }
            streamer_start_play()
        }else if sender.tag == helper.stop_btn_tag{
            streamer_stop_play()
        }else{
            click_creature_plater_vedio(sender.tag - helper.scroller_view_tag)
        }
    }
    
    func click_creature_plater_vedio(_ senderTag: Int) {
        if helper.creature_is_locked(senderTag){
            if helper.click_media_info_can_play(senderTag){
                if senderTag == helper.currentTrackIndex{
                    if helper.streamer?.status == DOUAudioStreamerStatus.paused || helper.streamer?.status == DOUAudioStreamerStatus.idle{
                        print("just puse and play")
                        streamer_just_player()
                        return
                    }else{
                        if helper.streamer == nil{
                            streamer_start_play()
                        }
                        return
                    }
                }
                let sender: UIButton = scrollerView.viewWithTag(senderTag +  helper.scroller_view_tag) as! UIButton
                select_circle_image.center = sender.center
                helper.currentTrackIndex = senderTag
                streamer_start_play()
            }else{
                show_world_not_locked(Localizaed("Coming soon！"))
            }
        }else{
            show_world_not_locked(Localizaed("This creature is unlocked, keep drinking water to unlock more interesting stories."))
        }
    }
    
    func streamer_stop_play() {
        if helper.streamer?.status == DOUAudioStreamerStatus.playing{
            play_btn.tag = helper.play_btn_tag
            play_btn.setBackgroundImage(UIImage(named: "pet_story_play"), for: .normal)
            helper.streamer?.pause()
            deinitTimer()
            end_play_animation()
        }
    }
    
    func streamer_start_play()  {
        //Flurry.logEvent("Pet_story_play_btn_click")
        cancle_streamer()
        checkout_switch_button_status()
        let media_info = helper.get_click_media_info(helper.currentTrackIndex)
        if !isValidString(media_info.url){
            return
        }
        let click_track = helper.get_current_Track(media_info)
        let default_image = UIImage(named: "pet_story_creature_default")
        small_creature_image.sd_setImage(with: URL(string: media_info.thumb_url!), placeholderImage: default_image, options: .highPriority, completed: nil)
        helper.streamer = DOUAudioStreamer(audioFile: click_track)
        add_notifacation_streamer_palyer()
        streamer_just_player()
    }
    
    func streamer_just_player() {
        play_btn.setBackgroundImage(UIImage(named: "pet_story_stop"), for: .normal)
        play_btn.tag = helper.stop_btn_tag
        helper.streamer?.play()
        setTheTimer()
        start_play_animation()
    }
    
    @objc func next_vedio(){
        let nextInt = helper.currentTrackIndex + 1
        if nextInt >= helper.get_all_lock_creature_numbers(){
            let tips = Localizaed("Last Audio")
            BAlterTipView().load_view(tips, direction: 2)
            return
        }
        click_creature_plater_vedio(nextInt)
    }
    
    @objc func pervious(){
        let nextInt = helper.currentTrackIndex - 1
        if nextInt <= 0{
            let tips = Localizaed("First Audio")
            BAlterTipView().load_view(tips, direction: 2)
            return
        }
        click_creature_plater_vedio(nextInt)
    }
    
    func checkout_switch_button_status() {
        let perviousInt = helper.currentTrackIndex - 1
        if perviousInt <= 0{
            pervious_btn.setBackgroundImage(UIImage.init(named: "pet_story_pervious_disabble"), for: .normal)
            pervious_btn.isEnabled = false
            pervious_btn.alpha = 1.0
        }else{
            pervious_btn.setBackgroundImage(UIImage.init(named: "pet_story_pervious"), for: .normal)
            pervious_btn.isEnabled = true
            pervious_btn.alpha = 0.8
        }
        
        let nextInt = helper.currentTrackIndex + 1
        if nextInt > helper.get_all_lock_creature_numbers(){
            next_btn.setBackgroundImage(UIImage.init(named: "pet_story_next_disabble"), for: .normal)
            next_btn.isEnabled = false
            next_btn.alpha = 1.0
        }else{
            next_btn.setBackgroundImage(UIImage.init(named: "pet_story_next"), for: .normal)
            next_btn.isEnabled = true
            next_btn.alpha = 0.8
        }
    }
    
    func add_notifacation_streamer_palyer() {
        if helper.get_all_lock_creature_numbers() == 0{
            return
        }else{
            helper.streamer?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context:  &helper.kStatusKVOKey)
            helper.streamer?.addObserver(self, forKeyPath: "duration", options: NSKeyValueObservingOptions.new, context:  &helper.kDurationKVOKey)
            helper.streamer?.addObserver(self, forKeyPath: "bufferingRatio", options: NSKeyValueObservingOptions.new, context:  &helper.kBufferingRatioKVOKey)
        }
    }
    
    @objc func slideProcessChang(_ slider: UISlider){
        if helper.streamer != nil{
            helper.streamer?.currentTime = (helper.streamer?.duration)! * Double(slider.value)
        }
        if helper.streamer?.status == DOUAudioStreamerStatus.paused || helper.streamer?.status == DOUAudioStreamerStatus.idle{
            print("slider just puse and play")
            streamer_just_player()
        }
    }
    
    @objc func updateBufferingStatus()  {
        let str = String(format:"Received %.2f/%.2f MB (%.2f %%), Speed %.2f MB/s", Double((helper.streamer?.receivedLength)!)/1024/1024, Double((helper.streamer?.expectedLength)!/1024/1024), (helper.streamer?.bufferingRatio)!*100.0, Double((helper.streamer?.downloadSpeed)!)/1024/1024)
        if helper.streamer?.bufferingRatio >= 1.0{
            // todo
        }
        print(str)
    }
    
    func setupHintForStreamer() {
        var nextIndex: NSInteger = helper.currentTrackIndex + 1
        if nextIndex >= helper.ocean_array.count{
            nextIndex = 0
        }
        let next_media_info  = helper.ocean_array[nextIndex]
        let track = Track()
        track.audioFileUrl = (next_media_info.url)!
        DOUAudioStreamer.setHintWith(track)
    }
    
    func setTheTimer() {
        if helper.play_timer != nil{
            deinitTimer()
        }
        helper.play_timer = DispatchSource.makeTimerSource(queue: .main)
        helper.play_timer?.schedule(deadline: .now(), repeating: LoginHelper.share.oneStepTime)
        helper.play_timer?.setEventHandler {
            self.time_action()
        }
        // 启动定时器
        helper.play_timer?.resume()
    }
    
    @objc func time_action() {
        if helper.streamer?.duration == 0{
            play_timer_label.text = "00:00"
            slider.setValue(0, animated: false)
        }else{
            let paly_time = BKDateTime.timer_form_interval(helper.streamer?.currentTime)
            let total_time = BKDateTime.timer_form_interval(helper.streamer?.duration)
            play_timer_label.text = paly_time
            total_timer_label.text = total_time
            
            if helper.streamer?.currentTime == nil{
                slider.setValue(0, animated: false)
                return
            }
            let valueInt = Float((helper.streamer?.currentTime)!) / Float((helper.streamer?.duration)!)
            slider.setValue(valueInt, animated: false)
        }
    }
    
    func deinitTimer() {
        if helper.play_timer != nil{
            helper.play_timer?.cancel()
            helper.play_timer = nil
        }
    }
    
    @objc func updateStatus() {
        if helper.streamer?.status == DOUAudioStreamerStatus.playing{
            print("helper.streamer?.status == playing")
        }else if helper.streamer?.status == DOUAudioStreamerStatus.paused{
            print("helper.streamer?.status == paused")
        }else if helper.streamer?.status == DOUAudioStreamerStatus.idle{
            print("helper.streamer?.status == idle")
        }else if helper.streamer?.status == DOUAudioStreamerStatus.finished{
            print("helper.streamer?.status == finished")
            if helper.click_media_info_can_play(helper.currentTrackIndex + 1){
                next_vedio()
            }else{
                streamer_stop_play()
                show_world_not_locked(Localizaed("Coming soon！"))
            }
        }else if helper.streamer?.status == DOUAudioStreamerStatus.buffering{
            print("helper.streamer?.status == buffering")
        }else{
            print("helper.streamer?.status == error")
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &helper.kStatusKVOKey{
            DispatchQueue.main.async {
                self.updateStatus()
            }
        }else if context == &helper.kDurationKVOKey{
            DispatchQueue.main.async {
                print("play_notication_time_action")
                self.time_action()
            }
        }else if context == &helper.kBufferingRatioKVOKey{
            DispatchQueue.main.async {
                self.updateBufferingStatus()
            }
        }else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    // Streamer
    func cancle_streamer() {
        if helper.streamer != nil{
            helper.streamer?.pause()
            helper.streamer?.removeObserver(self, forKeyPath: "status")
            helper.streamer?.removeObserver(self, forKeyPath: "duration")
            helper.streamer?.removeObserver(self, forKeyPath: "bufferingRatio")
            helper.streamer = nil
        }
    }
    
    
    
}
