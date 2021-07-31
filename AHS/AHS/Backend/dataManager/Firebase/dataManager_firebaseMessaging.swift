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
                        
                        print("subscribed to category id - \(categoryID)");
                        
                        Messaging.messaging().subscribe(toTopic: categoryID);
                        
                    }
                    
                });
                
            });
            
        }
        
    }
    
}
