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
        bulletinCategoryDictionary = [:];
        bulletinArticleIDList = [];
    }
    
    internal func appendCategory(_ categoryID: String, _ articleIDs: [String]){
        bulletinArticleIDList += articleIDs;
        bulletinCategoryDictionary[categoryID] = false;
    }
    
    internal func updateCategoryFilter(_ categoryID: String, _ isSelected: Bool){
        bulletinCategoryDictionary[categoryID] = isSelected;
    }
    
    
}
