//: Playground - noun: a place where people can play

import Cocoa

struct Child {
    let name: String
    let weight: Int
}

let Jerry = Child(name: "Jerry", weight: 16)
let r = Mirror(reflecting: Jerry)

print("Jerry : \(r.displayStyle!)")

func getFieldValue(_ object:AnyObject, _ name:String) -> Any?
{
    let nameComponents   = name.components(separatedBy: ".")
    
    guard let fieldName  = nameComponents.first
        else { return nil }
    
    let subFieldName     = nameComponents.dropFirst().joined(separator: ".")
    
    for prop in Mirror(reflecting:object).children
    {
        if let name = prop.label, name == fieldName
        {
            if subFieldName == "" { return prop.value }
            if let subObject = prop.value as? AnyObject
            { return getFieldValue(subObject, subFieldName) }
            return nil
        }
    }
    return nil
}


func setFieldValue(_ object:AnyObject, _ name:String, newVal:AnyObject) -> Bool
{
    let nameComponents   = name.components(separatedBy: ".")
    
    guard let fieldName  = nameComponents.first
        else { return false }
    
    let subFieldName     = nameComponents.dropFirst().joined(separator: ".")
    
    for prop in Mirror(reflecting:object).children
    {
        if let name = prop.label, name == fieldName
        {
            //if subFieldName == "" { return prop.value }
            if let subObject = prop.value as? AnyObject
            { return setFieldValue(subObject, subFieldName, newVal: newVal) }
            //return nil
        }
    }
    return true
}


func fieldNames(object:AnyObject, prefix:String = "") -> [String]
{
    var names:[String] = []
    for prop in Mirror(reflecting:object).children
    {
        if let name = prop.label
        {
            let fieldName = prefix + name
            names.append(fieldName)
            if let subObject = prop.value as? AnyObject
            { names = names + fieldNames(object: subObject, prefix:fieldName + ".") }
        }
    }
    return names
}


class ChildClass
{
    var name:String = "ABC"
}

class ContainerClass
{
    var aProperty:Int       = 123
    var anObject:ChildClass = ChildClass()
}

let foo = ContainerClass()
fieldNames(object: foo)                        // ["aProperty", "anObject", "anObject.subProperty"]
getFieldValue(foo,"aProperty")            // 123
getFieldValue(foo,"anObject.name") // "ABC"


//extension NSObject{
//    
//    public func jsonToObject<T>(dics:AnyObject?)->T!{
//        if dics == nil {
//            return nil
//        }
//        var dic:AnyObject!
//        if dics is NSArray{
//            dic = dics!.lastObject
//        }
//        else{
//            dic = dics
//        }
//        
//        //get mirror
//        let obj:AnyObject = self.dynamicType()
//        let properties:Mirror! = Mirror(reflecting: obj)
//        
//        if dic != nil{
//            if let b = AnyBidirectionalCollection(properties.children) {
//                for i in b.startIndex..<b.endIndex {
//                    let pro = b[i]
//                    let key = pro.0
//                    let type = pro.1
//                    
//                    switch type {
//                    case is Int,is Int64,is NSInteger:
//                        let value = dic?.objectForKey(key!)?.integerValue
//                        if value != nil{
//                            obj.setValue(value, forKey: key!)
//                        }
//                        break
//                        
//                    case is Float,is Double,is Bool,is NSNumber:
//                        let value: AnyObject! = dic?.objectForKey(key!)
//                        if value != nil{
//                            obj.setValue(value, forKey: key!)
//                        }
//                        break
//                        
//                    case is String:
//                        let value: AnyObject! = dic?.objectForKey(key!)
//                        if value != nil{
//                            obj.setValue(value.description, forKey: key!)
//                        }
//                        break
//                        
//                    case is Array<String>:
//                        if let nsarray = dic?.objectForKey(key!) as? NSArray {
//                            var array:Array<String> = []
//                            for el in nsarray {
//                                if let typedElement = el as? String {
//                                    array.append(typedElement)
//                                }
//                            }
//                            obj.setValue(array, forKey: key!)
//                        }
//                        break
//                        
//                        
//                    case is Array<Int>:   //arr int
//                        if let nsarray = dic?.objectForKey(key!) as? NSArray {
//                            var array:Array<Int> = []
//                            for el in nsarray {
//                                if let typedElement = el as? Int {
//                                    array.append(typedElement)
//                                }
//                            }
//                            obj.setValue(array, forKey: key!)
//                        }
//                        break
//                        
//                    default:     //unknow
//                        let otherType = Mirror(reflecting: type).subjectType
//                        
//                        switch otherType{
//                        case is Optional<String>.Type,is Optional<NSNumber>.Type,is Optional<NSInteger>.Type,is Optional<Array<String>>.Type,is Optional<Array<Int>>.Type:
//                            obj.setValue(dic?.objectForKey(key!), forKey: key!)
//                            break
//                        default:
//                            print("type undefined")
//                        //need to throw a error in other case
//                        }
//                    }
//                }
//            }
//        }
//        else{
//            return nil
//        }
//        return (obj as! T)
//    }
//    
//    public func jsonToObjectList(data:AnyObject?)->Array<AnyObject>{
//        if data == nil{
//            return []
//        }
//        
//        var objs:Array<AnyObject> = []
//        if let dics = data as? NSArray{
//            dics.forEach({ (dic) in
//                objs.append(jsonToObject(dic as! NSObject))
//            })
//        }
//        return objs
//    }
//    
//    
//    private  func getClassName(name:NSString)->NSString!{
//        var range = name.rangeOfString("<.*>", options: NSStringCompareOptions.RegularExpressionSearch)
//        if range.location != NSNotFound{
//            range.location += 1
//            range.length -= 2
//            return getClassName(name.substringWithRange(range))
//        }
//        else{
//            return name
//        }
//    }
//}


