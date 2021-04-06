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
    
    static public func getHomepageLocationData(completion: @escaping (locationData) -> Void){
        
        setupConnection();
        
        getLocationData(locationName: "homepage", completion: { (data) in
            completion(data);
        });
        
    }
    
    static public func getCommunityLocationData(completion: @escaping (locationData) -> Void){
        
        setupConnection();
        
        getLocationData(locationName: "community", completion: { (data) in
            completion(data);
        });
        
    }
    
    static public func getBulletinLocationData(completion: @escaping (locationData) -> Void){
        
        setupConnection();
        
        getLocationData(locationName: "bulletin", completion: { (data) in
            completion(data);
        });
        
    }
    
    static internal func getLocationData(locationName: String, completion: @escaping (locationData) -> Void){
        
        dataRef.child("locations").child(locationName).observeSingleEvent(of: .value, with: { (snapshot) in
            
            var data : locationData = locationData();
            
            let enumerator = snapshot.children;
            
            while let content = enumerator.nextObject() as? DataSnapshot{
                
                if (content.key == "categoryIDs"){
                    
                    let idIt = content.children;
                    while let id = idIt.nextObject() as? DataSnapshot{
                        data.catagoryIDs.append(id.value as? String ?? "");
                    }
                    
                }
                else if (content.key == "title"){
                    
                    data.locationTitle = content.value as? String ?? "";
                    
                }
                
            }
            
            completion(data);
            
        });
        
    }
    
}
