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
    
    internal var context : LAContext? = nil;
    
    //
    
    private override init(){
        super.init();
    }
    
    //
    
    public func authenticate(_ vc: UIViewController = AppUtility.getTopMostViewController() ?? UIViewController(), completion: @escaping (Error?) -> Void){
        context = LAContext();
        if let ctx = context{
            var err: NSError?;
            if (ctx.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &err)){
                ctx.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: touchIDAuthenticationReason){ success, authenticationError in // face id auth reason is in info.plist
                    if (success){
                        self.context?.invalidate();
                        completion(nil);
                    }
                    else{
                        self.context?.invalidate();
                        DispatchQueue.main.async{
                            createAlertPrompt(vc, "Authentication Failed", "Please try again.");
                        }
                        completion(authenticationError);
                    }
                }
            }
            else{
                self.context?.invalidate();
                DispatchQueue.main.async{
                    createAlertPrompt(vc, "Face ID/Touch ID not supported", "Your device is not configured for biometric authentication.");
                }
                completion(err);
            }
        }
    }
    
    
}
