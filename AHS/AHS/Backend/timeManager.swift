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
    
    static private var dateObj :  () -> Date = {
        return Date();
    }
    
    static private let numberSuffixesString = "|st|nd|rd|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|st|nd|rd|th|th|th|th|th|th|th|st";
    static public let numberSuffixes = numberSuffixesString.split(separator: "|");
    
    static public let dayOfWeekStrings = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]; // in regular format (need translation for iso format)
    
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
    
    
    // singleton objects
    
    static public let regular = timeManager(calendar: Calendar.current);
    static public let iso = timeManager(calendarType: .iso8601);
    
    //
    
    internal var calendar : Calendar = Calendar.current;
    
    //
    
    private init(calendarType: Calendar.Identifier){
        self.calendar = Calendar(identifier: calendarType);
    }
    
    private init(calendar: Calendar){
        self.calendar = calendar;
    }
    
    //
    
    public func getMonthString(_ date: Date = dateObj()) -> String{
        let monthInt = calendar.dateComponents([.month], from: date).month;
        return calendar.monthSymbols[monthInt!-1];
    }
    
    public func getYearString(_ date: Date = dateObj()) -> String{
        return String(self.calendar.component(.year, from: date));
    }

    public func getDateString(_ date: Date = dateObj()) -> String{
        return String(self.calendar.component(.day, from: date));
    }
    
    public func getDateInt(_ date: Date = dateObj()) -> Int{
        return self.calendar.component(.day, from: date);
    }
    
    public func getDateSuffix(_ date: Date = dateObj()) -> String{
        let index = getDateInt(date) - 1;
        guard index > -1 && index < timeManager.numberSuffixes.count else{
            print("invalid date index for date suffix");
            return "";
        }
        return timeManager.getNumberSuffix(index);
    }
    
    static public func getNumberSuffix(_ num: Int) -> String{
        guard num < timeManager.numberSuffixes.count else{
            return "";
        }
        return String(timeManager.numberSuffixes[num]);
    }
    
    public func getWeekInt(_ date: Date = dateObj()) -> Int{ // 1 based
        return self.calendar.component(.weekOfYear, from: date);
    }
    
    public func getDayOfWeekInt(_ date: Date = dateObj()) -> Int{ // 1 based
        let dayOfWeek = self.calendar.component(.weekday, from: date);
        return calendar.identifier == .iso8601 ? (dayOfWeek == 1 ? 7 : dayOfWeek - 1) : dayOfWeek;
    }
    
    static public func getDayOfWeekString(_ date: Date = dateObj()) -> String{
        return timeManager.dayOfWeekStrings[timeManager.regular.getDayOfWeekInt(date) - 1];
    }
    
    //
    
    public func getDateFromMinSinceMidnight(_ minutes: Int) -> Date{
        let dateUnixEpoch = calendar.startOfDay(for: Date()).timeIntervalSince1970;
        return Date(timeIntervalSince1970: dateUnixEpoch + Double((minutes * 60)));
    }
    
    public func getMinSinceMidnightFromDate(_ date: Date = dateObj()) -> Int{
        let midnightUnixEpoch = calendar.startOfDay(for: date).timeIntervalSince1970;
        return Int(floor((date.timeIntervalSince1970 - midnightUnixEpoch) / 60));
    }
    
    public func getFormattedTimeString(_ date: Date = dateObj()) -> String{
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "hh:mm a";
        return dateFormatter.string(from: date);
    }
    
    //
    
    static public func getCurrentEpoch() -> Int64{
        return Int64(NSDate().timeIntervalSince1970);
    }
    
    static public func epochToDiffString(_ epoch: Int64) -> String{ // 1 hour ago
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
    
    static public func epochToDateString(_ epoch: Int64) -> String{ // 99/99/99
        if (epoch == -1){
            return "NULL";
        }
        let date = Date(timeIntervalSince1970: TimeInterval(epoch));
        let year = Calendar.current.component(.year, from: date);
        let month = Calendar.current.component(.month, from: date);
        let day = Calendar.current.component(.day, from: date);
        return "\(month)/\(day)/\(year)";
    }
    
    static public func epochToFormattedDateString(_ epoch: Int64) -> String{ // Month 00, 2000
        if (epoch == -1){
            return "NULL";
        }
        let date = Date(timeIntervalSince1970: TimeInterval(epoch));
        let year = Calendar.current.component(.year, from: date);
        let month = Calendar.current.component(.month, from: date);
        let day = Calendar.current.component(.day, from: date);
        let monthStr = Calendar.current.monthSymbols[month-1];
        return "\(monthStr) \(day), \(year)";
    }
    
}
