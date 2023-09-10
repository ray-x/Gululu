
import Foundation
import SystemConfiguration


let NetworkStatusChangedNotification = "NetworkStatusChangedNotification"

enum NetworkType: CustomStringConvertible {
    case wwan
    case wiFi
    
    var description: String {
        switch self {
        case .wwan: return "WWAN"
        case .wiFi: return "WiFi"
        }
    }
}

enum NetworkStatus: CustomStringConvertible  {
    case offline
    case online(NetworkType)
    case unknown
    
    var description: String {
        switch self {
        case .offline: return "Offline"
        case .online(let type): return "Online (\(type))"
        case .unknown: return "Unknown"
        }
    }
}

open class NetworkStatusNotifier {
    
    func connectionStatus() -> NetworkStatus {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteNetwork = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .unknown
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteNetwork, &flags) {
            return .unknown
        }
        return NetworkStatus(NetworkFlags: flags)
    }
    
    
    func monitorNetworkChanges() {
        let host = "www.baidu.com"
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        let Network = SCNetworkReachabilityCreateWithName(nil, host)!
        
        SCNetworkReachabilitySetCallback(Network, { (_, flags, _) in
            let status = NetworkStatus(NetworkFlags: flags)
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: NetworkStatusChangedNotification),
                object: nil,
                userInfo: ["Status": status.description])
            
            }, &context)
        
        SCNetworkReachabilityScheduleWithRunLoop(Network, CFRunLoopGetMain(), CFRunLoopMode.commonModes.rawValue)
    }
    
}

extension NetworkStatus {
    fileprivate init(NetworkFlags flags: SCNetworkReachabilityFlags) {
        let connectionRequired = flags.contains(.connectionRequired)
        let isReachable = flags.contains(.reachable)
        let isWWAN = flags.contains(.isWWAN)
        
        if !connectionRequired && isReachable {
            if isWWAN {
                self = .online(.wwan)
            } else {
                self = .online(.wiFi)
            }
        } else {
            self =  .offline
        }
    }
}
