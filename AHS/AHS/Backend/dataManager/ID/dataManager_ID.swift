//
//  dataManager_ID.swift
//  AHS
//
//  Created by Richard Wei on 8/2/21.
//

import Foundation
import UIKit
import Firebase

extension dataManager{
    
    static public func isValidStudentEmail(_ email: String) -> Bool{
        let pattern = "^[0-9]{5}@students.ausd.net$";
        let regex = try! NSRegularExpression(pattern: pattern);
        return regex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.utf16.count)) != nil;
    }
    
}
