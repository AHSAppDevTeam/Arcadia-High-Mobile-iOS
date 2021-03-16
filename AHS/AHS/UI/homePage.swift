//
//  homePage.swift
//  AHS
//
//  Created by Richard Wei on 3/14/21.
//

import Foundation
import UIKit

class homePageViewController : pageViewController{
    
    init(){
        super.init(nibName: nil, bundle: nil);
        self.pageName = "Home";
    }
    
    required init?(coder: NSCoder) { // required uiviewcontroller init
        super.init(coder: coder);
    }
    
    //
    
    override func viewDidLoad() {
        super.viewDidLoad();
    
        self.view.backgroundColor = .cyan;
        
    }
}
