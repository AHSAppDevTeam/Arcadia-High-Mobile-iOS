//
//  dataManager_calendarScheduleCaching.swift
//  AHS
//
//  Created by Richard Wei on 10/13/21.
//

import Foundation
import UIKit
import Firebase

struct scheduleCalendarData{
    var id : String = "";
    var color : Color = Color(red: 0, green: 0, blue: 0, alpha: 1);
    var periodIDs : [String] = [];
    var timestamps : [Int] = [];
    var title : String = "";
}

extension dataManager{
    
    static internal func getScheduleIDList(completion: @escaping ([String]) -> Void){
        
        setupConnection();
        
        if (internetConnected){
            
            dataRef.child("scheduleIDs").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if (snapshot.exists()){
                    
                    //print(snapshot.value)
                    
                    guard let scheduleIDList = snapshot.value as? [String] else{
                        return;
                    }
                    
                    completion(scheduleIDList);
                    
                }
                
            });
            
        }
        
    }
    
    static internal func getScheduleData(_ scheduleID: String, completion: @escaping (scheduleCalendarData) -> Void){
        
        setupConnection();
        
        if (internetConnected && checkValidString(scheduleID)){
            
            dataRef.child("schedules").child(scheduleID).observeSingleEvent(of: .value, with: { (snapshot) in
                
                var data : scheduleCalendarData = scheduleCalendarData();
                
                if (snapshot.exists()){
                    
                    let dataDict = snapshot.value as? NSDictionary;
                    
                    data.id = scheduleID;
                    
                    data.title = dataDict?["title"] as? String ?? "";
                    data.timestamps = dataDict?["timestamps"] as? [Int] ?? [];
                    data.periodIDs = dataDict?["periodIDs"] as? [String] ?? [];
                    data.color = Color.init(hex: dataDict?["color"] as? String ?? "");
                    
                    completion(data);
                    
                }
                
            });
            
        }
        
    }
    
    
    static internal func cacheScheduleData(_ scheduleID: String, completion: @escaping (scheduleCalendarData) -> Void){
        
        getScheduleData(scheduleID, completion: { (scheduleData) in
            
            scheduleCache[scheduleID] = scheduleData;
            
            completion(scheduleData);
        
        });
        
    }
    
    static internal func resetScheduleCache(){
        scheduleCache = [:];
    }
    
    static public func getCachedScheduleData(_ scheduleID: String) -> scheduleCalendarData{
        return scheduleCache[scheduleID] ?? scheduleCalendarData();
    }
    
}
