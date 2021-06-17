//
//  dataManager_userDefaults.swift
//  AHS
//
//  Created by Richard Wei on 6/16/21.
//

import Foundation
import UIKit

extension dataManager{
    internal static func saveUserDefault(_ key: String, _ value: Any){
        UserDefaults.standard.setValue(value, forKey: key);
    }
    
    internal static func getUserDefault(_ key: String) -> Any?{
        return UserDefaults.standard.value(forKey: key);
    }
}
