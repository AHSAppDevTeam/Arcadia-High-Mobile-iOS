//
//  notificationPageViewControllerSorting.swift
//  AHS
//
//  Created by Richard Wei on 7/16/21.
//

import Foundation
import UIKit

struct notificationSortingStruct : Codable{
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
            
            if (dataManager.preferencesStruct.notificationsSortPreference.read){ // read option is on
                
                let isARead = dataManager.isNotificationRead(a.notificationID), isBRead = dataManager.isNotificationRead(b.notificationID);
                
                if (isARead != isBRead){
                    return isBRead;
                }
                
            }
            
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
    var read : Bool = true;
    
    var sortingMethod : notificationSortingMethods = .defaultValue;
    
}

extension notificationPageViewController{
    
    internal func sortNotifications(_ notificationList: [notificationData]) -> [notificationData]{
        
        return notificationList.sorted(by: { (a, b) in
            let result = dataManager.preferencesStruct.notificationsSortPreference.sortingMethod.comp(a, b);
            return dataManager.preferencesStruct.notificationsSortPreference.inverted ? !result : result;
        });
        
    }
    
    internal func filterNotifications(_ notificationIDList: [String]) -> [notificationData]{
        
        var notificationList : [notificationData] = [];
        
        for notificationID in notificationIDList{
            
            let data = dataManager.getCachedNotificationData(notificationID);
            
            if (dataManager.isUserSubscribedToCategory(data.categoryID) && dataManager.getCachedCategoryData(data.categoryID).visible){
                
                notificationList.append(data);
                
            }
            
        }
        
        return notificationList;
        
    }
    
}
