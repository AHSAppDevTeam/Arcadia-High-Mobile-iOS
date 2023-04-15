//
//  authManager.swift
//  AHS
//
//  Created by Richard Wei on 4/14/23.
//

import Foundation
import LocalAuthentication
import UIKit

class authManager : NSObject{
    static public let obj = authManager();
    
    //
    
    internal let ctx = LAContext();
    
    //
    
    private override init(){
        super.init();
    }
    
    //
    
    public func authenticate(_ vc: UIViewController, completion: @escaping (Error?) -> Void){
        var err: NSError?;
        if (ctx.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &err)){
            ctx.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: touchIDAuthenticationReason){ success, authenticationError in // face id auth reason is in info.plist
                if (success){
                    completion(nil);
                }
                else{
                    completion(authenticationError);
                    createAlertPrompt(vc, "Authentication Failed", "Please try again.");
                }
            }
        }
        else{
            completion(err);
            createAlertPrompt(vc, "Face ID/Touch ID not supported", "Your device is not configured for biometric authentication.");
        }
    }
    
    
}
