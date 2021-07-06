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
}

extension savedPageViewController{
    
    internal func sortArticles(_ articleList: [fullArticleData]) -> [fullArticleData]{
        return articleList.sorted(by: { (a, b) in
            return a.baseData.timestamp > b.baseData.timestamp;
        });
    }
    
}
