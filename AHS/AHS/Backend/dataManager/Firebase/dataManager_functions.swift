//
//  dataManager_functions.swift
//  AHS
//
//  Created by Richard Wei on 6/11/21.
//

import Foundation
import Firebase
import FirebaseFunctions

extension dataManager{
    static public func incrementArticleView(_ articleID: String){
        
        if (checkValidString(articleID)){
            
            dataFunc.httpsCallable("incrementView").call(["id" : articleID]){ (_, error) in
                
                if let error = error as NSError?{
                    
                    if (error.domain == FunctionsErrorDomain){
                        
                        //let code = FunctionsErrorCode(rawValue: error.code);
                        print("incrementView call error - \(error.localizedDescription) - \(error.userInfo[FunctionsErrorDetailsKey])");
                        
                    }
                    
                }
                
            };
            
        }
    }
}
