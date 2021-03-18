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
}
