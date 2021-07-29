//
//  dataManager_bulletinArticles.swift
//  AHS
//
//  Created by Richard Wei on 6/22/21.
//

import Foundation
import Firebase
import FirebaseDatabase

extension dataManager{
    static public func loadBulletinArticleList(_ articleIDs: [String], completion: @escaping () -> Void){
        
        DispatchQueue.global(qos: .background).async {
            
            let dispatchGroup = DispatchGroup();
            
            for articleID in articleIDs{
                
                dispatchGroup.enter();
                
                cacheArticleData(articleID, completion: { (_) in
                    
                    dispatchGroup.leave();
                    
                });
                
            }
            
            dispatchGroup.wait();
            
            DispatchQueue.main.async {
                completion();
            }
        }
        
    }
    
    static public func resetBulletinArticleListCache(){
        bulletinArticleCache = [:];
    }
    
    static public func getCachedBulletinArticleData(_ articleID: String) -> baseArticleData{
        return bulletinArticleCache[articleID] ?? baseArticleData();
    }
    
    //
    
    static private func cacheArticleData(_ id: String, completion: @escaping (baseArticleData) -> Void){
    
        dataManager.getBaseArticleData(id, completion: { (articledata) in
            
            self.bulletinArticleCache[id] = articledata;
            
            completion(articledata);
            
        });
        
    }
}

