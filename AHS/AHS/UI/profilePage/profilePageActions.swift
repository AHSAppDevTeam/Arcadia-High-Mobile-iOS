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
        self.refreshControl.endRefreshing();
    }
    
    @objc internal func openSchedulePage(){
        self.openPresentablePage(schedulePageViewController());
    }
    
    internal func openPresentablePage(_ vc: presentableViewController){
        transitionDelegateVar = transitionDelegate();
        vc.transitioningDelegate = transitionDelegateVar;
        vc.modalPresentationStyle = .custom;
        
        self.present(vc, animated: true);
    }
    
}
