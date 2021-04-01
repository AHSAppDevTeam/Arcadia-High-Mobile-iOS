//
//  dataManager_featuredCategory.swift
//  AHS
//
//  Created by Richard Wei on 3/31/21.
//

import Foundation
import UIKit
import Firebase

extension dataManager{

    static public func getFeaturedCategoryData(completion: @escaping (String, String) -> Void){ // title, blurb
        
        setupConnection();
        
        if (internetConnected){
            
            getFeaturedCategoryID(completion: { (id) in
                
                if (id != ""){
                    
                    getFeaturedCategoryTitleBlurb(id: id, completion: { (title, blurb) in
                        
                        completion(title, blurb);
                        
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
    
    static private func getFeaturedCategoryTitleBlurb(id: String, completion: @escaping (String, String) -> Void){
        
        dataRef.child("categories").child(id).observeSingleEvent(of: .value){ (snapshot) in
            
            var title = "", blurb = "";
            
            let enumerator = snapshot.children;
            
            while let categoryContent = enumerator.nextObject() as? DataSnapshot{
                
                if (categoryContent.key == "title"){
                    title = categoryContent.value as? String ?? "";
                }
                else if (categoryContent.key == "blurb"){
                    blurb = categoryContent.value as? String ?? "";
                }
                
            }
            
            if (title != "" && blurb != ""){
                completion(title, blurb);
            }
            
        }
        
    }
}
