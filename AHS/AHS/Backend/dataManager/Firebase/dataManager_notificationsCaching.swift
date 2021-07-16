//
//  dataManager_notificationsCaching.swift
//  AHS
//
//  Created by Richard Wei on 7/15/21.
//

import Foundation
import Firebase
import FirebaseDatabase

extension dataManager{
    
    static public func loadNotificationList(_ notificationIDs: [String], completion: @escaping () -> Void){
        
        DispatchQueue.global(qos: .background).async {
            
            let dispatchGroup = DispatchGroup();
            
            for notificationID in notificationIDs{
                
                dispatchGroup.enter();
                
                cacheNotificationData(notificationID, completion: { (_) in
                    
                    dispatchGroup.leave();
                    
                });
                
            }
            
            dispatchGroup.wait();
            
            DispatchQueue.main.async {
                completion();
            }
            
        }
        
    }
    
    static public func resetNotificationListCache(){
        notificationCache = [:];
    }
    
    static public func getCachedNotificationData(_ notificationID: String) -> notificationData{
        return notificationCache[notificationID] ?? notificationData();
    }
    
    //
    
    static private func cacheNotificationData(_ id: String, completion: @escaping (notificationData) -> Void){
        
        dataManager.getNotificationData(id, completion: { (notificationdata) in
            
            self.notificationCache[id] = notificationdata;
            
            completion(notificationdata);
            
        });
        
    }
    
}
