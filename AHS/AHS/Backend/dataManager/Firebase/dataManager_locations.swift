//
//  dataManager_locations.swift
//  AHS
//
//  Created by Richard Wei on 3/18/21.
//

import Foundation
import Firebase
import FirebaseDatabase

struct locationData{
    var catagoryIDs : [String] = [];
    var locationTitle : String = "";
}

extension dataManager{
    
    static public func getHomepageLocationData(){ 
        
    }
    
    static internal func getLocationData(locationName: String, completion: @escaping (String) -> Void){
        
        
        
    }
    
}
