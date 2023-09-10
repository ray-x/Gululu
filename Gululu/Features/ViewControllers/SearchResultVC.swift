//
//  SearchResultVC.swift
//  Gululu
//
//  Created by Baker on 2017/10/30.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit
//import Flurry_iOS_SDK

class SearchResultVC: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    let helper = FriendHelper.share

    @IBOutlet weak var search_title: UILabel!
    @IBOutlet weak var search_table_view: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.search_title.text = Localizaed("Search Results")
        search_table_view.delegate = self
        search_table_view.dataSource = self
        search_table_view.backgroundColor = .clear
        search_table_view.separatorColor = .clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let tips = String(format:Localizaed("Account %@ has %d child, fast add them as friend"), helper.search_account, helper.search_friends.count)
        BAlterTipView().load_view(tips, direction: 0)
    }

    // MARK: - UITabelView Datasource
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return helper.search_friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let search_cell: SearchCell = tableView.dequeueReusableCell(withIdentifier: "search_friend_cell", for: indexPath) as! SearchCell
        search_cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if helper.search_friends.count > 0 {
            let friendInfo: Friend = helper.search_friends[(indexPath as NSIndexPath).row]
            search_cell.reloadFriendTableViewCell(friendInfo, index: (indexPath as NSIndexPath).row)
            search_cell.add_button.tag = indexPath.row
            search_cell.add_button.addTarget(self, action: #selector(search_friend_cell_add_action(_:)), for: .touchUpInside)
        } else {
            search_cell.child_name.text = "Gulülu Inc."
        }
        return search_cell
    }
    
    // MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SCREEN_HEIGHT / 7.02
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @objc func search_friend_cell_add_action(_ button: UIButton)  {
        //Flurry.logEvent("AddFriendBtn")
        let friendInfo: Friend = helper.search_friends[button.tag]
        if friendInfo.x_child_sn == activeChildID{
            show_add_self_error()
            return
        }
        if friendInfo.add_friend_status == .add{
            helper.post_pending_friend(friendInfo.x_child_sn!) { (result) in
                DispatchQueue.main.async {
                    if result == 0 {
                        friendInfo.add_friend_status = .adding
                        self.show_send_success()
                    }else if result == 1{
                        self.show_add_self_error()
                    }else{
                        GHHttpHelper.show_server_error()
                    }
                }
            }
        }
    }
    
    func show_add_self_error() {
        LoadingView().stopAnimation()
        let alertView = BHAlertView(frame: view.frame)
        alertView.initAlertContent("", message:  Localizaed("You can not add yourself as a friend"), leftBtnTitle: DONE, rightBtnTitle: "")
        alertView.presentBHAlertView()
    }
    
    func show_add_friend_failed() {
        LoadingView().stopAnimation()
        let alertView = BHAlertView(frame: view.frame)
        alertView.initAlertContent("", message:  Localizaed("add failed"), leftBtnTitle: DONE, rightBtnTitle: "")
        alertView.presentBHAlertView()
    }
    
    func show_send_success() {
        search_table_view.reloadData()
        BAlterTipView().load_view(Localizaed("Friend request has been sent"), direction: 0)
    }
    
    @IBAction func back(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}
