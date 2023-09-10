//
//  ShareVC.swift
//  Gululu
//
//  Created by Baker on 17/7/13.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

class ShareVC: UIViewController {

    @IBOutlet weak var shareImage: UIImageView!
    @IBOutlet weak var deeplink: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func share(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: deeplink.text!)!)
    }

}
