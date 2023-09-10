//
//  PlayVedioVC.swift
//  Gululu
//
//  Created by Baker on 17/7/12.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer

class PlayVedioVC: AVPlayerViewController {
    
    let tutorialHelper = TutorialHelper.share

    override func viewDidLoad() {
        super.viewDidLoad()
        self.player = AVPlayer(url: tutorialHelper.clickUrl!)
        self.player?.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
//        hideNavigation()
    }
    
}
