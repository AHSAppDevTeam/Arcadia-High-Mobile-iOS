//
//  dataManager_catagories.swift
//  AHS
//
//  Created by Richard Wei on 3/27/21.
//

import Foundation
import Firebase
import FirebaseDatabase

struct categoryData{
    var articleIDs = [String]();
    var blurb : String = "";
    var colorDarkMode : UIColor = UIColor();  // needs hex string to be parsed
    var colorLightMode : UIColor = UIColor(); // needs hex string to be parsed
    var featured : Bool = false;
    var title : String = "";
}

extension dataManager{
    static internal func getCategoryData(_ categoryID: String , completion: @escaping (categoryData) -> Void){
        
        
        
    }
}
