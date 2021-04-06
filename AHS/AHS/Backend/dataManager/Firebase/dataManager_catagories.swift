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
            
            var data : categoryData = categoryData();
            
            let enumerator = snapshot.children;
            
            while let attributes = enumerator.nextObject() as? DataSnapshot{
                
                if (attributes.key == "articleIDs"){
                    let articleIDsIT = attributes.children;
                    while let articleID = articleIDsIT.nextObject() as? DataSnapshot{
                        data.articleIDs.append(articleID.value as? String ?? "");
                    }
                }
                else if (attributes.key == "blurb"){
                    data.blurb = attributes.value as? String ?? "";
                }
                else if (attributes.key == "colorDarkMode"){
                    data.colorDarkMode = UIColor.init(hex: attributes.value as? String ?? "");
                }
                else if (attributes.key == "colorLightMode"){
                    data.colorLightMode = UIColor.init(hex: attributes.value as? String ?? "");
                }
                else if (attributes.key == "featured"){
                    data.featured = attributes.value as? Bool ?? false;
                }
                else if (attributes.key == "title"){
                    data.title = attributes.value as? String ?? "NULL title";
                }
                
            }
            
            completion(data);
            
        });
        
    }
}
