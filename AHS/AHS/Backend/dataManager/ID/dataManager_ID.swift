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
    
    static public func getIsStudentSignedIn() -> Bool{
        return isValidStudentEmail(getSignedInUserData()?.profile?.email ?? "");
    }
    
    static public func isValidStudentEmail(_ email: String) -> Bool{
        let regex = try? NSRegularExpression(pattern: #"^[0-9]{5}@(students(old)?\.)?ausd\.net$"#);
        return (regex?.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.utf16.count)) != nil) || (email == testIDEmail);
    }
    
    static public func getIDBarcode(_ s: String) -> UIImage{
        return RSUnifiedCodeGenerator.shared.generateCode(s, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code39.rawValue) ?? UIImage();
    }
    
    static public func getIDFromStudentEmail(_ email: String) -> String?{
        guard isValidStudentEmail(email) else{
            return nil;
        }
        return (email == testIDEmail ? testIDString : String(email.prefix(5)));
    }
    
    static public func splitFullName(_ name: String) -> String{
        var s : String = "";
        var flag : Bool = true;
        for c in name{
            if (c.isWhitespace && flag){
                s.append("\n");
                flag = false;
            }
            else{
                s.append(c);
            }
        }
        return s;
    }
    
    static public func saveIDLockedState(_ id: IDButton){ // will commit id card locked state to keychain
        saveKeychainBool(idLockedStateKey, id.idState == .isLocked);
    }
    
    static public func getIsIDLocked() -> Bool{
        return getKeychainBool(idLockedStateKey) ?? false;
    }
}
