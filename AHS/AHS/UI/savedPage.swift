//
//  savedPage.swift
//  AHS
//
//  Created by Richard Wei on 3/14/21.
//

import Foundation
import UIKit

class savedPageViewController : pageViewController{
    
    init(){
        super.init(nibName: nil, bundle: nil);
        self.pageName = "Your";
        self.secondaryPageName = "Saved";
        self.viewControllerIconName = "bookmark.fill";
    }
    
    required init?(coder: NSCoder) { // required uiviewcontroller init
        super.init(coder: coder);
    }
    
    //
    
    override func viewDidLoad() {
        super.viewDidLoad();
    
        self.view.backgroundColor = .systemPink;
    }
}
