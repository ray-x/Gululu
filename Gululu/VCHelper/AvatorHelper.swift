//
//  AvatorHelper.swift
//  Gululu
//
//  Created by Baker on 17/8/17.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

class AvatorHelper: NSObject {
    
    struct AvatarInfo {
        var url: String
        var crc: String
        var id: String
    }
    
    static let share = AvatorHelper()
    
    var avatarList = [AvatarInfo]()
    var choseAvatar: UIImage?
    var choseAvatarInfo: AvatarInfo?
    
    func getChildAvatorList(_ cloudCallback:@escaping (Bool)->Void) {
        let requset = GUHttpRequest()
        requset.setRequestConfig(.get, url: getAvatarListUrl())
        requset.handleRequset(callback: { result in
            if result.boolValue{
                let avatarJsonArr = result.value!["avatars"]
                self.avatarList = self.handleAvatorInfo(avatarJsonArr as! [Dictionary<String, Any>])
            }
            cloudCallback(true)
        })
    }
    
    func handleAvatorInfo(_ arrayDic: [Dictionary<String, Any>]) -> [AvatarInfo] {
        var avatars = [AvatarInfo]()

        if(arrayDic.count == 0)
        {
            return avatars
        }
        for i in 0...arrayDic.count-1 {
            let dic = arrayDic[i]
            let avatar = AvatarInfo(url:dic["url"] as! String, crc: dic["crc"] as! String, id: dic["id"] as! String)
            avatars.append(avatar)
        }
        return avatars
    }
    
    func getPhotoWithURL (_ childSN_URL:(String?,String?)) {
        var session = URLSession.shared
        let confug = URLSessionConfiguration.ephemeral
        session = URLSession(configuration: confug)
        let url = URL(string: childSN_URL.1!)
        
        session.dataTask(with: url!, completionHandler: { (data, response, error) in
            if let _ = error {
                print("get url data error")
            } else {
                if data?.count<200 {
                    print(url ?? "nourl")
                }
                let image=UIImage(data:data!)
                if image != nil {
                    self.saveImage(image!, childSN: childSN_URL.0!)
                }else{
                    print("data is not image")
                }
            }
        })
        .resume()
    }
    
    func saveImage(_ image:UIImage, childSN:String) {
        let documentsURL = getImageFromDocumentPathURLWithID(childSN)
        writeDocumetFormPath(documentsURL.path, andImage: image)
    }
    
    /**
     Get Child Profile Info From Server
     */
    func getChildProfileFromServer(_ _childID:String? = nil, uiCallback:((Result<String>)->Void )? = nil) {
        let requets = GUHttpRequest()
        requets.setRequestConfig(.get,url:avatarUrl)
        requets.header["x_child_sn"] = activeChildID
        requets.handleRequset(callback: { result in
            let profile=result.value?["profile"] as? [String:AnyObject]
            if profile != nil{
                let photoes=profile!["files"] as? [[String:AnyObject]]
                if photoes != nil {
                    for photo in photoes! {
                        if photo["size"] as! Int == 320  {
                            self.getPhotoWithURL((_childID, photo["url"] as? String))
                            uiCallback!(.Success(""))
                        }
                    }
                } else {
                    uiCallback!(.Error(NSError(domain: "no files", code: 0, userInfo: nil)))
                }
            }
            if uiCallback != nil {
                uiCallback!(.Error(NSError(domain: "no profile", code: 0, userInfo: nil)))
            }
        })
    }

