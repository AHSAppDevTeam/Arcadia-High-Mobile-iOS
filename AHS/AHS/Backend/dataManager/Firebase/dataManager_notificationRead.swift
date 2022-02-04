//
//  dataManager_notificationRead.swift
//  AHS
//
//  Created by Richard Wei on 7/24/21.
//

import Foundation
import UIKit

extension dataManager{
    
    static public func setReadNotification(_ notificationID: String){
        notificationReadDispatchQueue.async {
            dataManager.preferencesStruct.notificationsReadDict[notificationID] = true;
        }
    }
    
    static public func isNotificationRead(_ notificationID: String) -> Bool{
        notificationReadDispatchQueue.sync {
            return dataManager.preferencesStruct.notificationsReadDict[notificationID] ?? false;
        }
    }
    
    static public func resetNotificationReadDict(){
        notificationReadDispatchQueue.sync {
            dataManager.preferencesStruct.notificationsReadDict = [:];
        }
    }
}
