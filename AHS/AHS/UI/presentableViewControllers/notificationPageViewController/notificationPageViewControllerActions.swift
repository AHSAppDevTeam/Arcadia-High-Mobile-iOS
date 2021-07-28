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
    
    @objc internal func sortBy(_ button: UIButton){
        //print("sort by")
        
        if (!sortByPopTip.isVisible){
            
            let sortByTableViewWidth = mainScrollView.frame.width * 0.35;
            let sortByTableViewCellHeight = sortByTableViewWidth * 0.22;
            let sortByTableViewHeight = sortByTableViewCellHeight * CGFloat(notificationSortingStruct.numberOfCells());
            
            let sortByTableViewFrame = CGRect(x: 0, y: 0, width: sortByTableViewWidth, height: sortByTableViewHeight);
            let sortByTableView = UITableView(frame: sortByTableViewFrame);
            
            cellHeight = sortByTableViewCellHeight;
            
            sortByTableView.delegate = self;
            sortByTableView.dataSource = self;
            sortByTableView.rowHeight = sortByTableViewCellHeight;
            sortByTableView.isScrollEnabled = false;
            sortByTableView.register(notificationPageSortByCell.self, forCellReuseIdentifier: notificationPageSortByCell.identifier);
            
            //
            
            sortByPopTip.bubbleColor = BackgroundColor;
            //fontSliderPopTip.isRounded = true;
            sortByPopTip.shouldDismissOnTap = false;
            sortByPopTip.shouldDismissOnSwipeOutside = true;
            sortByPopTip.shouldDismissOnTapOutside = true;
            
            sortByPopTip.show(customView: sortByTableView, direction: .down, in: mainScrollView, from: CGRect(x: button.center.x, y: button.frame.maxY, width: 0, height: 0));
            
        }
        else{
            sortByPopTip.hide();
        }
        
    }
    
    @objc internal func clearAll(){
        createConfirmationPrompt(self, "Clear All Notifications", confirmCompletion: { () in
            
            UIImpactFeedbackGenerator(style: .light).impactOccurred();
            
            for view in self.mainScrollView.subviews{
                if view.tag == 1{
                    if let notificationButton = view as? NotificationButton{
                        
                        dataManager.setReadNotification(notificationButton.notificationID);
                        
                    }
                }
            }
            
            self.refresh();
            
        }, declineCompletion: { () in
            
            createConfirmationPrompt(self, "Reset All Notifications?", confirmCompletion: { () in
               
                UIImpactFeedbackGenerator(style: .light).impactOccurred();
                
                dataManager.resetNotificationReadDict();
                
                self.refresh();
                
            });
            
        });
    }
    
    @objc internal func readNotification(_ button: NotificationButton){
        
        //print("read notification")
        
        if (!dataManager.isNotificationRead(button.notificationID)){
            
            UIImpactFeedbackGenerator(style: .light).impactOccurred();
            
            dataManager.setReadNotification(button.notificationID);
            
            updateNotificationView(button);
            
            AppUtility.setAppNotificationNumber(AppUtility.getAppNotificationNumber() - 1);
            
        }
        
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
