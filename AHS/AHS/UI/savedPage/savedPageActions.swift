//
//  savedPageActions.swift
//  AHS
//
//  Created by Richard Wei on 7/3/21.
//

import Foundation
import UIKit

extension savedPageViewController{
    
    @objc internal func refresh(_ refreshControl: UIRefreshControl){
        self.renderContent();
        self.refreshControl.endRefreshing();
    }
    
    @objc internal func clearAll(_ button: UIButton){
        print("clear all")
    }
    
    @objc internal func sortBy(_ button: UIButton){
        print("sort by")
    }
    
    @objc internal func openArticle(_ button: ArticleButton){
        guard let articledata = button.articleData else{
            return;
        }
        
        let articleDataDict : [String : Any] = ["articleData" : articledata];
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: articlePageNotification), object: nil, userInfo: articleDataDict);
        
    }
    
}
