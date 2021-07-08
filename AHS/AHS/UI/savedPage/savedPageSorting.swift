//
//  savedPageSorting.swift
//  AHS
//
//  Created by Richard Wei on 7/5/21.
//

import Foundation
import UIKit

enum savedSortingMethods : Int, Codable{
    case byTime
    case byTitle
    case byAuthor
    
    case byInvertedTime
    case byInvertedTitle
    case byInvertedAuthor
    
    public func comp(_ a: fullArticleData, _ b: fullArticleData) -> Bool{
        switch self {
        case .byTime:
            return internalComp(a, b, .byTime);
        case .byTitle:
            return internalComp(a, b, .byTitle)
        case .byAuthor:
            return internalComp(a, b, .byAuthor);
            //
        case .byInvertedTime:
            return !internalComp(a, b, .byTime);
        case .byInvertedTitle:
            return !internalComp(a, b, .byTitle);
        case .byInvertedAuthor:
            return !internalComp(a, b, .byAuthor);
        }
    }
    
    private func internalComp(_ a: fullArticleData, _ b: fullArticleData, _ method: savedSortingMethods) -> Bool{
        switch method {
        case .byTime:
            return dataManager.articleTimestampComp(a.baseData.timestamp, b.baseData.timestamp);
        case .byTitle:
            return a.baseData.title < b.baseData.title;
        case .byAuthor:
            return a.author < b.author;
        default:
            print("invalid sorting method passed to internal comp func");
            return false;
        }
    }
    
}

extension savedPageViewController{
    
    internal func sortArticles(_ articleList: [fullArticleData]) -> [fullArticleData]{
        
        return articleList.sorted(by: { (a, b) in
            return a.baseData.timestamp > b.baseData.timestamp;
        });
    
    }
    
}
