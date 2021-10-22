//
//  profilePageActions.swift
//  AHS
//
//  Created by Richard Wei on 8/1/21.
//

import Foundation
import UIKit

extension profilePageViewController{
    
    @objc internal func refresh(){
        self.renderIDCard();
        self.loadSchedule();
        self.refreshControl.endRefreshing();
    }
    
    @objc internal func resetContentOffset(){
        self.mainScrollView.setContentOffset(.zero, animated: true);
    }
    
    @objc internal func openSchedulePage(){
        self.openPresentablePage(schedulePageViewController());
    }
    
    internal func openTableViewPage(_ indexPath: IndexPath){
        switch indexPath.section {
        case 1:
            self.openPresentablePage(self.tableViewContentViewControllers[0][indexPath.row]);
        case 2:
            if indexPath.row  < self.tableViewContentViewControllers[1].count{ self.openPresentablePage(self.tableViewContentViewControllers[1][indexPath.row]);
            }
        default:
            print("invalid indexPath section in profilePage");
        }
    }
    
    internal func openPresentablePage(_ vc: presentableViewController){
        /*transitionDelegateVar = transitionDelegate();
        vc.transitioningDelegate = transitionDelegateVar;
        vc.modalPresentationStyle = .custom;
        
        self.present(vc, animated: true);*/
        
        let profileDataDict : [String : presentableViewController] = ["vc" : vc];
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: profilePageContentNotification), object: nil, userInfo: profileDataDict);
        
    }
    
}
