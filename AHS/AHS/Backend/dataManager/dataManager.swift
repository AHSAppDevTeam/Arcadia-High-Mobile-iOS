//
//  dataManager.swift
//  AHS
//
//  Created by Richard Wei on 3/17/21.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseFunctions

class dataManager{
    static internal var dataRef : DatabaseReference!;
    static internal var dataFunc = Functions.functions();
    
    static public var internetConnected = false;
    
    static internal var categoryLookupMap : [String : categoryData] = [:];
    
    static internal var articleSnippetArray : [articleSnippetData] = [];
    static internal let articleSnippetArrayDispatchQueue = DispatchQueue(label: "articleSnippetArrayQueue");
    
    static internal var isPresentingPopup = false;
    
    static internal let preferencesKey = "preferencesKey";
    static internal var preferencesStruct = appUserPreferences();
    
    static internal let jsonEncoder = JSONEncoder();
    static internal let jsonDecoder = JSONDecoder();
    
    static internal var bulletinArticleCache : [String : baseArticleData] = [:];
    
    static internal var notificationCache : [String : notificationData] = [:];
    
    //
    
    static public func setupConnection(){
        if (Reachability.isConnectedToNetwork()){
            internetConnected = true;
            Database.database().goOnline();
            dataRef = Database.database().reference();
        }
        else{
            internetConnected = false;
            Database.database().goOffline();
            noInternetPopup();
        }
    }
    
    static private func noInternetPopup(){
        
        if (!isPresentingPopup){
            
            let popup = UIAlertController(title: "No Internet Connection", message: "No content was loaded", preferredStyle: .alert);
            popup.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: endDataManagerRefreshing), object: nil);
                popup.removeFromParent();
                isPresentingPopup = false;
            }));
            
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

            if var topController = keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }

                isPresentingPopup = true;
                
                topController.present(popup, animated: true, completion: nil);
            }
        
        }
    }
    
    static public func getIsConnectedToInternet() -> Bool{
        setupConnection();
        return internetConnected;
    }
    
    static public func articleTimestampComp(_ aT: Int64, _ bT: Int64) -> Bool{
        let currTime = timeManager.getCurrentEpoch();
        if (aT > currTime && bT > currTime){
            return aT < bT;
        }
        else{
            return aT > bT;
        }
    }
    
}
