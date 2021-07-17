//
//  notificationPageViewControllerActions.swift
//  AHS
//
//  Created by Richard Wei on 7/11/21.
//

import Foundation
import UIKit

extension notificationPageViewController{
    
    @objc internal func exit(){
        self.dismiss(animated: true);
    }
    
    @objc internal func refresh(_ refreshControl: UIRefreshControl){
        dataManager.resetNotificationListCache();
        loadNotificationList();
    }
    
    @objc internal func sortBy(){
        print("sort by")
    }
    
    @objc internal func clearAll(){
        print("clear all")
    }
    
}
