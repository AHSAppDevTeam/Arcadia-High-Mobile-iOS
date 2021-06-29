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
import GameplayKit

// https://stackoverflow.com/a/26292829
class UIButtonScrollView : UIScrollView{
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view.isKind(of: UIButton.self) {
            return true
        }
        return super.touchesShouldCancel(in: view)
    }
}

class mainPageViewController : UIViewController{ // UIViewController for main pages
    public var pageName : String = "";
    public var secondaryPageName : String = "";
    public var viewControllerIconName : String = "";
    
    internal var hasBeenSetup : Bool = false;
}

class homeContentPageViewController : UIViewController{ // UIViewController for homepage content pages
    
    internal var nextContentY : CGFloat = 0;
    
    public func getSubviewsMaxY() -> CGFloat{
        var mx : CGFloat = 0;
        for view in self.view.subviews{
            mx = max(mx, view.frame.maxY);
        }
        return max(mx, nextContentY);
    }
    
    internal func updateParentHeightConstraint(){
        guard let parentVC = self.parent as? homePageViewController else{
            return;
        }
        parentVC.contentViewHeightAnchor.constant = self.getSubviewsMaxY();
    }
}

class presentableViewController : UIViewController{
    
    internal var transitionDelegateVar : transitionDelegate!;
    
    internal var panGestureRecognizer = UIPanGestureRecognizer();
    
    internal func setupPanGesture(){
        panGestureRecognizer.addTarget(self, action: #selector(self.handlePan));
        self.view.addGestureRecognizer(panGestureRecognizer);
    }
    
    @objc private func handlePan(_ panGestureRecognizer: UIPanGestureRecognizer){
        popTransition.handlePan(panGestureRecognizer, fromViewController: self);
    }
}

class htmlFunctions{
    static public func parseHTML(_ s: String, _ font: UIFont) -> NSMutableAttributedString{
        let htmlData = NSString(string: s).data(using: String.Encoding.unicode.rawValue);
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
                        NSAttributedString.DocumentType.html];
        do{
            let t = try NSMutableAttributedString(data: htmlData ?? Data(), options: options, documentAttributes: nil);
            t.addAttribute(NSAttributedString.Key.font, value: font as Any, range: NSMakeRange(0, t.length));
            return t;
        }
        catch let error{
            print(error);
            return NSMutableAttributedString(string: s);
        }
    }
}

class ArticleButton : UIButton{
    var articleID : String = "";
}

class CategoryButton : UIButton{
    var categoryID : String = "";
    var categoryAccentColor : UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1);
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

final class Color: UIColor, Codable { // https://stackoverflow.com/a/53712187
    convenience init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let hexString = try container.decode(String.self)
        self.init(hex: hexString)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer();
        try container.encode(self.getHex());
    }
}

