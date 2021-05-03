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
    var color : UIColor = UIColor();
    var featured : Bool = false;
    var title : String = "";
}

extension dataManager{
    static public func getCategoryData(_ categoryID: String , completion: @escaping (categoryData) -> Void){
        
        guard let categoryLookupData = categoryLookupMap[categoryID] else {
            loadCategoryData(categoryID, completion: { (data) in
                categoryLookupMap[categoryID] = data;
                completion(data);
            });
            return;
        }
        
        completion(categoryLookupData);
    }
    
    static private func loadCategoryData(_ categoryID: String, completion : @escaping (categoryData) -> Void){
        setupConnection();
        
        if (internetConnected){
            
            dataRef.child("categories").child(categoryID).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if (snapshot.exists()){
                    
                    let categoryDict = snapshot.value as? NSDictionary;
                    
                    var data : categoryData = categoryData();
                    
                    data.articleIDs = categoryDict?["articleIDs"] as? [String] ?? [];
                    data.blurb = categoryDict?["blurb"] as? String ?? "";
                    data.color = UIColor.init(hex: categoryDict?["color"] as? String ?? "");
                    data.featured = categoryDict?["featured"] as? Bool ?? false;
                    data.title = categoryDict?["title"] as? String ?? "";
                    
                    completion(data);
                    
                }
            });
            
        }
    }
}
