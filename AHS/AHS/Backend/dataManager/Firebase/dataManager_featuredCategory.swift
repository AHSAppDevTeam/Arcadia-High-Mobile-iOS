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
            
            var data : featuredCategoryData = featuredCategoryData();
            
            let enumerator = snapshot.children;
            
            while let categoryContent = enumerator.nextObject() as? DataSnapshot{
                
                if (categoryContent.key == "title"){
                    data.title = categoryContent.value as? String ?? "";
                }
                else if (categoryContent.key == "blurb"){
                    data.blurb = categoryContent.value as? String ?? "";
                }
                else if (categoryContent.key == "colorDarkMode"){
                    data.colorDarkMode = UIColor.init(hex: categoryContent.value as? String ?? "");
                }
                else if (categoryContent.key == "colorLightMode"){
                    data.colorLightMode = UIColor.init(hex: categoryContent.value as? String ?? "");
                }
                
            }
            
            completion(data);
            
        }
        
    }
}
