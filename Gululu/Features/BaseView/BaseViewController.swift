//
//  BaseViewController.swift
//  Gululu
//
//  Created by Ray Xu on 26/10/2015.
//  Copyright © 2015 Ray Xu. All rights reserved.
//

import UIKit
import SDWebImage

class BaseViewController: UIViewController {
    
    var statusBarHidden  = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = ""
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backItem?.title = ""
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.0, green: 174.0/255.0, blue: 228.0/255.0, alpha: 0.5)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Resign First Responder of UITextField
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override var prefersStatusBarHidden: Bool{
        return statusBarHidden
    }
    
    func hideNavigation() {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func goto(vcName:String? , boardName:String?) {
        if vcName == nil || boardName == nil || vcName == "" || boardName == ""{
            return
        }
        let SB = UIStoryboard(name: boardName!, bundle: nil)
        let VC: UIViewController = SB.instantiateViewController(withIdentifier: vcName!)
        navigationController?.pushViewController(VC, animated: true)
    }
    
    func showPrivacyVC()  {
        let broswerView = BrowserViewController()
        broswerView.webURL = privacy_web_url
        present(broswerView, animated: true, completion: nil)
    }
    
}
