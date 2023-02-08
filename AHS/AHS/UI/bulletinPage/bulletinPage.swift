//
//  bulletinPage.swift
//  AHS
//
//  Created by Richard Wei on 3/14/21.
//

import Foundation
import UIKit

class bulletinPageViewController : mainPageViewController{
    
    init(){
        super.init(nibName: nil, bundle: nil);
        self.pageName = "Student";
        self.secondaryPageName = "Bulletin";
        self.viewControllerIconName = "doc.plaintext.fill";
    }
    
    required init?(coder: NSCoder) { // required uiviewcontroller init
        super.init(coder: coder);
    }
    
    //
    override func viewDidLoad() {
        super.viewDidLoad();
    }
}

