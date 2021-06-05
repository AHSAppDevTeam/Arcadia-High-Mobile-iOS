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
    static let dateObj = Date();
    static let calendar = Calendar.current;
    
    static func getMonthString() -> String{
        let monthInt = calendar.dateComponents([.month], from: dateObj).month;
        return calendar.monthSymbols[monthInt!-1];
    }

    static func getDateString() -> String{
        return String(calendar.component(.day, from: dateObj));
    }
    
    static func getCurrentEpoch() -> Int64{
        return Int64(NSDate().timeIntervalSince1970);
    }
    
    static func epochToDiffString(_ epoch: Int64) -> String{ // 1 hour ago
        if (epoch == -1){
            return "NULL";
        }
        let currTime = Int64(NSDate().timeIntervalSince1970);
        let diff = abs(currTime - epoch);
        let timePattern = [(1, "second"), (60, "minute"), (3600, "hour"), (86400, "day"), (604800, "week"), (2592000, "month"), (31536000, "year"), (315360000, "decade"), (3153600000, "century")];
        var r = "NULL";
        
        for i in 1..<timePattern.count{
            if (floor(Double(diff) / Double(timePattern[i].0)) == 0){
                let prefix = Int(floor(Double(diff) / Double(timePattern[i-1].0)));
                r = "\(prefix) " + timePattern[i-1].1 + (prefix > 1 ? "s" : "");
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
