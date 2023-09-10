//
//  UpgradeView.swift
//  Gululu
//
//  Created by Baker on 16/12/30.
//  Copyright © 2016年 Ray Xu. All rights reserved.
//

import UIKit

class UpgradeView: BaseViewController ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tipTableView: UITableView!
    @IBOutlet weak var upgradeButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var itemSource : [UpgradeInfoItem] = [UpgradeInfoItem]()
    var clickIndex : IndexPath?
    var showUP : Bool = false
    var cellHeight : CGFloat = 0
    
    let CellIdentifierNib : String = "upgradeCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpgradeButtonStyle()
        
        setViewBgColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        titleLabel.text = MainUpgrade.shareInstance.getPetUpgradeStatusStr()
        upgradeButton.setTitle(MainUpgrade.shareInstance.getUpgradeButtonTitle(), for: .normal)

        itemSource = MainUpgrade.shareInstance.setPetUpgradeData()
        tipTableView.delegate = self
        tipTableView.dataSource = self
        tipTableView.reloadData()
        tipTableView.backgroundColor = .clear
        tipTableView.tableFooterView = UIView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        MainUpgrade.shareInstance.setUpgradeFlurryLog()

        super.viewDidAppear(animated)
        
        if MainUpgrade.shareInstance.petGradeStatus == .upgrading{
            let indepath : IndexPath = IndexPath(item: 0, section: 0)
            tableView(tipTableView, didSelectRowAt: indepath)
        }else if MainUpgrade.shareInstance.petGradeStatus == .downloading{
            let indepath : IndexPath = IndexPath(item: 0, section: 0)
            tableView(tipTableView, didSelectRowAt: indepath)
        }
    }
    
    func setUpgradeButtonStyle() {
        upgradeButton.layer.masksToBounds = true
        upgradeButton.layer.cornerRadius = 6
    }
    
    func setViewBgColor() {
        let topColor = UIColor(red: (66/255.0), green: (163/255.0), blue: (255/255.0), alpha: 1)
        let buttomColor = UIColor(red: (66/255.0), green: (255/255.0), blue: (213/255.0), alpha: 1)
        let gradientColors: [CGColor] = [topColor.cgColor, buttomColor.cgColor]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        
        gradientLayer.colors = gradientColors
        gradientLayer.frame = view.frame
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func upgradeAction(_ sender: Any) {

        if MainUpgrade.shareInstance.petGradeStatus == .done{
            bakc(backButton)
        }else if MainUpgrade.shareInstance.petGradeStatus == .upgrading{
            bakc(backButton)
        }else if MainUpgrade.shareInstance.petGradeStatus == .downloading{
            bakc(backButton)
        }else if MainUpgrade.shareInstance.petGradeStatus == .ready{
            GUser.share.appStatus = .upgradePet
            let sb = UIStoryboard(name: "ChosePet", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "PetSelectionVC")
            self.navigationController?.pushViewController(vc, animated: true)
        }else if MainUpgrade.shareInstance.petGradeStatus == .require{

            let indepath : IndexPath = IndexPath(item: 0, section: 3)
            if clickIndex?.section == indepath.section{
                if showUP {
                    tipTableView.scrollToRow(at: indepath, at: .top, animated: true)
                    return
                }
            }
            for index in tipTableView.indexPathsForVisibleRows!{
                if index.section == 3{
                    tableView(tipTableView, didSelectRowAt: indepath)
                    return
                }
            }
            tipTableView.scrollToRow(at: indepath, at: .top, animated: true)

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self.tableView(self.tipTableView, didSelectRowAt: indepath)
            }
        }
    }
    
    @IBAction func bakc(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype  = kCATransitionFromBottom
        navigationController?.view.layer.add(transition, forKey: nil)
        _ = navigationController?.popToRootViewController(animated: false)
    }
    
    //MARK : tableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headView : UIView = UIView()
        headView.backgroundColor = .clear
        return headView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath == clickIndex {
            if showUP {
                return MainUpgrade.shareInstance.withToHeight*tipTableView.frame.width + cellHeight + 48 + 5
            }else{
                return 80
            }
        }else{
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : UpgradeCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierNib, for: indexPath) as! UpgradeCell
        let item : UpgradeInfoItem = itemSource[(indexPath as NSIndexPath).section]
        cell.selectionStyle = .none
        cell.upgradeImage.image = UIImage(named: item.headImageName)
        cell.upgradeTitle.text = item.upgradeTitle
        cell.upgradeDetailInfo.text = item.upgradeDetailInfo
        if clickIndex == indexPath{
            if showUP {
                cell.upgradeImage.image = UIImage(named: item.bigImageName )
                cell.upgradeDetailInfo.text = item.upgradeLongDN
            }else{
                cell.upgradeImage.image = UIImage(named: item.headImageName)
                cell.upgradeDetailInfo.text = item.upgradeDetailInfo
                cell.offCellSelectAnimation(false)
            }
        }else{
            cell.offCellSelectAnimation(false)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if clickIndex != indexPath{
            showUP = true
            if clickIndex != nil{
                let cell : UpgradeCell? = tableView.cellForRow(at: clickIndex!) as? UpgradeCell
                if cell != nil {
                    let item : UpgradeInfoItem = itemSource[(clickIndex! as IndexPath).section]
                    cell!.upgradeDetailInfo.text = item.upgradeDetailInfo
                    cell!.offCellSelectAnimation(true)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                        cell!.upgradeImage.image = UIImage(named: item.headImageName)
                        UIView.animate(withDuration: 0.1, animations: {
                            cell!.upgradeImage.alpha = 1.0
                        })
                    }
                }
            }
        }else{
            showUP = !showUP
        }
 
        let cell : UpgradeCell? = tableView.cellForRow(at: indexPath) as? UpgradeCell
        if cell == nil{
            return
        }
        
        checkoutIsShowUP(indexPath)

        clickIndex = indexPath
        
        cellHeight = Common.getLabHeigh(labelStr: cell!.upgradeDetailInfo.text!, font: cell!.upgradeDetailInfo.font, width: cell!.upgradeDetailInfo.frame.width + 75)

        tipTableView.beginUpdates()
        tipTableView.endUpdates()
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func checkoutIsShowUP(_ indexPath : IndexPath) {
        
        let cell : UpgradeCell? = tipTableView.cellForRow(at: indexPath) as? UpgradeCell
        let item : UpgradeInfoItem = itemSource[(indexPath as NSIndexPath).section]

        if cell == nil{
            return
        }
        if showUP{
            cell!.upgradeDetailInfo.text = item.upgradeLongDN
            cell!.upgradeImage.image = UIImage(named: item.bigImageName )
            cell!.onCellSelectAnimation(true)
        }else{
            cell!.upgradeDetailInfo.text = item.upgradeDetailInfo
            cell!.offCellSelectAnimation(true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                cell!.upgradeImage.image = UIImage(named: item.headImageName)
                UIView.animate(withDuration: 0.1, animations: {
                    cell!.upgradeImage.alpha = 1.0
                })
            }
        }
    }

}
