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
    
}
