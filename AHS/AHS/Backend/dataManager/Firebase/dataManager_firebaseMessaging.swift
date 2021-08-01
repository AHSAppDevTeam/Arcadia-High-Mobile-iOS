//
//  dataManager_firebaseMessaging.swift
//  AHS
//
//  Created by Richard Wei on 7/30/21.
//

import Foundation
import Firebase
import FirebaseMessaging

extension dataManager{
    
    static public func updateFirebaseMessagingSubscription(){
        
        setupConnection();
        
        if (internetConnected){
            
            getCategoryIDList(completion: { (categoryID) in
                            
                getCategoryData(categoryID, completion: { (categorydata) in
                    
                    if (categorydata.visible){
                        
                        if (isUserSubscribedToCategory(categoryID)){
                            
                            print("subscribed to category id - \(categoryID)");
                            
                            Messaging.messaging().subscribe(toTopic: categoryID);
                            
                        }
                        else{
                            
                            print("unsubscribed to category id - \(categoryID)");
                            
                            Messaging.messaging().unsubscribe(fromTopic: categoryID);
                            
                        }
                        
                    }
                    
                });
                
            });
            
        }
        
    }
    
    //
    
    static public func isUserSubscribedToCategory(_ categoryID: String) -> Bool{
        
        guard let val = dataManager.preferencesStruct.notificationSubscriptionPreference[categoryID] else{
            dataManager.preferencesStruct.notificationSubscriptionPreference[categoryID] = defaultCategorySubscriptionValue;
            return defaultCategorySubscriptionValue;
        }
        
        return val;
        
    }
    
    static public func setUserSubscriptionToCategory(_ categoryID: String, _ val: Bool){
        dataManager.preferencesStruct.notificationSubscriptionPreference[categoryID] = val;
    }
    
}
