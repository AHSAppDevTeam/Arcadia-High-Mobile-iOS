//
//  bulletinPageArticleParser.swift
//  AHS
//
//  Created by Richard Wei on 6/20/21.
//

import Foundation
import UIKit

extension bulletinPageViewController{
    
    internal func resetArticleParser(){
        //bulletinCategoryDictionary = [:];
        bulletinArticleIDList = [];
    }
    
    internal func resetCategorySelection(){
        bulletinCategoryDictionary = [:];
    }
    
    internal func appendCategory(_ categoryID: String, _ articleIDs: [String]){
        bulletinArticleIDList += articleIDs;
        //bulletinCategoryDictionary[categoryID] = false; // is automatically set to false as default
    }
    
    internal func updateCategoryFilter(_ categoryID: String, _ isSelected: Bool){
        bulletinCategoryDictionary[categoryID] = isSelected;
        updateArticleList();
    }
    
    //
    
    internal func updateArticleList(){
        sortArticleList();
        
        let filteredArticleList = filterArticleList();
        
        let articleSeperator = min(filteredArticleList.count, comingUpMaxArticleCount);
        self.renderComingUp( Array(filteredArticleList[ 0 ..< articleSeperator ]) );
        self.renderArticleList( Array(filteredArticleList[ articleSeperator ..< filteredArticleList.count]) );
    }
    
    private func sortArticleList(){
        bulletinArticleIDList.sort(by: { (a, b) in
            let currTime = timeManager.getCurrentEpoch();
            let aT = dataManager.getCachedBulletinArticleData(a).timestamp, bT = dataManager.getCachedBulletinArticleData(b).timestamp;
            
            if (aT > currTime && bT > currTime){
                return aT < bT;
            }
            else{
                return aT > bT;
            }
            
        });
    }
    
    private func filterArticleList() -> [String]{
        
        var articleList : [String] = [];
        
        for i in 0 ..< bulletinArticleIDList.count{
            let articleID = bulletinArticleIDList[i];
            let categoryID = dataManager.getCachedBulletinArticleData(articleID).categoryID;
            
            if (bulletinCategoryDictionary[categoryID] ?? false){
                articleList.append(articleID);
            }
            
        }
        
        return articleList.count == 0 ? bulletinArticleIDList : articleList;
        
    }
    
}