    func childChoseAvatorPushService(_ uiCallback:@escaping (Result<String
        >)->Void)  {
        guard choseAvatarInfo?.id != nil else {
            uiCallback(.Error(NSError(domain: "CloudComm", code: -1, userInfo: ["choseAvatarInfo":"id doesn't exist"] )))
            return
        }
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filename = activeChildID + "_back.jpg"
        let fileURL = documentsURL.appendingPathComponent(filename)
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: fileURL.path) {
            
            let requets = GUHttpRequest()
            requets.body["avatar_id"] = choseAvatarInfo?.id

            requets.setRequestConfig(.post, url: postChildAvatarUrl())
            requets.handleRequset(callback: { result in
                switch result {
                case .Error(let error):
                    uiCallback(.Error(error))
                case .Success(_):
                    self.choseAvatar = nil
                    self.choseAvatarInfo = nil
                    let newImageName = activeChildID+".jpg"
                    let newURL = documentsURL.appendingPathComponent(newImageName)
                    do {try fileManager.removeItem(at: newURL)} catch _ {print("file remove error") }
                    do {try fileManager.moveItem(at: fileURL, to: newURL)}catch _ {print("file save error") }
                    uiCallback(.Success(""))
                }
            })
        } else {
            uiCallback(.Error(NSError(domain: "CloudComm", code: -1, userInfo: ["message":"file doesn't exist"] )))
        }
    }

    func childChoseAvatorPushService(_ childName:String, childID:String, uiCallback:@escaping (Result<String
        >)->Void) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filename = childName + "_back.jpg"
        let fileURL = documentsURL.appendingPathComponent(filename)
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: fileURL.path) {
            //self.uInfo.children[self.uInfo.childID!]?.avator = filename
            let profileImage = UIImage(contentsOfFile: fileURL.path)!
            //            let newProfile = scaleImageSize(profileImage)
            let jpgImageData = UIImageJPEGRepresentation(profileImage, 0.8)
            let base64String = jpgImageData!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))	// encode the image

            let requets = GUHttpRequest()
            requets.setRequestConfig(.post,url:avatarUrl)
            requets.body["x_child_sn"] = activeChildID
            requets.body["image"] = base64String
            requets.handleRequset(callback: { result in
                switch result {
                case .Error(let error):
                    uiCallback(.Error(error))
                case .Success(_):
                    let newImageName = activeChildID+".jpg"
                    let newURL = documentsURL.appendingPathComponent(newImageName)
                    do {try fileManager.removeItem(at: newURL)} catch _ {print("file remove error") }
                    do {try fileManager.moveItem(at: fileURL, to: newURL)}catch _ {print("file save error") }
                    uiCallback(.Success(""))
                }
            })
        } else {
            uiCallback(.Error(NSError(domain: "CloudComm", code: -1, userInfo: ["message":"file doesn't exist"] )))
        }
    }
    
    func getDocumentPath() -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsURL
    }
    
    func getImageFromDocumentPathURLWithID(_ imageID:String) -> URL {
        
        let imagePath : String = String(format: "%@.jpg", imageID)
        
        let fileURL = getDocumentPath().appendingPathComponent(imagePath)
        
        return fileURL
    }
    
    func getBackImageInDocumentPathURLWithID(_ imageID:String) -> URL {
        
        let imagePath : String = String(format: "%@_back.jpg", imageID)
        
        let fileURL = getDocumentPath().appendingPathComponent(imagePath)
        
        return fileURL
    }
    
    func removeAvatorImageFromLocal(_ fileUrl:URL) -> Void {
        
        let defauleManager : FileManager = FileManager.default
        
        do {
            try defauleManager.removeItem(atPath: fileUrl.path as String)
            
        } catch {
            
            print("remote iamge error")
        }
    }
    
    func writeDocumetFormPath(_ imagePath:String, andImage:UIImage) -> Void {
        
        let jpgImageData = UIImageJPEGRepresentation(andImage, 0.9)
        
        try? jpgImageData?.write(to: URL(fileURLWithPath: imagePath), options: [.atomic])
    }
    
    func isAvatorFileExist(_ imagePath:URL) -> Bool {
        
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: imagePath.path){
            return true
        }else{
            return false
        }
    }
    
    func convertAddChildAvatorImageName(_ oldID:String,newID:String) -> Void {
        
        let backURL = getBackImageInDocumentPathURLWithID(oldID)
        if isAvatorFileExist(backURL) {
            let profileImage : UIImage = UIImage(contentsOfFile: backURL.path)!
            writeDocumetFormPath(getBackImageInDocumentPathURLWithID(newID).path, andImage: profileImage)
            removeAvatorImageFromLocal(backURL)
        }
    }
    
    func removeChildAvator(_ child_id: String)  {
        let backURL = getImageFromDocumentPathURLWithID(child_id)
        if isAvatorFileExist(backURL) {
            removeAvatorImageFromLocal(backURL)
        }
    }
    
    func dataimage(_ data:Data?) -> UIImage{
        if data != nil{
            let image=UIImage(data:data!)
            return image!
        }
        return UIImage(named: "6")!
    }

    
}
