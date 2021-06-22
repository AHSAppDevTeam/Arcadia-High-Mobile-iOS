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
    static public func loadBulletinArticleList(_ articleIDs: [String]){
        
        for articleID in articleIDs{
            
            cacheArticleData(articleID, completion: { (_) in });
            
        }
        
    }
    
    static public func resetBulletinArticleListCache(){
        bulletinArticleCache = [:];
    }
    
    static public func getArticlePairTimestamp(_ aID: String, _ bID: String, completion: @escaping (Int64, Int64) -> Void){ // completion handler return corresponding timestamp
        
        if (bulletinArticleCache[aID] == nil){
            
            cacheArticleData(aID, completion: { (_) in
                
                getArticlePairTimestamp(aID, bID, completion: { (aT, bT) in
                    completion(aT, bT);
                });
                
            });
            
        }
        else if (bulletinArticleCache[bID] == nil){
            
            cacheArticleData(bID, completion: { (_) in
                
                getArticlePairTimestamp(aID, bID, completion: { (aT, bT) in
                    completion(aT, bT);
                });
                
            });
            
        }
        else{
            
            completion(bulletinArticleCache[aID]!.timestamp, bulletinArticleCache[bID]!.timestamp);
            
        }
        
    }
    
    //
    
    static private func cacheArticleData(_ id: String, completion: @escaping (baseArticleData) -> Void){
        
        dataManager.getBaseArticleData(id, completion: { (articledata) in
            
            self.bulletinArticleCache[id] = articledata;
            
            completion(articledata);
            
        });
        
    }
}

