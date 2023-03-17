//
//  searchPageViewControllerActions.swift
//  AHS
//
//  Created by Richard Wei on 3/17/23.
//

import Foundation
import UIKit

extension searchPageViewController{
    @objc internal func loadArticleSnippetList(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: homePageBeginRefreshing), object: nil);
        dataManager.getAllArticleSnippets(completion: { (snippetArray) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: homePageEndRefreshing), object: nil);
            
            self.filterHiddenSnippets(snippetArray: snippetArray, completion: { (filteredSnippetArray) in
                self.articleSnippetsArray = filteredSnippetArray;
                self.searchBarSearchButtonClicked(self.searchBarView);
            });
            
        });
        
    }
    
    @objc internal func exit(){
        self.dismiss(animated: true);
    }
}
