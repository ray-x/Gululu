//
//  WelcomeVC.swift
//  Gululu
//
//  Created by Ray Xu on 24/11/2015.
//  Copyright © 2015 Ray Xu. All rights reserved.
//

import UIKit

class WelcomeVC: BaseViewController {

    @IBOutlet weak var welcomLabel: UILabel!
    
    @IBOutlet weak var welComeButton: UIButton!
    override func viewDidLoad() {
        var petName = ""
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        if activeChildID == ""{
            petName = GPet.share.changePetName(petName:"")
        }else{
            GPet.share.readPetFromeLocal()
            if GPet.share.localHavePet(){
                let activePet = GPet.share.getActivePetInPetList()
                if activePet == nil{
                    petName = "Ninji"
                }else{
                    petName = GPet.share.changePetName(petName: activePet?.petName!)
                }
            }else{
                petName = "Ninji"
            }

        }
        
        welcomLabel.text = String(format: Localizaed("%@ will come to Gululu after rebooting!"),petName)
        welComeButton.setTitle(Localizaed("Finish"), for: .normal)
        welcomLabel.lineBreakMode=NSLineBreakMode.byWordWrapping
        
        if GUser.share.appStatus == .changeWifi {
            showMainVC(self)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showMainVC(_ sender: AnyObject) {
        goto(vcName: "showMainVC", boardName: "Main")
    }
}
