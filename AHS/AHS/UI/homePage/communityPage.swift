//
//  communityPage.swift
//  AHS
//
//  Created by Richard Wei on 3/27/21.
//

import Foundation
import UIKit

class communityPageController : homeContentPageViewController{

    override func viewDidLoad() {
        super.viewDidLoad();
        
        let testViewFrame = CGRect(x: 0, y: 0, width: AppUtility.getCurrentScreenSize().width, height: AppUtility.getCurrentScreenSize().height / 2);
        let testView = UIView(frame: testViewFrame);
        
        testView.backgroundColor = .systemBlue;
        
        self.view.addSubview(testView);
        
        print("loaded community");
        
    }
    
    
}