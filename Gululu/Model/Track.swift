//
//  Track.swift
//  Gululu
//
//  Created by baker on 2017/11/30.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit
import DOUAudioStreamer

class Track: NSObject, DOUAudioFile {
    
    func audioFileURL() -> URL! {
        return URL(string: audioFileUrl)
    }
    
    var title = String()
    var atrist = String()
    var audioFileUrl = String()
}
