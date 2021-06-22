//
//  bulletinPageActions.swift
//  AHS
//
//  Created by Richard Wei on 6/19/21.
//

import Foundation
import UIKit

extension bulletinPageViewController{
    
    @objc internal func refresh(){
        reset();
        loadBulletinData();
        dataManager.resetBulletinArticleListCache();
    }
 
    @objc internal func handleCategoryButton(_ button: CategoryButton){
        button.isSelected = !button.isSelected;
        updateCategoryFilter(button.categoryID, button.isSelected);
        
        
        
    }
    
}
