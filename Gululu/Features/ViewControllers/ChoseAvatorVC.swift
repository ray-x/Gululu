//
//  ChoseAvatorVC.swift
//  Gululu
//
//  Created by baker on 2018/6/22.
//  Copyright © 2018年 Ray Xu. All rights reserved.
//

import UIKit

class ChoseAvatorVC: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var chose_title: UILabel!
    @IBOutlet weak var avator_collect_view: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chose_title.text = Localizaed("Please choose a profile photo.")
        avator_collect_view.isHidden = true
        
        AvatorHelper.share.getChildAvatorList { (result) in
            DispatchQueue.main.async {
                self.init_avator_collect_view()
            }
        }
        
    }
    
    func init_avator_collect_view() {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:FIT_SCREEN_WIDTH(82),height:FIT_SCREEN_WIDTH(82))
        //列间距,行间距,偏移
        layout.minimumInteritemSpacing = FIT_SCREEN_WIDTH(25)
        layout.minimumLineSpacing = FIT_SCREEN_WIDTH(25)
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        
        avator_collect_view.collectionViewLayout = layout
        avator_collect_view.isHidden = false
        
        avator_collect_view.delegate = self
        avator_collect_view.dataSource = self
        //注册一个cell
        
        avator_collect_view.register(AvatolCell.self, forCellWithReuseIdentifier:"AvatolCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AvatorHelper.share.avatarList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatolCell", for: indexPath) as! AvatolCell
        cell.backgroundColor = .clear
        let avatar = AvatorHelper.share.avatarList[indexPath.row]
        cell.avatorImage?.image_web_url = avatar.url
        cell.avatorImage?.imageView.layoutSubviews()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell : AvatolCell = collectionView.cellForItem(at: indexPath) as! AvatolCell
        AvatorHelper.share.choseAvatar = cell.avatorImage?.imageView.image
        AvatorHelper.share.choseAvatarInfo = AvatorHelper.share.avatarList[indexPath.row]
        _ = navigationController?.popViewController(animated: true)
    }

}
