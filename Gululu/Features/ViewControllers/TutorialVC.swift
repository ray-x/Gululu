//
//  TutorialVC.swift
//  Gululu
//
//  Created by Baker on 17/6/21.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit
//import Flurry_iOS_SDK

class TutorialVC: BaseViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tTitleLabel: UILabel!
    @IBOutlet weak var TPet: UIImageView!
    @IBOutlet weak var TTableView: UITableView!
    
    let tutorialHelper = TutorialHelper.share
    var mediaArray  = [MediaInfo]()
    var isHandleView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TTableView.dataSource = self
        TTableView.delegate = self
        TTableView.backgroundColor = .clear
        TPet.image = UIImage(named: tutorialHelper.getBgPetImageName())
        tTitleLabel.text = tutorialHelper.getTutorialTitle()
        getVedioInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statusBarHidden = false
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override var prefersStatusBarHidden: Bool{
        return false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func getVedioInfo() {
        TutorialHelper.share.getUserVedio({ result in
            DispatchQueue.main.async {
                self.handleResult(result)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func handleResult(_ remoteMediaArray : [MediaInfo]) {
        mediaArray = remoteMediaArray
        TTableView.reloadData()
    }
    
    @IBAction func back(_ sender: Any) {
        
        if isHandleView == false{
           tutorialHelper.uplodeUserIsHandleView(isHandleView)
        }
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype  = kCATransitionFromBottom
        navigationController?.view.layer.add(transition, forKey: nil)
        _ = navigationController?.popToRootViewController(animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return mediaArray.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FIT_SCREEN_WIDTH(220)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TutorialVedioCell = tableView.dequeueReusableCell(withIdentifier: "tutorialVedioCell", for: indexPath) as! TutorialVedioCell
        let btnBgImageName  = tutorialHelper.getTutorialButtonBgImageName()
        let btnBgImage = UIImage(named: btnBgImageName)
        cell.btnPlay.setBackgroundImage(btnBgImage, for: .normal)
        let mediaInfo = getMediaInfoFromTag(indexPath.section)
        if mediaInfo == nil {
            return cell
        }
        cell.backgroundColor = .clear
        cell.btnPlay.setTitle(mediaInfo?.title, for: .normal)
        cell.btnPlay.tag = indexPath.section
        cell.btnPlay.addTarget(self, action: #selector(gotoHelpshift(_:)), for: .touchUpInside)
        cell.ThumbImageView.sd_setImage(with: URL(string:mediaInfo!.thumb_url!), placeholderImage: UIImage(named:"petPlay"))
        cell.selectionStyle = .none
        return cell
    }
    
    @objc func gotoHelpshift(_ btn : UIButton)  {
        isHandleView = true
        var sectionID : String?
        if btn.tag == 0{
            sectionID = "10"
            //Flurry.logEvent("story_text_click")
        }else if btn.tag == 1{
            sectionID = "11"
            //Flurry.logEvent("play_text_click")
        }
        HelpshiftSupport.showFAQSection(sectionID, with: self, with: nil)
    }
    
    func getMediaInfoFromTag(_ tag : Int) -> MediaInfo? {
        for mediaInfo in mediaArray {
            if mediaInfo.tag == String(tag){
                return mediaInfo
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isHandleView = true

        let mediaInfo = getMediaInfoFromTag(indexPath.section)
        if mediaInfo == nil {
            return
        }
        if  mediaInfo?.tag == "0"{
            //Flurry.logEvent("story_video_click")
        }
        if mediaInfo?.tag == "1"{
            //Flurry.logEvent("play_video_click")
        }
        tutorialHelper.clickUrl = URL(string: (mediaInfo?.url)!)

        let SB = UIStoryboard(name: "Settings", bundle: nil)
        let VC: UIViewController = SB.instantiateViewController(withIdentifier: "playVedio")
        self.present(VC, animated: false, completion: nil)
    }
    
}
