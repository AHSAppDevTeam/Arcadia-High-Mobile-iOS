//
//  newsPage_categories.swift
//  AHS
//
//  Created by Richard Wei on 4/9/21.
//

import Foundation
import UIKit

extension newsPageController{
    internal func loadCategories(){
        dataManager.getHomepageLocationData(completion: { (location) in
            for categoryID in location.categoryIDs{
                dataManager.getCategoryData(categoryID, completion: { (category) in
                    self.renderCategory(category);
                });
            }
        });
    }
    
    internal func renderCategory(_ categorydata: categoryData){
        //categorydata.
        print(categorydata.title);
    }
    
    private func renderCategoryContent(_ categorydata: categoryData, _ parentView: UIView){
        
    }
}
