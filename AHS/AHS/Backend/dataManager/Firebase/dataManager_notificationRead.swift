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
        dataManager.preferencesStruct.notificationsReadDict[notificationID] = true;
    }
    
    static public func isNotificationRead(_ notificationID: String) -> Bool{
        return dataManager.preferencesStruct.notificationsReadDict[notificationID] ?? false;
    }
    
    static public func resetNotificationReadDict(){
        dataManager.preferencesStruct.notificationsReadDict = [:];
    }
}
