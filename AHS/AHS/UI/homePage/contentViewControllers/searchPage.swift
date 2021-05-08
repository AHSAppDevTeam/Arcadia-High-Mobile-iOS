//
//  searchPage.swift
//  AHS
//
//  Created by Richard Wei on 5/7/21.
//

import Foundation
import UIKit

class searchPageController : homeContentPageViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        //self.view.backgroundColor = .systemRed;
        let testView = UIView(frame: CGRect(x: 0, y: 0, width: AppUtility.getCurrentScreenSize().width, height: AppUtility.getCurrentScreenSize().width / 10));
        testView.backgroundColor = .systemRed;
        
        self.view.addSubview(testView);
        
    }
    
    
}
