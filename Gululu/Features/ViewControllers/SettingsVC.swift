//
//  SettingsVC.swift
//  Gululu
//
//  Created by Ray Xu on 24/12/2015.
//  Copyright © 2015 Ray Xu. All rights reserved.
//

import UIKit

class SettingsVC: BaseViewController ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var setTitle: UILabel!
    @IBOutlet weak var ItemTableView: UITableView!
    
    let setSchoolView = SetSchoolModeVC()
    let setBedView = SetBedModeVC()
    let aboutView = AboutViewController()

    var newSignLabel : UILabel?
    let helper = SettingHelper.share
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle.text = SETTING
        
        helper.setItemDatasource()
        setTableViewStyle()
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ItemTableView.reloadData()
    }
    
    func setTableViewStyle()  {
        ItemTableView.backgroundColor = .clear
        ItemTableView.dataSource = self
        ItemTableView.delegate = self
        ItemTableView.isScrollEnabled = false
        ItemTableView.separatorColor = .clear
        let view = UIView()
        view.backgroundColor = .white
        ItemTableView.tableFooterView = view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return helper.itemData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if SCREEN_WIDTH < 375{
            return 64
        }else{
            return 78
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        let item : InfoCell = helper.itemData[(indexPath as NSIndexPath).row]
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.imageView?.image = item.image
        cell.textLabel?.font = UIFont(name: BASEBOLDFONT,size: 22)
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = "    " + item.name
        
        let cellImageWidth = FIT_SCREEN_WIDTH(50)
        var itemSize : CGSize
        switch (indexPath as NSIndexPath).row {
        case 0:
            if GChild.share.childIsHaveCup(){
                addRedSignInSettingButton(cell)
                cell.contentView.alpha = 1.0
            }else{
                cell.contentView.alpha = 0.5
            }
            itemSize = CGSize(width: cellImageWidth, height: FIT_SCREEN_WIDTH(50))
        case 1:
            itemSize = CGSize(width: cellImageWidth, height: FIT_SCREEN_WIDTH(40))
        case 2:
            itemSize = CGSize(width: cellImageWidth, height: FIT_SCREEN_WIDTH(58))
        case 3:
            itemSize = CGSize(width: cellImageWidth, height: FIT_SCREEN_WIDTH(40))
        case 4:
            itemSize = CGSize(width: cellImageWidth, height: FIT_SCREEN_WIDTH(46))
        default:
            itemSize = CGSize(width: cellImageWidth, height: cellImageWidth)
        }
        UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale)
        let imageRect = CGRect(x: 0.0, y: 0.0, width: itemSize.width, height: itemSize.height)
        cell.imageView?.image?.draw(in: imageRect)
        cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath as NSIndexPath).row {
        case 0:
            pushToWifiSetting()
            break
        case 1:
            gotoSchoolModelVC()
            break
        case 2:
            gotoSleepModelVC()
            break
        case 3:
            gotoParaent()
            break
        case 4:
            showInfo()
            break
        default:
            return
        }
    }
    
    func pushToWifiSetting()  {
        if GChild.share.childIsHaveCup(){
            goto(vcName: "cupCenter", boardName: "Settings")
        }else{
             showNoGululuConnected()
        }
    }
    
    func showNoGululuConnected() {
        let alertView = BHAlertView(frame: view.frame)
        let message = String(format:Localizaed("There's no bottle connected to %@. You can add one on the home screen"),GChild.share.getActiveChildName())
        alertView.initAlertContent(Localizaed("No Gululu connected"), message: message, leftBtnTitle:GOTIT ,rightBtnTitle: "")
        alertView.presentBHAlertView()
    }
    
    func gotoSchoolModelVC() {
        navigationController?.pushViewController(setSchoolView, animated: true)
    }

    func gotoSleepModelVC() {
        navigationController?.pushViewController(setBedView, animated: true)
    }
    
    func showInfo() {
        navigationController!.pushViewController(aboutView, animated: true)
    }
    
    func gotoParaent() {
        goto(vcName: "parentAccountVC", boardName: "Settings")
    }
    
    func addRedSignInSettingButton(_ cell : UITableViewCell) {
        var redSignView : UIView? = cell.viewWithTag(main_helpshift_red_sign_tag)

        if CupInfoHelper.share.cupConnectTimeLastThreeDays{
            if redSignView == nil{
                redSignView = UIView()
                redSignView!.tag = main_helpshift_red_sign_tag
                
                let labelWidth = Common.getLabWidth(labelStr: (cell.textLabel?.text)!, font: (cell.textLabel?.font)!, height: 10)
                
                cell.addSubview(redSignView!)
                redSignView!.snp.makeConstraints{ (ConstraintMaker) in
                    ConstraintMaker.centerY.equalTo(cell)
                    ConstraintMaker.left.equalTo(cell.textLabel!).offset(labelWidth+10)
                    //ConstraintMaker.centerX.equalTo(cell).offset(FIT_SCREEN_WIDTH(20))
                    ConstraintMaker.size.equalTo(CGSize(width: 15, height: 15))
                }
                redSignView?.backgroundColor = .red
                redSignView?.layer.masksToBounds = true
                redSignView?.layer.cornerRadius = 7.5
                redSignView?.layer.borderColor = UIColor.white.cgColor
                redSignView?.layer.borderWidth = 3.0
            }else{
                redSignView?.isHidden = false
            }
        }else{
            removeRedSign(cell)
        }
    }
    
    func removeRedSign(_ view : UIView) {
        let redSignView : UIView? = view.viewWithTag(main_helpshift_red_sign_tag)
        if redSignView != nil{
            redSignView?.removeFromSuperview()
        }
    }

}
