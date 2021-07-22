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
    
    @objc internal func readNotification(_ button: NotificationButton){
        
        //print("read notification")
        
        for outerview in button.subviews{
            
            if (outerview.tag == -1){
                for innerview in outerview.subviews{
                    
                    if (innerview.tag == 1){
                        
                        if let notificationLabel = innerview as? UILabel{
                            notificationLabel.textColor = BackgroundGrayColor;
                        }
                        else if let categoryColorView = innerview as? UIView{
                            categoryColorView.backgroundColor = BackgroundGrayColor;
                        }
                        
                    }
                    
                }
            }
            
        }
        
    }
    
}
