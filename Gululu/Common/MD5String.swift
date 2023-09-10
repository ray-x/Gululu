//
//  MD5String.swift
//  Gululu
//
//  Created by baker on 2017/12/8.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

import UIKit

class MD5String: NSObject {

}

//字符串MD5加密

extension String{
    
    func md5() ->String!{
        
        let str = self.cString(using: Encoding.utf8)
        
        let strLen = CUnsignedInt(self.lengthOfBytes(using: Encoding.utf8))
        
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        
        for i in 0 ..< digestLen {
            
            hash.appendFormat("%02x", result[i])
            
        }
        
        result.deinitialize()
        
        return String(format: hash as String)
        
    }
    
}