//infix operator => {
//    associativity left
//    precedence 160
//}
//
//func => <T: NSObject>(lhs: NSData, rhs: T.Type) -> T? {
//    let model: T? = lhs.jsonToObject(rhs)
//    return model
//}
//
//func =><T: NSObject>(lhs: AnyObject, rhs: T.Type) -> T? {
//    guard let dict = lhs as? [String: AnyObject] else {
//        print("Can't convert \(lhs) to [String: AnyObject].")
//        return nil
//    }
//    
//    let model: T = dict.jsonToObject(rhs)
//    return model
//}
//
//func =><T: NSObject>(lhs: T, rhs: NSData.Type) -> NSData? {
//    return lhs.jsonToObject(rhs)
//}




let nameMapper = ["rawWeight":"weight"]

extension Dictionary {
    func convertToModel<T: NSObject>() -> T {
        let model = T()
        let mirror = Mirror(reflecting: model)
        
        mirror.children.forEach {
            if let key = $0.0 as? Key, let value = self[key] {

                model.setValue(value as? AnyObject, forKey: $0.0!)
            }else {
                let key = $0.0 as? Key
                let keyName = key as! String
                if let k2 = nameMapper[keyName]! as? String {
                    print(k2)
                    if let value = self[(k2 as? Key)!] {
                        model.setValue(value as? AnyObject, forKey: $0.0!)
                    }
                    
                }
            }
        }
        
        return model
    }
}

extension NSObject {
    func convertToDictinary() -> [String: AnyObject] {
        var dict = [String: AnyObject]()
        let mirror = Mirror(reflecting: self)
        
        mirror.children.forEach {
            dict[$0.0!] = $0.1 as? AnyObject
        }
        
        return dict
    }
    
    func convertToData() -> NSData? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self.convertToDictinary(), options: JSONSerialization.WritingOptions(rawValue: 0))
            return data as NSData?
        } catch {
            print("JSONSerializationError: \(error)")
            return nil
        }
    }
}

infix operator => {
    associativity left
    precedence 160
}


func =><T: NSObject>(lhs: NSData, rhs: T.Type) -> T? {
    let model: T? = lhs.convertToModel()
    return model
}

extension NSData {
    func convertToModel<T: NSObject>() -> T? {
        do {
            let json = try JSONSerialization.jsonObject(with: self as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
//            let model = json => T.self
            return json as? T
        } catch {
            print("JSONSerializationError: \(error)")
            return nil
        }
    }
}


func =><T: NSObject>(lhs: AnyObject, rhs: T.Type) -> T? {
    guard let dict = lhs as? [String: AnyObject] else {
        print("Can't convert \(lhs) to [String: AnyObject].")
        return nil
    }
    
    let model: T = dict.convertToModel()
    return model
}

class userInfo3:NSObject {
    var name:String
    var rawWeight:Int
    required override init(){
        name=""
        rawWeight=0
        super.init()
    }
}


let childJson2 = "{\"name\": \"Jame\",\"weight\":32}"
let data2 = childJson2.data(using: String.Encoding.utf8, allowLossyConversion: false)!

func =><T: NSObject>(lhs: T, rhs: NSData.Type) -> NSData? {
    return lhs.convertToData()
}

//let model = data2 => userInfo3.self
//print(model!.name)
//print(model!.name)

let mod="aaa"
let modObj = mod as NSObject
print(modObj)



