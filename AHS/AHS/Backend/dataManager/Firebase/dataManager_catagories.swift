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
    static public func getCategoryData(_ categoryID: String , completion: @escaping (categoryData) -> Void){
        
        dataRef.child("categories").child(categoryID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let categoryDict = snapshot.value as? NSDictionary;
            
            var data : categoryData = categoryData();
            
            data.articleIDs = categoryDict?["articleIDs"] as? [String] ?? [];
            data.blurb = categoryDict?["blurb"] as? String ?? "";
            data.colorDarkMode = UIColor.init(hex: categoryDict?["colorDarkMode"] as? String ?? "");
            data.colorLightMode = UIColor.init(hex: categoryDict?["colorLightMode"] as? String ?? "");
            data.featured = categoryDict?["featured"] as? Bool ?? false;
            data.title = categoryDict?["title"] as? String ?? "";
            
            completion(data);
            
        });
        
    }
}
