//
//  dataManager_article.swift
//  AHS
//
//  Created by Richard Wei on 4/6/21.
//

import Foundation
import Firebase
import FirebaseDatabase

struct fullArticleData : Codable{
    var author : String = "";
    var body : String = "";
    
    var views : Int64 = 0;
    
    var featured : Bool = false;
    var notified : Bool = false;
    
    var imageURLs : [String] = [];
    var videoIDs : [String] = [];
    
    var relatedArticleIDs : [String] = [];

    var baseData : baseArticleData = baseArticleData();
}

struct baseArticleData : Codable{
    var isValid : Bool = false;
    
    var articleID : String = "";
    var categoryID : String = "";
    
    var title : String = "";
    
    var timestamp : Int64 = INT64_MAX; // so that when an invalid article is sorted, it is placed at the bottom
    var color : Color? = nil;
    
    var thumbURLs : [String] = [];
}

extension dataManager{
    
    static public func getFullArticleData(_ id: String, completion: @escaping (fullArticleData) -> Void){
        
        setupConnection();
        
        if (internetConnected){
            
            dataRef.child("articles").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                
                var data : fullArticleData = fullArticleData();
                
                if (snapshot.exists()){
                    let dataDict = snapshot.value as? NSDictionary;
                    
                    data.author = dataDict?["author"] as? String ?? "";
                    data.body = dataDict?["body"] as? String ?? "";
                    data.views = dataDict?["views"] as? Int64 ?? 0;
                    data.featured = dataDict?["featured"] as? Bool ?? false;
                    data.notified = dataDict?["notified"] as? Bool ?? false;
                    data.imageURLs = dataDict?["imageURLs"] as? [String] ?? [];
                    data.videoIDs = dataDict?["videoIDs"] as? [String] ?? [];
                    data.relatedArticleIDs = dataDict?["relatedArticleIDs"] as? [String] ?? [];
                    
                    getBaseArticleData(id, completion: { (base) in
                        data.baseData = base;
                        completion(data);
                    });
                }
                else{
                    print("article '\(id)' does not exist");
                    completion(data);
                }
                
            });
            
        }
        
    }
    
    static public func getBaseArticleData(_ id: String, completion: @escaping (baseArticleData) -> Void){
        
        setupConnection();
        
        if (internetConnected){
            
            dataRef.child("snippets").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                
                var data : baseArticleData = baseArticleData();
                
                if (snapshot.exists()){
                    
                    let dataDict = snapshot.value as? NSDictionary;
                    
                    data.isValid = true;
                    
                    data.articleID = id;
                    data.categoryID = dataDict?["categoryID"] as? String ?? "";
                    data.title = dataDict?["title"] as? String ?? "";
                    data.timestamp = dataDict?["timestamp"] as? Int64 ?? 0;
                    data.thumbURLs = dataDict?["thumbURLs"] as? [String] ?? [];
                    
                    if let hex = dataDict?["color"] as? String{
                        data.color = Color.init(hex: hex);
                    }
                    
                }
                else{
                    print("article '\(id)' does not exist");
                }
                
                completion(data);
            });
            
        }
    }
    
}
