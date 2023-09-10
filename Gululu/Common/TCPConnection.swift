//
//  TCPConnection.swift
//  Gululu
//
//  Created by Ray Xu on 18/11/2015.
//  Copyright © 2015 Ray Xu. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration.CaptiveNetwork


open class TCPConnection: NSObject, StreamDelegate {
    var serverAddress = "192.168.21.1"
    //var serverAddress = "192.168.1.5"
    var serverPort = 8080
    var needWait=true
    var receivePacket=false
    fileprivate var inputStream: InputStream?
    fileprivate var outputStream: OutputStream?
    var statusComplete = false
    
    var msgArray = NSMutableArray()
    var msgIndex: Int = 0
    
//    open func  getSSID()->String?{
//        var currentSSID=""
//        let interface=CNCopySupportedInterfaces()
//        if interface != nil{
//            for i in 0..<CFArrayGetCount(interface)
//            {
//                let interfaceName:UnsafeRawPointer = CFArrayGetValueAtIndex(interface, i)
//                let rec=unsafeBitCast(interfaceName, to: AnyObject.self)
//                let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString)
//                if unsafeInterfaceData != nil {
//                    let interfaceData = unsafeInterfaceData! as NSDictionary
//                    currentSSID = interfaceData["SSID"] as! String
//                }
//            }
//        }
//        return currentSSID
//    }
    
    open func getInterfaces() -> String {
        var currentSSID=""

        guard let unwrappedCFArrayInterfaces = CNCopySupportedInterfaces() else {
            print("this must be a simulator, no interfaces found")
            return ""
        }
        guard let swiftInterfaces = (unwrappedCFArrayInterfaces as NSArray) as? [String] else {
            print("System error: did not come back as array of Strings")
            return ""
        }
        for interface in swiftInterfaces {
            print("Looking up SSID info for \(interface)") // en0
            guard let unwrappedCFDictionaryForInterface = CNCopyCurrentNetworkInfo(interface as CFString) else {
                print("System error: \(interface) has no information")
                return ""
            }
            guard let SSIDDict = (unwrappedCFDictionaryForInterface as NSDictionary) as? [String: AnyObject] else {
                print("System error: interface information is not a string-keyed dictionary")
                return ""
            }
//            for d in SSIDDict.keys {
//                print("\(d): \(SSIDDict[d]!)")
//            }
            currentSSID = SSIDDict["SSID"] as! String
        }
        return currentSSID
    }
    
    
    // Return IP address of WiFi interface (en0) as a String, or `nil`
    func getWiFiAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            
            // For each interface ...
            var ptr = ifaddr
            while ptr != nil {
                let interface = ptr?.pointee
                
                // Check for IPv4 or IPv6 interface:
                let addrFamily = interface?.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    
                    // Check interface name:
                    if let name = String(validatingUTF8: (interface?.ifa_name)!) , name == "en0" {
                        
                        // Convert interface address to a human readable string:
                        var addr = interface?.ifa_addr.pointee
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(&addr!, socklen_t((interface?.ifa_addr.pointee.sa_len)!),
                            &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
                ptr = ptr?.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        
        return address
    }
    
    open func connect(_ ip:String, messageArray: NSMutableArray)
    {
        if ip.count > 0
        {
            serverAddress = ip
        }
        
        msgArray = messageArray
        
        Stream.getStreamsToHost(withName: serverAddress, port: serverPort, inputStream: &inputStream, outputStream: &outputStream)

        self.outputStream!.delegate = self
        outputStream!.open()

        inputStream!.delegate = self
        inputStream!.open()
        
        let sharedWorkQueue = DispatchQueue(label: "socketQueue", attributes: [])
        CFWriteStreamSetDispatchQueue(outputStream, sharedWorkQueue)
        CFReadStreamSetDispatchQueue(inputStream, sharedWorkQueue)
    }
    
    func sendMessage() {
        if outputStream!.hasSpaceAvailable {
            if msgIndex < msgArray.count {
                let message = msgArray.object(at: msgIndex) as! String
                
                if (message.range(of: "pwd") != nil) {
                    let passwordLength: Int = message.count - 4
                    BH_Log("Password Length = \(passwordLength)", logLevel: .pair)
                } else {
                    BH_Log(message, logLevel: .pair)
                }
                
                let pairMsg: String = message + "\r\n"
                let data: Data = pairMsg.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                outputStream!.write((data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), maxLength: data.count)
            }
        }
    }
    
    open func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case Stream.Event.openCompleted:
            print("NSStreamEvent.OpenCompleted \(aStream.description)")
            statusComplete = false
            break
        case Stream.Event.hasBytesAvailable:
            print("NSStreamEvent.HasBytesAvailable \(aStream.description)")
            if aStream == inputStream
            {
                if inputStream  != nil
                {
                    while (inputStream!.hasBytesAvailable)
                    {
                        let bufferSize = 1024
                        var buffer = Array<UInt8>(repeating: 0, count: bufferSize)
                        let bytesRead: Int = inputStream!.read(&buffer, maxLength: bufferSize)
                        
                        if bytesRead > 0
                        {
                            let inputData = Data(bytes: UnsafePointer<UInt8>(buffer), count: bytesRead)
                            let recvStr = NSString(data: inputData, encoding: String.Encoding.utf8.rawValue)
                            
                            BH_Log(String(recvStr!), logLevel: .pair)
                            
                            msgIndex = msgIndex + 1
                            sendMessage()
                        }
                    }
                }
            }
            break
        case Stream.Event.hasSpaceAvailable:
            print("NSStreamEvent.HasSpaceAvailable \(aStream.description)")
            break
        case Stream.Event.endEncountered:
            print("NSStreamEvent.EndEncountered \(aStream.description)")
            statusComplete = true
            break
        case Stream.Event():
            print("NSStreamEvent.None \(aStream.description)")
            break
        case Stream.Event.errorOccurred:
            print("NSStreamEvent.ErrorOccurred \(aStream.description)")
            break
        default:
            print("# something weird happend")
            break
        }
    }
    
    func wait() {
        var i=0
        while i<2000 || needWait{
            //println("waiting")
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
            Foundation.Thread.sleep(forTimeInterval: 0.1)
            i += 1
            
        }
        if needWait==true
        {
            needWait=false
        }
    }
    
    func close()
    {
        if inputStream != nil
        {
            inputStream?.delegate = nil
            CFReadStreamSetDispatchQueue(inputStream, nil)
            inputStream?.close()
            inputStream = nil
        }
        
        if outputStream != nil
        {
            outputStream?.delegate = nil
            CFWriteStreamSetDispatchQueue(outputStream, nil)
            outputStream?.close()
            outputStream = nil
        }
    }
    
    static let share=TCPConnection()
    
    override init(){
        super.init()
    }
    
}
