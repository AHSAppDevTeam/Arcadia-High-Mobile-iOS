//
//  savedPageSorting.swift
//  AHS
//
//  Created by Richard Wei on 7/5/21.
//

import Foundation
import UIKit


struct savedSortingStruct : Codable{
    enum savedSortingMethods : Int, Codable{
        
        static public let defaultValue : savedSortingMethods = .byTime;
        
        case byTime
        case byTitle
        case byAuthor
        
        static public func numberOfMethods() -> Int{
            return 3;
        }
        
        static public func nameFromIndex(_ index: Int) -> String{
            switch index {
            case 0:
                return "Time";
            case 1:
                return "Title";
            case 2:
                return "Author";
            default:
                return "";
            }
        }
        
        static public func methodFromIndex(_ index: Int) -> savedSortingMethods{
            return self.init(rawValue: index) ?? self.defaultValue;
        }
        
        public func comp(_ a: fullArticleData, _ b: fullArticleData) -> Bool{
            switch self {
            case .byTime:
                return dataManager.articleTimestampComp(a.baseData.timestamp, b.baseData.timestamp);
            case .byTitle:
                return a.baseData.title < b.baseData.title;
            case .byAuthor:
                return a.author < b.author;
            }
        }
        
    }
    
    //
    
    static public func numberOfOptions() -> Int{
        return 1;
    }
    
    static public func optionNameFromIndex(_ index: Int) -> String{
        switch index {
        case 0:
            return "Inverted";
        default:
            return "";
        }
    }
    
    mutating public func updateOptionWithIndex(_ index: Int, _ value: Bool){
        switch index {
        case 0:
            self.inverted = value;
        default:
            print("invalid index passed to update option");
        }
    }
    
    public func getOptionWithIndex(_ index: Int) -> Bool{
        switch index {
        case 0:
            return inverted;
        default:
            return false;
        }
    }
    
    //
    
    static public func numberOfCells() -> Int{
        return numberOfOptions() + savedSortingMethods.numberOfMethods();
    }
    
    var inverted : Bool = false;
    var sortingMethod : savedSortingMethods = .defaultValue;
    
}

extension savedPageViewController{
    
    internal func sortArticles(_ articleList: [fullArticleData]) -> [fullArticleData]{
        
        return articleList.sorted(by: { (a, b) in
            return dataManager.preferencesStruct.savedArticlesSortPreference.sortingMethod.comp(a, b);
        });
    
    }
    
}
