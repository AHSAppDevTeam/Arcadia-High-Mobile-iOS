//
//  dataManager_notifications.swift
//  AHS
//
//  Created by Richard Wei on 7/10/21.
//

import Foundation
import Firebase
import FirebaseDatabase

struct notificationData{
    var blurb : String = "";
    var categoryID : String = "";
    var notifTimestamp : Int64 = INT64_MAX;
    var title : String = "";
}

extension dataManager{
    
    static public func getNotificationList(completion: @escaping ([String]) -> Void){
        
        setupConnection();
        
        if (internetConnected){
            
            dataRef.child("notifIDs").observeSingleEvent(of: .value, with: { (snapshot) in
                
                var notifIDList : [String] = [];
                
                if (snapshot.exists()){
                    
                    let enumerator = snapshot.children;
                    while let id = enumerator.nextObject() as? DataSnapshot{
                        
                        notifIDList.append(id.value as? String ?? "");

                    }
                    
                }
                
                completion(notifIDList);
                
            });
            
        }
        
    }
    
    static public func getNotificationData(_ id: String, completion: @escaping (notificationData) -> Void){
        
        setupConnection();
        
        if (internetConnected){
            
            dataRef.child("notifs").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if (snapshot.exists()){
                    
                    var notifData : notificationData = notificationData();
                    
                    //
                    
                    let dataDict = snapshot.value as? NSDictionary;
                    
                    notifData.blurb = dataDict?["blurb"] as? String ?? "";
                    notifData.categoryID = dataDict?["categoryID"] as? String ?? "";
                    notifData.notifTimestamp = dataDict?["notifTimestamp"] as? Int64 ?? INT64_MAX;
                    notifData.title = dataDict?["title"] as? String ?? "";
                    
                    //
                    
                    completion(notifData);
                    
                }
                else{
                    print("notifID \(id) does not exist");
                }
                
            });
            
        }
        
    }
    
}


