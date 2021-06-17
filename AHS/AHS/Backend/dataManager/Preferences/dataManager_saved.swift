//
//  dataManager_saved.swift
//  AHS
//
//  Created by Richard Wei on 4/12/21.
//

import Foundation
import UIKit

extension dataManager{
    public static func saveArticle(_ data: fullArticleData){
        dataManager.preferencesStruct.savedArticlesDict[data.baseData.articleID] = data;
    }
    
    public static func unsaveArticle(_ articleID: String){
        dataManager.preferencesStruct.savedArticlesDict[articleID] = nil;
    }
    
    public static func isArticleSaved(_ articleID: String) -> Bool{
        return dataManager.preferencesStruct.savedArticlesDict[articleID] != nil;
    }
    
    public static func getArticleList() -> [fullArticleData]{
        
        var a : [fullArticleData] = [];
        
        for (_, data) in dataManager.preferencesStruct.savedArticlesDict{
            a.append(data);
        }
        
        // can sort 'a' here before returning it
        
        return a;
    }
}
