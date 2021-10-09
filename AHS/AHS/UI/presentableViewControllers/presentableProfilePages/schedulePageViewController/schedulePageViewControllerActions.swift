//
//  schedulePageViewControllerActions.swift
//  AHS
//
//  Created by Richard Wei on 10/7/21.
//

import Foundation
import UIKit
import SwiftUI

extension schedulePageViewController{
    
    @objc internal func refresh(){
        self.refreshControl.endRefreshing();
    }
 
    @objc internal func handleBackButton(_ button: UIButton){
        self.dismiss(animated: true);
    }
    
}
