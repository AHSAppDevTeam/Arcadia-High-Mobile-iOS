//
//  featuredCategoryView.swift
//  AHS
//
//  Created by Richard Wei on 3/30/21.
//

import Foundation
import UIKit

class featuredCategoryViewController : homeContentPageViewController{
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let horizontalPadding = AppUtility.getCurrentScreenSize().width / 12;
        let mainViewFrame = CGRect(x: horizontalPadding, y: 0, width: AppUtility.getCurrentScreenSize().width - 2*horizontalPadding, height: AppUtility.getCurrentScreenSize().height / 12);
        let mainView = UIButton(frame: mainViewFrame);
        
        mainView.layer.cornerRadius = mainView.frame.height / 2;
        mainView.backgroundColor = UIColor.rgb(216, 150, 61);
        
        mainView.addTarget(self, action: #selector(self.handlePress), for: .touchUpInside);
        
        self.view.addSubview(mainView);
        
        dataManager.getFeaturedCategoryData(completion: { (title, blurb) in
            
            print("title - \(title) + \(blurb)")
            
        });
        
    }
    
    @objc func handlePress(_ sender: UIButton){
        print("featured category press");
    }
}
