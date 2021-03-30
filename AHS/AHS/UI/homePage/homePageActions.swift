//
//  homePageActions.swift
//  AHS
//
//  Created by Richard Wei on 3/27/21.
//

import Foundation
import UIKit

extension homePageViewController{
    
    @objc func selectCategoryButton(_ sender: UIButton){
        let tag = sender.tag;
        
        if (tag == 1){
            newsButton.backgroundColor = newsButtonColor;
            newsButton.setTitleColor(BackgroundColor, for: .normal);
            
            communityButton.backgroundColor = BackgroundColor;
            communityButton.setTitleColor(communityButtonColor, for: .normal);
        
            setContentView(0);
        }
        else if (tag == 2){
            newsButton.backgroundColor = BackgroundColor;
            newsButton.setTitleColor(newsButtonColor, for: .normal);
            
            communityButton.backgroundColor = communityButtonColor;
            communityButton.setTitleColor(BackgroundColor, for: .normal);
            
            setContentView(1);
        }
        
    }
    
    internal func setContentView(_ index: Int){
        
        //for view in contentView
        let newscontent : newsPageController = contentViewControllers[0] as! newsPageController;
        let communitycontent : communityPageController = contentViewControllers[1] as! communityPageController;
        
        //print(newscontent.testAtt + communitycontent.testAtt);
        
    }
    
}
