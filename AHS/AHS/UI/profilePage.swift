//
//  profilePage.swift
//  AHS
//
//  Created by Richard Wei on 3/14/21.
//

import Foundation
import UIKit

class profilePageViewController : pageViewController{
    
    init(){
        super.init(nibName: nil, bundle: nil);
        self.pageName = "Your";
        self.secondaryPageName = "Profile";
        self.viewControllerIconName = "person.circle.fill";
    }
    
    required init?(coder: NSCoder) { // required uiviewcontroller init
        super.init(coder: coder);
    }
    
    //
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.view.backgroundColor = .darkGray;
    }
}
