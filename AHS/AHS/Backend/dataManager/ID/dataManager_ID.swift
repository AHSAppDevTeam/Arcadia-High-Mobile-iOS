//
//  dataManager_ID.swift
//  AHS
//
//  Created by Richard Wei on 8/2/21.
//

import Foundation
import UIKit
import Firebase
import RSBarcodes_Swift
import AVFoundation

extension dataManager{
    
    static public func isValidStudentEmail(_ email: String) -> Bool{
        let pattern = "^[0-9]{5}@students.ausd.net$";
        let regex = try! NSRegularExpression(pattern: pattern);
        return regex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.utf16.count)) != nil;
    }
    
    static public func getIDBarcode(_ s: String) -> UIImage{
        return RSUnifiedCodeGenerator.shared.generateCode(s, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code39.rawValue) ?? UIImage();
    }
    
    static public func getIDFromStudentEmail(_ email: String) -> String?{
        guard isValidStudentEmail(email) else{
            return nil;
        }
        return String(email.prefix(5));
    }
    
}
