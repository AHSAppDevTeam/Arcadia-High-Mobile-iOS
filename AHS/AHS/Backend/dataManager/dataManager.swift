//
//  dataManager.swift
//  AHS
//
//  Created by Richard Wei on 3/17/21.
//

import Foundation
import Firebase
import FirebaseDatabase

class dataManager{
    static internal var dataRef : DatabaseReference!;
    static public var internetConnected = false;
    
    static internal var categoryLookupMap : [String : categoryData] = [:];
    
    static public func setupConnection(){
        if (Reachability.isConnectedToNetwork()){
            internetConnected = true;
            Database.database().goOnline();
            dataRef = Database.database().reference();
        }
        else{
            internetConnected = false;
            Database.database().goOffline();
        }
    }
}
