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
    
    static public func updateEntireMessagingSubscription(){
        
        setupConnection();
        
        if (internetConnected){
            
            getCategoryIDForEach(completion: { (categoryID) in
                            
                getCategoryData(categoryID, completion: { (categorydata) in
                    
                    if (categorydata.visible){
                        
                        updateCategorySubscription(categorydata.categoryID);
                        
                    }
                    else{
                        
                        unsubscribeFromCategory(categorydata.categoryID);
                        
                    }
                    
                });
                
            });
            
        }
        
    }
    
    static private func updateCategorySubscription(_ categoryID: String){
        if (isUserSubscribedToCategory(categoryID)){
                                        
            subscribeToCategory(categoryID);
            
        }
        else{
                                
            unsubscribeFromCategory(categoryID);
            
        }
    }
    
    static private func subscribeToCategory(_ categoryID: String){
        print("subscribed to category id - \(categoryID)");
        
        Messaging.messaging().subscribe(toTopic: categoryID);
    }
    
    static private func unsubscribeFromCategory(_ categoryID: String){                            print("unsubscribed to category id - \(categoryID)");

        Messaging.messaging().unsubscribe(fromTopic: categoryID);
    }
    
    //
    
    static public func isUserSubscribedToCategory(_ categoryID: String) -> Bool{
        
        guard let val = dataManager.preferencesStruct.notificationSubscriptionPreference[categoryID] else{
            dataManager.preferencesStruct.notificationSubscriptionPreference[categoryID] = defaultCategorySubscriptionValue;
            dataManager.updateCategorySubscription(categoryID); // possibly encountered new category
            return defaultCategorySubscriptionValue;
        }
        
        return val;
        
    }
    
    static public func setUserSubscriptionToCategory(_ categoryID: String, _ val: Bool){
        dataManager.preferencesStruct.notificationSubscriptionPreference[categoryID] = val;
        dataManager.updateCategorySubscription(categoryID);
    }
    
    static public func resetUserSubscriptions(){
        dataManager.preferencesStruct.notificationSubscriptionPreference = [:];
        dataManager.updateEntireMessagingSubscription();
    }
    
    static public func isUserSubscribedToAllCategories() -> Bool{
        
        for category in dataManager.preferencesStruct.notificationSubscriptionPreference{
            
            if (!category.value){
                return false;
            }
            
        }
        
        return true;
    }
    
    static public func setAllCategorySubscriptions(_ val: Bool){
        
        for category in dataManager.preferencesStruct.notificationSubscriptionPreference{
            
            setUserSubscriptionToCategory(category.key, val);
            
        }
        
    }
    
}
