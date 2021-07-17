//
//  notificationPageViewControllerSorting.swift
//  AHS
//
//  Created by Richard Wei on 7/16/21.
//

import Foundation
import UIKit

struct notificationSortingStruct{
    enum notificationSortingMethods : Int, Codable{
        
        static public let defaultValue : notificationSortingMethods = .byTime;
        
        case byTime
        case byTitle
        
        case byInvertedTime
        case byInvertedTitle
        
        static public func numberOfEnums() -> Int{
            return 4;
        }
        
        static public func nameFromIndex(_ index: Int) -> String{
            switch index {
            case 0:
                return "Time";
            case 1:
                return "Title";
            case 3:
                return "Inverted Time";
            case 4:
                return "Inverted Title";
            default:
                return "";
            }
        }
        
        static public func methodFromIndex(_ index: Int) -> notificationSortingMethods{
            return self.init(rawValue: index) ?? .byTime;
        }
        
        public func comp(_ a: notificationData, _ b: notificationData) -> Bool{
            switch self {
            case .byTime:
                return notificationSortingMethods.internalComp(a, b, .byTime);
            case .byTitle:
                return notificationSortingMethods.internalComp(a, b, .byTitle)
            //
            case .byInvertedTime:
                return !notificationSortingMethods.internalComp(a, b, .byTime);
            case .byInvertedTitle:
                return !notificationSortingMethods.internalComp(a, b, .byTitle);
            }
        }
        
        private static func internalComp(_ a: notificationData, _ b: notificationData, _ method: notificationSortingMethods) -> Bool{
            switch method {
            case .byTime:
                return false;
            case .byTitle:
                return false;
            default:
                print("invalid sorting method passed to internal comp func");
                return false;
            }
        }
        
    }
    
    var shouldSortRead : Bool = false;
    var sortingMethod : notificationSortingMethods = notificationSortingMethods.defaultValue;
    
}

extension notificationPageViewController{
    
}
