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
        
        static public func numberOfMethods() -> Int{
            return 2;
        }
        
        static public func nameFromIndex(_ index: Int) -> String{
            switch index {
            case 0:
                return "Time";
            case 1:
                return "Title";
            default:
                return "";
            }
        }
        
        static public func methodFromIndex(_ index: Int) -> notificationSortingMethods{
            return self.init(rawValue: index) ?? self.defaultValue;
        }
        
        public func comp(_ a: notificationData, _ b: notificationData) -> Bool{
            switch self {
            case .byTime:
                return dataManager.articleTimestampComp(a.notifTimestamp, b.notifTimestamp);
            case .byTitle:
                return a.title < b.title;
            }
        }
        
    }
    
    //
    
    static public func numberOfOptions() -> Int{
        return 2;
    }
    
    static public func optionNameFromIndex(_ index: Int) -> String{
        switch index {
        case 0:
            return "Inverted";
        case 1:
            return "Read";
        default:
            return "";
        }
    }
    
    mutating public func updateOptionWithIndex(_ index: Int, _ value: Bool){
        switch index {
        case 0:
            self.inverted = value;
        case 1:
            self.read = value;
        default:
            print("invalid index passed to update option");
        }
    }
    
    public func getOptionWithIndex(_ index: Int) -> Bool{
        switch index {
        case 0:
            return inverted;
        case 1:
            return read;
        default:
            return false;
        }
    }
    
    //
    
    static public func numberOfCells() -> Int{
        return numberOfOptions() + notificationSortingMethods.numberOfMethods();
    }
    
    var inverted : Bool = false;
    var read : Bool = false;
    
    var sortingMethod : notificationSortingMethods = .defaultValue;
    
}

extension notificationPageViewController{
    
}
