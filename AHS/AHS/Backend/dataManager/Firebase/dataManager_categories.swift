//
//  dataManager_catagories.swift
//  AHS
//
//  Created by Richard Wei on 3/27/21.
//

import Foundation
import Firebase
import FirebaseDatabase

enum categoryLayout{
    case list
    case row
    case slash
    case none
}

struct categoryData{
    var categoryID : String = "";
    var articleIDs : [String] = [];
    var blurb : String = "";
    var color : UIColor = UIColor.rgb(0, 0, 0);
    var featured : Bool = false;
    var iconURL: String = "";
    var layout : categoryLayout = .none;
    var thumbURLs : [String] = [];
    var title : String = "";
    var visible : Bool = false;
}

extension dataManager{
    
    static public func preloadCategoryData(){
        
        setupConnection();
        
        if (internetConnected){
            dataRef.child("categories").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if (snapshot.exists()){
                    
                    let enumerator = snapshot.children;
                    while let category = enumerator.nextObject() as? DataSnapshot{
                        
                        loadCategoryData(category.key, completion: { (categorydata) in
                            
                            categoryLookupDispatchQueue.sync {
                                categoryLookupMap[category.key] = categorydata;
                            }
                            
                        });
                        
                    }
                    
                }
                
            });
        }
        
    }
    
    static public func getPreloadedCategoryData(_ categoryID: String) -> categoryData{
        categoryLookupDispatchQueue.sync {
            return categoryLookupMap[categoryID] ?? createDefaultCategoryData(categoryID);
        }
    }
    
    static public func getCategoryData(_ categoryID: String , completion: @escaping (categoryData) -> Void){
        
        categoryLookupDispatchQueue.sync {
            guard let categoryLookupData = categoryLookupMap[categoryID] else {
                loadCategoryData(categoryID, completion: { (data) in
                    
                    categoryLookupDispatchQueue.sync {
                        categoryLookupMap[categoryID] = data;
                    }
                    
                    completion(data);
                });
                return;
            }
            
            completion(categoryLookupData);
        }
        
    }
    
    static private func loadCategoryData(_ categoryID: String, completion : @escaping (categoryData) -> Void){
        setupConnection();
        
        if (internetConnected && checkValidString(categoryID)){
            
            dataRef.child("categories").child(categoryID).observeSingleEvent(of: .value, with: { (snapshot) in
                
                var data : categoryData = categoryData();
                
                if (snapshot.exists()){
                    
                    let categoryDict = snapshot.value as? NSDictionary;
                    
                    data.categoryID = categoryID;
                    
                    data.articleIDs = categoryDict?["articleIDs"] as? [String] ?? [];
                    data.blurb = categoryDict?["blurb"] as? String ?? "";
                    data.color = UIColor.init(hex: categoryDict?["color"] as? String ?? "");
                    data.layout = dataManager.encodeStringToLayoutEnum(categoryDict?["layout"] as? String ?? "");
                    data.featured = categoryDict?["featured"] as? Bool ?? false;
                    data.iconURL = categoryDict?["iconURL"] as? String ?? "";
                    data.thumbURLs = categoryDict?["thumbURLs"] as? [String] ?? [];
                    data.title = categoryDict?["title"] as? String ?? "";
                    data.visible = categoryDict?["visible"] as? Bool ?? false;
                    
                }
                else{
                    print("categoryID '\(categoryID)' does not exist");
                }
                
                completion(data);
                
            });
            
        }
    }
    
    static private func createDefaultCategoryData(_ categoryID: String) -> categoryData{
        var data = categoryData();
        data.title = categoryID;
        return data;
    }
    
    static internal func encodeStringToLayoutEnum(_ s: String) -> categoryLayout{
        switch s {
        case "splash":
            return .slash;
        case "row":
            return .row; // row layout always has images
        case "list":
            return .list; // list layout does not have images
        default:
            return .none;
        }
    }
}
