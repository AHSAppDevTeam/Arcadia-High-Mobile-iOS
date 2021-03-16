//
//  bulletinPage.swift
//  AHS
//
//  Created by Richard Wei on 3/14/21.
//

import Foundation
import UIKit

class bulletinPageViewController : pageViewController{
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.pageName = "Student";
        self.secondaryPageName = "Bulletin";
        self.view.backgroundColor = .blue;
    }
}

