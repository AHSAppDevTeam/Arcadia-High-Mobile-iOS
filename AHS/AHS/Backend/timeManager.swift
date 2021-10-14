//
//  timeManager.swift
//  AHS
//
//  Created by Richard Wei on 3/17/21.
//

import Foundation
import UIKit
import SystemConfiguration

class timeManager{
    
    //
    
    struct timeSecondConstants{ // in seconds
        static public let second = 1;
        static public let minute = 60;
        static public let hour = 3600;
        static public let day = 86400;
        static public let week = 604800;
        static public let month = 2592000;
        static public let year = 31536000;
        static public let decade = 315360000;
        static public let century = 3153600000;
        
        static public let timePattern = [(second, "second"), (minute, "minute"), (hour, "hour"), (day, "day"), (week, "week"), (month, "month"), (year, "year"), (decade, "decade"), (century, "century")];
    }
    
    //
    
    static public let dateObj = Date();
    static public let calendar = Calendar.current;
    
    static public func getMonthString(_ date: Date = dateObj) -> String{
        let monthInt = calendar.dateComponents([.month], from: date).month;
        return calendar.monthSymbols[monthInt!-1];
    }
    
    static public func getYearString(_ date: Date = dateObj) -> String{
        return String(calendar.component(.year, from: date));
    }

    static public func getDateString(_ date: Date = dateObj) -> String{
        return String(calendar.component(.day, from: date));
    }
    
    static public func getWeekInt(_ date: Date = dateObj) -> Int{ // 1 based
        return calendar.component(.weekOfYear, from: date);
    }
    
    static public func getDayOfWeekInt(_ date: Date = dateObj) -> Int{ // 1 based
        let dayOfWeek = calendar.component(.weekday, from: date);
        return dayOfWeek == 1 ? 7 : dayOfWeek - 1;
        // Apple likes to base their calendars off of the fact that Sundays are considered to be the start of the week
    }
    
    static public func getCurrentEpoch() -> Int64{
        return Int64(NSDate().timeIntervalSince1970);
    }
    
    static func epochToDiffString(_ epoch: Int64) -> String{ // 1 hour ago
        if (epoch == -1){
            return "NULL";
        }
        
        let currTime = getCurrentEpoch();
        let diff : Double = Double(abs(currTime - epoch));
        
        var r = "NULL";
        
        for i in 1..<timeSecondConstants.timePattern.count{
            if (floor(diff / Double(timeSecondConstants.timePattern[i].0)) == 0){
                let prefix = Int(floor(diff / Double(timeSecondConstants.timePattern[i-1].0)));
                r = "\(prefix) " + timeSecondConstants.timePattern[i-1].1 + (prefix > 1 ? "s" : "");
                break;
            }
        }
        
        return currTime - epoch < 0 ? "in " + r : r + " ago";
    }
    
    static func epochToDateString(_ epoch: Int64) -> String{ // 99/99/99
        if (epoch == -1){
            return "NULL";
        }
        let date = Date(timeIntervalSince1970: TimeInterval(epoch));
        let year = calendar.component(.year, from: date);
        let month = calendar.component(.month, from: date);
        let day = calendar.component(.day, from: date);
        return "\(month)/\(day)/\(year)";
    }
    
    static func epochToFormattedDateString(_ epoch: Int64) -> String{ // Month 00, 2000
        if (epoch == -1){
            return "NULL";
        }
        let date = Date(timeIntervalSince1970: TimeInterval(epoch));
        let year = calendar.component(.year, from: date);
        let month = calendar.component(.month, from: date);
        let day = calendar.component(.day, from: date);
        let monthStr = calendar.monthSymbols[month-1];
        return "\(monthStr) \(day), \(year)";
    }
    
}
