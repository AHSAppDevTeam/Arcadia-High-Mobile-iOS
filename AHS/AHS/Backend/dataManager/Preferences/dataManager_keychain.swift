//
//  dataManager_keychain.swift
//  AHS
//
//  Created by Richard Wei on 4/15/23.
//

import Foundation
import UIKit
import KeychainSwift

extension dataManager{
    internal static func saveKeychainString(_ key: String, _ value: String){
        keychain.set(value, forKey: key);
    }
    
    internal static func saveKeychainBool(_ key: String, _ value: Bool){
        keychain.set(value, forKey: key);
    }
    
    internal static func saveKeychainData(_ key: String, _ value: Data){
        keychain.set(value, forKey: key);
    }
    
    internal static func getKeychainString(_ key: String) -> String?{
        return keychain.get(key);
    }
    
    internal static func getKeychainBool(_ key: String) -> Bool?{
        return keychain.getBool(key);
    }
    
    internal static func getKeychainData(_ key: String) -> Data?{
        return keychain.getData(key);
    }
    
    internal static func removeKeychainValue(_ key: String){
        keychain.delete(key);
    }
}
