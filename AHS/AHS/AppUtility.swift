//
//  AppUtility.swift
//  AHS
//
//  Created by Richard Wei.
//
import Foundation
import UIKit

struct AppUtility {

    static let originalWidth = UIScreen.main.bounds.width;
    static let originalHeight = UIScreen.main.bounds.height;
    static let safeAreaInset = UIApplication.shared.windows[0].safeAreaInsets;
    
    static private var isOrientationLocked = false;
    static private var isLockedOrientationLandscape = false;
    
    static public var currentUserInterfaceStyle : UIUserInterfaceStyle = .unspecified; // used for overriding system user interface style, use system style when .unspecified
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
    
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation;
        }
        
        isOrientationLocked = orientation != .all;
        isLockedOrientationLandscape = UIDevice.current.orientation.isLandscape;
    }

    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
   
        self.lockOrientation(orientation);
    
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation();
        
        isLockedOrientationLandscape = rotateOrientation.isLandscape;
    }

    static func getCurrentScreenSize() -> CGSize{
        let isLandscape = isOrientationLocked ? isLockedOrientationLandscape : UIDevice.current.orientation.isLandscape;
        return CGSize(width: (isLandscape ? AppUtility.originalHeight : AppUtility.originalWidth), height: (isLandscape ? AppUtility.originalWidth : AppUtility.originalHeight));
    }
    
    // https://stackoverflow.com/a/26667122/
    static func getTopMostViewController() -> UIViewController?{
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }

            return topController;
        }
        return nil;
    }
    
    static func presentAlertController(_ vc: UIAlertController){
        guard let topVC = getTopMostViewController() else{
            print("Unable to find topmost view controller");
            return;
        }
        
        topVC.present(vc, animated: true);
    }
    
    //
    
    static func setAppNotificationNumber(_ n: Int){
        UIApplication.shared.applicationIconBadgeNumber = n;
    }
    
    static func getAppNotificationNumber() -> Int{
        return UIApplication.shared.applicationIconBadgeNumber;
    }
    
    //
    
    static func getAppVersionString() -> String{
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0";
    }
}
