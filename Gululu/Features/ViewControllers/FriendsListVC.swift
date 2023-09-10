//
//  FriendsListVC.swift
//  Gululu
//
//  Created by Ray Xu on 31/12/2015.
//  Copyright © 2015 Ray Xu. All rights reserved.
//

import UIKit
//import Flurry_iOS_SDK

class FriendsListVC: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    let helper = FriendHelper.share
    
    @IBOutlet weak var my_tilte_label: UILabel!
    @IBOutlet weak var no_friend_tips_label: UILabel!
    @IBOutlet weak var no_friend_shake_image: UIView!
    @IBOutlet weak var no_friend_add_friend_btn: UIButton!
    @IBOutlet weak var FriendsListTableView: UITableView!
    @IBOutlet weak var add_title_button: UIButton!
    
    @IBOutlet weak var reject_button: UIButton!
    @IBOutlet weak var agree_button: UIButton!
    @IBOutlet weak var message_info: UILabel!
    @IBOutlet weak var message_head: ImageMaskView!
    @IBOutlet weak var message_view: UIView!
    @IBOutlet weak var message_view_height: NSLayoutConstraint!
    
    var refreshControl = UIRefreshControl()
    var timer: DispatchSourceTimer?

    override func viewDidLoad() {
        super.viewDidLoad()
        my_tilte_label.text = Localizaed("My Friends")
        FriendsListTableView.isHidden = true
        no_friend_tips_label.isHidden = true
        no_friend_shake_image.isHidden = true
        no_friend_add_friend_btn.isHidden = true
        helper.friend_list_show_message_falg = false
        if GUserConfigUtil.share.checkout_add_frined(){
            add_title_button.isHidden = false
            no_friend_add_friend_btn.isHidden = false
        }else{
            add_title_button.isHidden = true
            no_friend_add_friend_btn.isHidden = true
        }
        add_refresh_control()
    }
    
    func add_refresh_control() {
        self.automaticallyAdjustsScrollViewInsets = false
        refreshControl.addTarget(self, action: #selector(refresh_request), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: Localizaed("Pull down to refresh"), attributes:[NSAttributedStringKey.foregroundColor : UIColor.white])
        FriendsListTableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        hideNavigation()
        pull_friend()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (timer != nil){
            timer?.cancel()
            timer = nil
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        query_pending_friend()
    }
    
    @IBAction func back(_ sender: Any) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func add_action(_ sender: Any) {
        //Flurry.logEvent("Friend_list_add_btn_click")
        goto(vcName: "SearchInput", boardName: "FriendsVC")
    }
    
    @IBAction func add_button_action(_ sender: Any) {
        //Flurry.logEvent("Friend_list_no_friend_add_btn_click")
        goto(vcName: "SearchInput", boardName: "FriendsVC")
    }
    
    func show_message_view() {
        if helper.check_show_message_view(){
            if helper.friend_list_show_message_falg{
                return
            }
            change_message_view_info()
            animation_message_show()
        }
    }
    
    func change_message_view_info() {
        if helper.adding_pending_friends.count != 0{
            show_pending_friend_view(helper.adding_pending_friends.first!)
        }else{
            if helper.reject_pending_friends.count != 0{
                show_finish_pending_friend_view(helper.reject_pending_friends.first!)
            }
        }
    }
    
    func animation_message_show() {
        helper.friend_list_show_message_falg = true
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {
            self.message_view.transform = self.message_view.transform.translatedBy(x: 0, y: self.helper.friend_list_show_height)
            self.no_friend_tips_label.transform = self.no_friend_tips_label.transform.translatedBy(x: 0, y: self.message_view_height.constant)
            self.FriendsListTableView.transform = self.FriendsListTableView.transform.translatedBy(x: 0, y: self.message_view_height.constant)
        }) { (finish) in }
    }
    
    func animation_message_hiden() {
        helper.friend_list_show_message_falg = false
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {
            self.message_view.transform = self.message_view.transform.translatedBy(x: 0, y: -self.helper.friend_list_show_height)
            self.no_friend_tips_label.transform = self.no_friend_tips_label.transform.translatedBy(x: 0, y: -self.message_view_height.constant)
            self.FriendsListTableView.transform = self.FriendsListTableView.transform.translatedBy(x: 0, y: -self.message_view_height.constant)
        }) { (finish) in
            self.show_message_view()
        }
    }
    
    func show_pending_friend_view(_ friendInfo: Friend) {
        let imagePath: String! = friendInfo.x_child_sn! + ".jpg"
        message_head.imagePath = imagePath
        message_head.layoutSubviews()
        let tips = String(format:Localizaed("%@\rwants to be your friend"), friendInfo.nickname!)
        message_info.text = tips
        agree_button.isHidden = false
        agree_button.setTitle(Localizaed("Agree"), for: .normal)
        reject_button.isHidden = false
        reject_button.tag = 100
        reject_button.setTitle(Localizaed("Reject"), for: .normal)
    }
    
    func show_finish_pending_friend_view(_ friendInfo: Friend) {
        let imagePath: String! = friendInfo.x_child_sn! + ".jpg"
        message_head.imagePath = imagePath
        message_head.layoutSubviews()
        let tips = String(format:Localizaed("%@\rRejected your request"), friendInfo.nickname!)
        message_info.text = tips
        reject_button.isHidden = false
        reject_button.tag = 200
        reject_button.setTitle(Localizaed("Got it"), for: .normal)
        agree_button.isHidden = true
    }
    
    @IBAction func agree_action(_ sender: Any) {
        if helper.adding_pending_friends.count == 0 {
            return
        }
        let friend = helper.adding_pending_friends.first!
        //Flurry.logEvent("Friend_list_agree_btn_click")
        handle_pending_friend_by_target(helper.agree, x_child_sn: friend.x_child_sn!)
    }
    
    @IBAction func reject_action(_ sender: Any) {
        let button: UIButton = sender as! UIButton
        if button.tag == 100{
            if helper.adding_pending_friends.count == 0 {
                return
            }
            let friend = helper.adding_pending_friends.first!
            //Flurry.logEvent("Friend_list_reject_btn_click")
            handle_pending_friend_by_target(helper.reject, x_child_sn: friend.x_child_sn!)
        }else if button.tag == 200{
            if helper.reject_pending_friends.count == 0 {
                return
            }
            let friend = helper.reject_pending_friends.first!
            handle_pending_friend_by_request(helper.finish, x_child_sn: friend.x_child_sn!)
        }
    }
    
    func set_no_friend_view() {
        FriendsListTableView.isHidden = true
        no_friend_tips_label.isHidden = false
        no_friend_shake_image.isHidden = false
        no_friend_add_friend_btn.isHidden = false
        no_friend_tips_label.text = Localizaed("Oops! You haven’t added any friends yet. Give Gululu a shake with friends nearby, there will be a surprise!")
        set_add_friend_button()
        no_friend_pull_friend_task()
    }
    
    func no_friend_pull_friend_task() {
        if (timer != nil){
            return
        }
        timer = DispatchSource.makeTimerSource(queue: .main)
        timer?.schedule(deadline: .now(), repeating: .seconds(15))
        timer?.setEventHandler {
           self.refresh_request()
        }
        // 启动定时器
        timer?.resume()
    }
    
    func set_add_friend_button() {
        no_friend_add_friend_btn.layer.masksToBounds = true
        no_friend_add_friend_btn.layer.cornerRadius = 25
        no_friend_add_friend_btn.setTitle(Localizaed("Add Friend"), for: .normal)
    }
    
    func set_have_friends_view() {
        if timer != nil{
            timer?.cancel()
            timer = nil
        }
        FriendsListTableView.isHidden = false
        no_friend_tips_label.isHidden = true
        no_friend_shake_image.isHidden = true
        no_friend_add_friend_btn.isHidden = true
        
        let nib = UINib(nibName: "FriendTableCell", bundle: nil)
        FriendsListTableView.register(nib, forCellReuseIdentifier: "friendCell")
        
        FriendsListTableView.delegate = self
        FriendsListTableView.dataSource = self
        FriendsListTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITabelView Datasource
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return helper.friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var friendCell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as? FriendTableCell
        friendCell?.selectionStyle = .none
        if friendCell == nil {
            FriendsListTableView.register(UINib(nibName: "FriendTableCell", bundle: nil), forCellReuseIdentifier: "FriendCell")
            friendCell = FriendsListTableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as? FriendTableCell
            friendCell?.selectionStyle = UITableViewCellSelectionStyle.none
        }
        
        if helper.friendList.count > 0 {
            let friendInfo: Friend = helper.friendList[(indexPath as NSIndexPath).row]
            friendCell?.reloadFriendTableViewCell(friendInfo, index: (indexPath as NSIndexPath).row)
        } else {
            friendCell?.name.text = "Gulülu Inc."
        }
        return friendCell!
    }
    
    // MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SCREEN_HEIGHT / 7.02
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @objc func refresh_request()  {
        pull_friend()
        query_pending_friend()
    }
    
    //alter
    func show_agree_tips() {
        let tips = Localizaed("The friend list will be sync to Gululu after you put it back to dock.")
        BAlterTipView().load_view(tips, direction: 0)
    }
    
    //Net work
    func query_pending_friend() {
        if !GUserConfigUtil.share.checkout_add_frined(){
            return
        }
        helper.query_pending_fiends { (result) in
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.show_message_view()
            }
        }
    }
    
    func handle_pending_friend_by_target(_ permit:String, x_child_sn: String) {
        checkNetIsNeedShowRedSign()
        if !isConnectNet(){
            return
        }
        LoadingView().showLodingInView()
        helper.handle_pending_friend_by_target(permit, request_child_sn: x_child_sn) { (result) in
            DispatchQueue.main.async {
                LoadingView().stopAnimation()
                if result {
                    self.animation_message_hiden()
                    if self.helper.friendList.count != 0{
                        self.set_have_friends_view()
                    }
                    if permit == self.helper.agree{
                        self.show_agree_tips()
                    }
                }else{
                    GHHttpHelper.show_server_error()
                }
            }
        }
    }
    
    func handle_pending_friend_by_request(_ permit:String, x_child_sn: String)  {
        checkNetIsNeedShowRedSign()
        if !isConnectNet(){
            return
        }
        LoadingView().showLodingInView()
        helper.handle_pending_friend_by_request(permit, request_child_sn: x_child_sn) { (result) in
            DispatchQueue.main.async {
                LoadingView().stopAnimation()
                self.animation_message_hiden()
                if result == false{
//                    GHHttpHelper.show_server_error()
                }
            }
        }
    }
    
    func pull_friend() {
        checkNetIsNeedShowRedSign()
        if !isConnectNet(){
            self.set_have_friends_view()
            return
        }
        helper.get_child_friends { (result) in
            DispatchQueue.main.async {
                if self.helper.friendList.count == 0{
                    self.set_no_friend_view()
                }else{
                    self.set_have_friends_view()
                }
            }
        }
    }
}
