//
//  dataManager_calendar.swift
//  AHS
//
//  Created by Richard Wei on 9/16/21.
//

import Foundation
import UIKit
import Firebase

struct weekCalendarData : Codable{
    var id : String = "";
    var scheduleIDs : [String] = []; // starts from 1 - first element is empty
    var title : String = "";
}

struct scheduleCalendarData : Codable{
    var id : String = "";
    var color : Color = Color.convertUIColor(BackgroundGrayColor);
    var periodIDs : [String] = [];
    var timestamps : [Int] = [];
    var title : String = "";
}

extension dataManager{
    
    static public func loadCalendarData(completion: @escaping () -> Void){ // 52 or 53 weeks
        
        setupConnection();
        
        if (internetConnected){
            
            DispatchQueue.global(qos: .background).async {
                
                let dispatchGroup = DispatchGroup();
                
                dispatchGroup.enter();
                
                //
                
                getWeekIDList(completion: { (idList) in
                    
                    getWeekListData(idList, completion: { (weekList) in
                        
                        calendarIDData = Array(repeating: Array(repeating: "", count: 7), count: weekList.count); // set array size to week count
                        
                        
                        for i in 0..<weekList.count{
                            
                            let scheduleIDCount = weekList[i].scheduleIDs.count;
                            
                            guard scheduleIDCount == 8 else{
                                print("invalid week day count for week \(i)");
                                continue;
                            }
                            
                            for j in 1..<scheduleIDCount{
                                calendarIDData[i][j-1] = weekList[i].scheduleIDs[j];
                            }
                            
                        }
                        
                        dispatchGroup.leave();
                        
                    });
                    
                });
                
                //
                
                resetScheduleCache();
                
                dispatchGroup.enter();
                
                getScheduleIDList(completion: { (scheduleIDList) in
                                    
                    for scheduleID in scheduleIDList{
                        
                        dispatchGroup.enter();
                        
                        getScheduleData(scheduleID, true, completion: { (_) in
                            
                            dispatchGroup.leave();
                            
                        });
                        
                    }
                    
                    dispatchGroup.leave();
                    
                });
                
                
                //
                
                dispatchGroup.wait();
                
                DispatchQueue.main.async {
                    completion();
                }
                
            }
            
        }
        
    }
    
    static public func resetCalendarCache(){
        resetScheduleCache();
        resetWeekDataForWeekNumCache();
    }
    
    static public func getDayScheduleData(_ weekNum: Int, _ dayNum: Int, completion: @escaping (scheduleCalendarData) -> Void){ // 0 based for weekNum and dayNum
        
        /*getWeekScheduleData(weekNum, completion: { (weekdata) in
            
            guard dayNum < weekdata.count else{
                print("dayNum index \(dayNum) is out of range of \(weekdata.count)");
                return;
            }
            
            //completion(weekdata[dayNum]);
            
        });*/
        
        guard weekNum > -1 && weekNum < calendarIDData.count else{
            //print("weekNum index \(weekNum) is out of range of \(calendarIDData.count) in day lookup");
            return;
        }
        
        guard dayNum > -1 && dayNum < calendarIDData[weekNum].count else{
            //print("dayNum index \(dayNum) is out of range of \(calendarIDData[weekNum].count) in day lookup");
            return;
        }
        
        completion(getCachedScheduleData(calendarIDData[weekNum][dayNum]) ?? scheduleCalendarData());
        
    }
    
    static public func getDayScheduleData(_ date: Date, completion: @escaping (scheduleCalendarData) -> Void){
        
        getDayScheduleData(timeManager.iso.getWeekInt(date) - 1, timeManager.iso.getDayOfWeekInt(date) - 1, completion: { (scheduledata) in
            
            completion(scheduledata);
            
        });
        
    }
    
    //
    
    static private func getWeekListData(_ weekIDList: [String], completion: @escaping ([weekCalendarData]) -> Void){
        
        setupConnection();
        
        if (internetConnected){
            
            DispatchQueue.global(qos: .background).async {
                
                let dispatchGroup = DispatchGroup();
                
                var list : [weekCalendarData] = Array(repeating: weekCalendarData(), count: weekIDList.count);
                
                for i in 0..<weekIDList.count{
                    
                    dispatchGroup.enter();
                    
                    getWeekData(weekIDList[i], i, completion: { (data, weekNum) in
                        
                        guard let weekNum = weekNum else {
                            return;
                        }
                        
                        guard weekNum < weekIDList.count else{
                            print("weekNum \(weekNum) returned from getWeekData is out of bounds of \(weekIDList.count)");
                            return;
                        }
                        
                        list[weekNum] = data;
                        
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
                            
                if (snapshot.exists()){
                                    
                    var weekIDList : [String] = Array(repeating: "", count: Int(snapshot.childrenCount));
                    
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
    
    static internal func getWeekData(_ weekID: String, _ index: Int? = nil, completion: @escaping (weekCalendarData, Int?) -> Void){
        
        setupConnection();
        
        if (internetConnected && checkValidString(weekID)){
            
            dataRef.child("weeks").child(weekID).observeSingleEvent(of: .value, with: { (snapshot) in
                
                var data : weekCalendarData = weekCalendarData();
                
                if (snapshot.exists()){
                    
                    let dataDict = snapshot.value as? NSDictionary;
                    
                    data.id = weekID;
                    
                    data.scheduleIDs = dataDict?["scheduleIDs"] as? [String] ?? [];
                    data.title = dataDict?["title"] as? String ?? "";
                    
                    completion(data, index);
                    
                }
                
            });
            
        }
        
    }
    
    static public func getWeekScheduleData(_ weekNum: Int, completion: @escaping ([scheduleCalendarData]) -> Void){ // weekNum is 0 based from 0 - (51 or 52)
        
        guard weekNum < calendarIDData.count else{
            
            if (calendarIDData.count == 0){ // calendarData has not been loaded yet
                
                print("Calendar get function called without loading calendarData");
                
                loadCalendarData(completion: { () in
                    
                    getWeekScheduleData(weekNum, completion: { (weekdata) in
                        
                        completion(weekdata);
                        
                    });
                    
                });
                
            }
            else{
                print("invalid weeknum - \(weekNum) in week lookup");
            }
            
            return;
        }
        
        var scheduleList : [scheduleCalendarData] = [];
        
        for scheduleID in calendarIDData[weekNum]{
            scheduleList.append(getCachedScheduleData(scheduleID) ?? scheduleCalendarData());
        }
        
        completion(scheduleList);
        
        //completion(calendarData[weekNum]);
        
    }
    
    static public func getWeekScheduleData(_ date: Date, completion: @escaping ([scheduleCalendarData]) -> Void){
        
        getWeekScheduleData(timeManager.iso.getWeekInt(date) - 1, completion: { (weekdata) in
            completion(weekdata);
        });
        
    }

    
}
