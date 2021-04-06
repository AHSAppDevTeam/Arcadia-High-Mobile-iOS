//
//  newsPage.swift
//  AHS
//
//  Created by Richard Wei on 3/27/21.
//

import Foundation
import UIKit

class newsPageController : homeContentPageViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let testViewFrame = CGRect(x: 0, y: 0, width: AppUtility.getCurrentScreenSize().width, height: AppUtility.getCurrentScreenSize().height);
        let testView = UIView(frame: testViewFrame);
        
        testView.backgroundColor = .systemRed;
        
        self.view.addSubview(testView);
        
        print("loaded news");
        
        renderFeatured();
        
    }
    
    private func renderFeatured(){
        
        dataManager.getHomepageLocationData(completion: { (data) in
            
            print(data);
            
        });
        
    }
    
    
}
