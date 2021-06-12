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
            isPresentingPopup = true;
            let popup = UIAlertController(title: "No Internet Connection", message: "No content was loaded", preferredStyle: .alert);
            popup.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: homePageEndRefreshing), object: nil);
                popup.removeFromParent();
                isPresentingPopup = false;
            }));
            SceneDelegate.window?.rootViewController?.present(popup, animated: true, completion: nil);
        }
    }
    
}
