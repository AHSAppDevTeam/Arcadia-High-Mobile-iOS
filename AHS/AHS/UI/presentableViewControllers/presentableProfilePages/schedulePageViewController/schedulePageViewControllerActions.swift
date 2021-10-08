//
//  schedulePageViewControllerActions.swift
//  AHS
//
//  Created by Richard Wei on 10/7/21.
//

import Foundation
import UIKit

extension schedulePageViewController{
    
    @objc internal func refresh(){
        self.refreshControl.endRefreshing();
    }
    
}
