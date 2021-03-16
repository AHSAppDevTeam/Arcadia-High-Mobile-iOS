//
//  profilePage.swift
//  AHS
//
//  Created by Richard Wei on 3/14/21.
//

import Foundation
import UIKit

class profilePageViewController : pageViewController{
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.pageName = "Your";
        self.secondaryPageName = "Profile";
        self.view.backgroundColor = .darkGray;
    }
}
