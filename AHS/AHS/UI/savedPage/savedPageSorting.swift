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
    
    static public func numberOfEnums() -> Int{
        return 6;
    }
    
    static public func nameFromIndex(_ index: Int) -> String{
        switch index {
        case 0:
            return "Time";
        case 1:
            return "Title";
        case 2:
            return "Author";
        case 3:
            return "Inverted Time";
        case 4:
            return "Inverted Title";
        case 5:
            return "Inverted Author";
        default:
            return "";
        }
    }
    
    public func comp(_ a: fullArticleData, _ b: fullArticleData) -> Bool{
        switch self {
        case .byTime:
            return savedSortingMethods.internalComp(a, b, .byTime);
        case .byTitle:
            return savedSortingMethods.internalComp(a, b, .byTitle)
        case .byAuthor:
            return savedSortingMethods.internalComp(a, b, .byAuthor);
            //
        case .byInvertedTime:
            return !savedSortingMethods.internalComp(a, b, .byTime);
        case .byInvertedTitle:
            return !savedSortingMethods.internalComp(a, b, .byTitle);
        case .byInvertedAuthor:
            return !savedSortingMethods.internalComp(a, b, .byAuthor);
        }
    }
    
    private static func internalComp(_ a: fullArticleData, _ b: fullArticleData, _ method: savedSortingMethods) -> Bool{
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
