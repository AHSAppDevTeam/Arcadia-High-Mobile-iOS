//
//  Classes.swift
//  AHS
//
//  Created by Richard Wei on 3/17/21.
//

import Foundation
import Network
import SystemConfiguration
import UIKit

class mainPageViewController : UIViewController{ // UIViewController for main pages
    public var pageName : String = "";
    public var secondaryPageName : String = "";
    public var viewControllerIconName : String = "";
    
    internal var hasBeenSetup : Bool = false;
}

class homeContentPageViewController : UIViewController{ // UIViewController for homepage content pages
    
    public func getSubviewsMaxY() -> CGFloat{
        var mx : CGFloat = 0;
        for view in self.view.subviews{
            mx = max(mx, view.frame.maxY);
        }
        return mx;
    }
    
}

final public class Reachability {

    class func isConnectedToNetwork() -> Bool {

        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0

        return (isReachable && !needsConnection)

    }
}
