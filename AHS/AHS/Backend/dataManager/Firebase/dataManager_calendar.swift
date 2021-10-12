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
    var scheduleIDs : [String] = []; // starts from 1 - first element is empty
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
    
    static public func loadCalendarData(completion: @escaping () -> Void){ // 52 or 53 weeks
        
        setupConnection();
        
        if (internetConnected){
            
            getWeekIDList(completion: { (idList) in
                
                getWeekListData(idList, completion: { (weekList) in
                    
                    calendarData = Array(repeating: [], count: weekList.count); // set array size to week count
                    
                    DispatchQueue.global(qos: .background).async {
                        
                        let dispatchGroup = DispatchGroup();
                        
                        for i in 0..<weekList.count{
                            
                            guard weekList[i].scheduleIDs.count == 8 else{
                                print("invalid week day count for week \(i)");
                                continue;
                            }
                            
                            calendarData[i] = Array(repeating: scheduleCalendarData(), count: 7);
                            
                            for j in 1..<weekList[i].scheduleIDs.count{ // scheduleIDs array has 8 elements with the first element always being empty
                                
                                let scheduleID = weekList[i].scheduleIDs[j];
                                
                                print(scheduleID);
                                
                                dispatchGroup.enter();
                                
                                getScheduleData(scheduleID, completion: { (scheduledata) in
                                    
                                    calendarData[i][j-1] = scheduledata;
                                    
                                    dispatchGroup.leave();
                                    
                                });
                                
                            }
                            
                        }
                        
                        dispatchGroup.wait();
                        
                        DispatchQueue.main.async {
                            completion();
                        }
                        
                    }
                    
                });
                
            });
            
        }
        
    }
    
    static public func getWeekScheduleData(_ weekNum: Int, completion: @escaping ([scheduleCalendarData]) -> Void){ // weekNum is 0 based from 0 - (51 or 52)
        
        guard weekNum < calendarData.count else{
            
            if (calendarData.count == 0){ // calendarData has not been loaded yet
                
                print("Calendar get function called without loading calendarData");
                
                loadCalendarData(completion: { () in
                    
                    getWeekScheduleData(weekNum, completion: { (weekdata) in
                        
                        completion(weekdata);
                        
                    });
                    
                });
                
            }
            else{
                print("invalid weeknum - \(weekNum)");
            }
            
            return;
        }
        
        completion(calendarData[weekNum]);
        
    }
    
    static public func getWeekScheduleData(_ date: Date, completion: @escaping ([scheduleCalendarData]) -> Void){
        
        getWeekScheduleData(timeManager.getWeekInt(date) - 1, completion: { (weekdata) in
            completion(weekdata);
        });
        
    }
    
    static public func getDayScheduleData(_ weekNum: Int, _ dayNum: Int, completion: @escaping (scheduleCalendarData) -> Void){ // 0 based for weekNum and dayNum
        
        getWeekScheduleData(weekNum, completion: { (weekdata) in
            
            guard dayNum < weekdata.count else{
                print("dayNum index \(dayNum) is out of range of \(weekdata.count)");
                return;
            }
            
            completion(weekdata[dayNum]);
            
        });
        
    }
    
    static public func getDayScheduleDate(_ date: Date, completion: @escaping (scheduleCalendarData) -> Void){
        
        getDayScheduleData(timeManager.getWeekInt(date) - 1, timeManager.getDayOfWeekInt(date) - 1, completion: { (scheduledata) in
            
            completion(scheduledata);
            
        });
        
    }
    
    //
    
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
        
        if (internetConnected && checkValidString(weekID)){
            
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
    
}
