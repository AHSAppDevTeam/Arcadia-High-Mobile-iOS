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
        updateCategoryButton(button);
    }
    
    private func updateCategoryButton(_ button: CategoryButton){
        
        let primaryColor : UIColor = button.isSelected ? BackgroundColor : button.categoryAccentColor;
        let secondaryColor : UIColor = button.isSelected ? button.categoryAccentColor : BackgroundColor;
        
        for subview in button.subviews{
            
            if subview.tag == 1{ // label
                
                guard let label = subview as? UILabel else{
                    continue;
                }
                
                label.textColor = primaryColor;
            }
            else if subview.tag == -1{ // image view
                
                guard let imageView = subview as? UIImageView else{
                    continue;
                }
                
                imageView.tintColor = primaryColor;
            }
            
        }
        
        button.backgroundColor = secondaryColor;
        
    }
    
}
