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
    
    @objc internal func refresh(){
        dataManager.resetNotificationListCache();
        loadNotificationList();
    }
    
    @objc internal func sortBy(){
        print("sort by")
    }
    
    @objc internal func clearAll(){
        
        
        for view in mainScrollView.subviews{
            if view.tag == 1{
                
                guard let notificationButton = view as? NotificationButton else{
                    continue;
                }
                
                dataManager.setReadNotification(notificationButton.notificationID);
                
            }
        }
        
        self.refresh();
    }
    
    @objc internal func readNotification(_ button: NotificationButton){
        
        //print("read notification")
        
        dataManager.setReadNotification(button.notificationID);
        
        updateNotificationView(button);
        
    }
    
    private func updateNotificationView(_ button: NotificationButton){
        
        for view in button.subviews{
            if view.tag == 1{
                view.removeFromSuperview();
            }
        }
        
        self.renderNotification(button, mainScrollView.frame.width - 2*horizontalPadding, dataManager.getCachedNotificationData(button.notificationID));
        
    }
    
}
