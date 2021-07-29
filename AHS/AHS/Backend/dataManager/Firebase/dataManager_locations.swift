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
    var categoryIDs : [String] = [];
    var locationTitle : String = "";
}

extension dataManager{
    
    static public func getHomepageLocationData(completion: @escaping (locationData) -> Void){
        
        setupConnection();
        
        if (internetConnected){
            getLocationData(locationName: "homepage", completion: { (data) in
                completion(data);
            });
        }
        
    }
    
    static public func getCommunityLocationData(completion: @escaping (locationData) -> Void){
        
        setupConnection();
        
        if (internetConnected){
            getLocationData(locationName: "community", completion: { (data) in
                completion(data);
            });
        }
    }
    
    static public func getBulletinLocationData(completion: @escaping (locationData) -> Void){
        
        setupConnection();
        
        if (internetConnected){
            getLocationData(locationName: "bulletin", completion: { (data) in
                completion(data);
            });
        }
    }
    
    static internal func getLocationData(locationName: String, completion: @escaping (locationData) -> Void){
        
        if (checkValidString(locationName)){
            
            dataRef.child("locations").child(locationName).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if (snapshot.exists()){
                    
                    let locationDict = snapshot.value as? NSDictionary;
                    
                    var data : locationData = locationData();
                    
                    data.categoryIDs = locationDict?["categoryIDs"] as? [String] ?? [];
                    data.locationTitle = locationDict?["title"] as? String ?? "";
                    
                    completion(data);
                    
                }
                else{
                    print("location '\(locationName)' does not exist");
                }
                
            });
            
        }
        
    }
    
}
