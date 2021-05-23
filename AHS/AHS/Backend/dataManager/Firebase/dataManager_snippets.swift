//
//  dataManager_snippets.swift
//  AHS
//
//  Created by Richard Wei on 5/23/21.
//

import Foundation
import Firebase
import FirebaseDatabase

struct articleSnippetData{
    var articleID : String = "";
    var author : String = "";
    var featured : Bool = false;
    var notified : Bool = false;
    var thumbURLs : [String] = [];
    var timestamp : Int64 = 0;
    var title : String = "";
    var views : Int = 0;
}

extension dataManager{
    static public func getAllArticleSnippets(completion: @escaping ([articleSnippetData]) -> Void){
        
        setupConnection();
        
        if (internetConnected){
            if (articleSnippetArray.count > 0){
                articleSnippetArray = [];
            }
            
            loadArticleSnippetList(completion: { () in
                
                completion(articleSnippetArray);
                
            });
        }

    }
    
    static private func loadArticleSnippetList(completion: @escaping () -> Void){
        
        dataRef.child("snippets").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if (snapshot.exists()){
                
                let enumerator = snapshot.children;
                
                while let article = enumerator.nextObject() as? DataSnapshot{ // each article snippet
                    
                    let dataDict = article.value as? NSDictionary;
                    
                    var data : articleSnippetData = articleSnippetData();
                    
                    data.articleID = article.key;
                    data.author = dataDict?["author"] as? String ?? "";
                    data.featured = dataDict?["featured"] as? Bool ?? false;
                    data.notified = dataDict?["notified"] as? Bool ?? false;
                    data.thumbURLs = dataDict?["thumbURLs"] as? [String] ?? [];
                    data.timestamp = dataDict?["timestamp"] as? Int64 ?? 0;
                    data.title = dataDict?["title"] as? String ?? "";
                    data.views = dataDict?["views"] as? Int ?? 0;
                    
                    articleSnippetArray.append(data);
                    
                    print("article found - \(data.title)")
                    
                }
                
                completion();
                
            }
            
        });
    }
    
}
