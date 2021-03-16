//
//  savedPage.swift
//  AHS
//
//  Created by Richard Wei on 3/14/21.
//

import Foundation
import UIKit

class savedPageViewController : pageViewController{
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.pageName = "Your";
        self.secondaryPageName = "Saved";
        self.view.backgroundColor = .systemPink;
    }
}
