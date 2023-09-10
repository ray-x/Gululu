//
//  SettingHelper.swift
//  Gululu
//
//  Created by Baker on 17/5/10.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

struct InfoCell {
    var image : UIImage
    var name : String
    init (image:UIImage,name:String){
        self.image = image
        self.name = name
    }
}

class SettingHelper: NSObject {

    static let share = SettingHelper()
    
    var itemData : [InfoCell] = [InfoCell]()

    func setItemDatasource() {
        let item1 = InfoCell(image: UIImage(named: "book")!,name:Localizaed("School Mode"))
        let item2 = InfoCell(image: UIImage(named: "bedtime")!,name:Localizaed("Bedtime"))
        let item3 = InfoCell(image: UIImage(named: "wifiConnection")!,name:Localizaed("Bottle Settings"))
        let item4 = InfoCell(image: UIImage(named: "parent")!,name:Localizaed("Your Account"))
        let item5 = InfoCell(image: UIImage(named: "i")!,name:Localizaed("About"))
        itemData = [item3,item1,item2,item4,item5]
    }
}
