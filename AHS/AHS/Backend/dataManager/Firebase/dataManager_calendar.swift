//
//  dataManager_calendar.swift
//  AHS
//
//  Created by Richard Wei on 9/16/21.
//

import Foundation
import UIKit
import Firebase

struct weekCalendarData{
    var id : String = "";
    var scheduleIDs : [String] = [];
    var title : String = "";
}

struct scheduleCalendarData{
    var id : String = "";
    var color : Color = Color(red: 0, green: 0, blue: 0, alpha: 1);
    var periodIDs : [String] = [];
    var timestamps : [Int] = [];
    var title : String = "";
}

extension dataManager{
    
    static private func getWeekListData(_ weekIDList: [String], completion: @escaping ([weekCalendarData]) -> Void){
        
        setupConnection();
        
        if (internetConnected){
           
            DispatchQueue.global(qos: .background).async {
                
                let dispatchGroup = DispatchGroup();
                
                var list : [weekCalendarData] = [];
                
                for weekID in weekIDList{
                                        
                    dispatchGroup.enter();

                    getWeekData(weekID, completion: { (data) in
                        
                        list.append(data);
                        
                        dispatchGroup.leave();
                        
                    });
                    
                }
                
                dispatchGroup.wait();

                DispatchQueue.main.async {
                    completion(list);
                }
                
            }
            
        }
        
    }
    
    static private func getWeekIDList(completion: @escaping ([String]) -> Void){
        
        setupConnection();
        
        if (internetConnected){
            
            dataRef.child("weekIDs").observeSingleEvent(of: .value, with: { (snapshot) in
                
                var weekIDList : [String] = Array(repeating: "", count: 53);
                
                if (snapshot.exists()){
                    
                    let enumerator = snapshot.children;
                    while let week = enumerator.nextObject() as? DataSnapshot{
                        
                        guard let weekNum = Int(week.key) else{
                            print("Invalid week number detected - \(week.key)");
                            continue;
                        }
                        
                        weekIDList[weekNum] = (week.value as? String ?? "");
                    }
                    
                    completion(weekIDList);
                    
                }
                
            });
            
        }
        
    }
    
    static private func getWeekData(_ weekID: String, completion: @escaping (weekCalendarData) -> Void){
        
        setupConnection();
        
        if (internetConnected && !weekID.isEmpty){
            
            dataRef.child("weeks").child(weekID).observeSingleEvent(of: .value, with: { (snapshot) in
                
                var data : weekCalendarData = weekCalendarData();
                
                if (snapshot.exists()){
                    
                    let dataDict = snapshot.value as? NSDictionary;
                    
                    data.id = weekID;
                    
                    data.scheduleIDs = dataDict?["scheduleIDs"] as? [String] ?? [];
                    data.title = dataDict?["title"] as? String ?? "";
                    
                    completion(data);
                    
                }
                
            });
            
        }
        
    }
    
    //
    
    static private func getScheduleData(_ scheduleID: String, completion: @escaping (scheduleCalendarData) -> Void){
        
        setupConnection();
        
        if (internetConnected && !scheduleID.isEmpty){
            
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
    
}
