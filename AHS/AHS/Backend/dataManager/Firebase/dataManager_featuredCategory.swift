//
//  dataManager_featuredCategory.swift
//  AHS
//
//  Created by Richard Wei on 3/31/21.
//

import Foundation
import UIKit
import Firebase

struct featuredCategoryData{
    var title : String = "";
    var blurb : String = "";
    var colorDarkMode : UIColor = UIColor();
    var colorLightMode : UIColor = UIColor();
}

extension dataManager{

    static public func getFeaturedCategoryData(completion: @escaping (featuredCategoryData) -> Void){ // title, blurb
        
        setupConnection();
        
        if (internetConnected){
            
            getFeaturedCategoryID(completion: { (id) in
                
                if (id != ""){
                    
                    getFeaturedCategoryTitleBlurb(id: id, completion: { (data) in
                        
                        completion(data);
                        
                    });
                    
                }
                
            });
            
        }
        
    }
    
    static private func getFeaturedCategoryID(completion: @escaping (String) -> Void){
        
        dataRef.child("featuredCategoryID").observeSingleEvent(of: .value){ (snapshot) in
            
            //print("snapshot - \(snapshot.key) = \(snapshot.value)")
            
            completion(snapshot.value as? String ?? "");
            
        }
        
    }
    
    static private func getFeaturedCategoryTitleBlurb(id: String, completion: @escaping (featuredCategoryData) -> Void){
        
        dataRef.child("categories").child(id).observeSingleEvent(of: .value){ (snapshot) in
            
            let categoryDict = snapshot.value as? NSDictionary;
            
            var data : featuredCategoryData = featuredCategoryData();
            
            data.title = categoryDict?["title"] as? String ?? "";
            data.blurb = categoryDict?["blurb"] as? String ?? "";
            data.colorDarkMode = UIColor.init(hex: categoryDict?["colorDarkMode"] as? String ?? "");
            data.colorLightMode = UIColor.init(hex: categoryDict?["colorLightMode"] as? String ?? "");
            
            completion(data);
            
        }
        
    }
}
