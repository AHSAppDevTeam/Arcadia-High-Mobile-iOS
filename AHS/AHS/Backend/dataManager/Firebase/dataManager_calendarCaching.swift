//
//  dataManager_calendarCaching.swift
//  AHS
//
//  Created by Richard Wei on 10/13/21.
//

import Foundation
import UIKit
import Firebase


extension dataManager{

    struct calendarCacheData : Codable{
        
        internal init(){};

        var scheduleCache : [String : scheduleCalendarData] = [:]{
            didSet{
                dataManager.saveCalendarCacheData();
            }
        }
        var weekDataForWeekNumCache : [Int : weekCalendarData] = [:]{
            didSet{
                dataManager.saveCalendarCacheData();
            }
        }
    }
    
    //
    
    static internal func getScheduleIDList(completion: @escaping ([String]) -> Void){
        
        setupConnection();
        
        if (internetConnected){
            
            dataRef.child("scheduleIDs").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if (snapshot.exists()){
                    
                    guard let scheduleIDList = snapshot.value as? [String] else{
                        return;
                    }
                    
                    completion(scheduleIDList);
                    
                }
                
            });
            
        }
        
    }
    
    static internal func getScheduleData(_ scheduleID: String, _ shouldGetFreshData: Bool = false, completion: @escaping (scheduleCalendarData) -> Void){
        
        if (checkValidString(scheduleID)){
            
            let cachedData = getCachedScheduleData(scheduleID)
            if !shouldGetFreshData && cachedData != nil{
                completion(cachedData!);
            }
            else{
                setupConnection();
                
                if (internetConnected){
                    
                    dataRef.child("schedules").child(scheduleID).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        var data : scheduleCalendarData = scheduleCalendarData();
                        
                        if (snapshot.exists()){
                            
                            let dataDict = snapshot.value as? NSDictionary;
                            
                            data.id = scheduleID;
                            
                            data.title = dataDict?["title"] as? String ?? "";
                            data.timestamps = dataDict?["timestamps"] as? [Int] ?? [];
                            data.periodIDs = dataDict?["periodIDs"] as? [String] ?? [];
                            data.color = Color.init(hex: dataDict?["color"] as? String ?? "");
                            
                            updateScheduleCache(scheduleID, data);
                            
                            completion(data);
                            
                        }
                        else{
                            print("scheduleID \(scheduleID) does not exist");
                        }
                        
                    });
                    
                }
            }
        }
        
    }
    
    
    /*static internal func cacheScheduleData(_ scheduleID: String, completion: @escaping (scheduleCalendarData) -> Void){
        
        getScheduleData(scheduleID, completion: { (scheduleData) in
            
            scheduleCache[scheduleID] = scheduleData;
            
            completion(scheduleData);
            
        });
        
    }*/
    
    static internal func updateScheduleCache(_ scheduleID: String, _ scheduleData: scheduleCalendarData){
        dataManager.calendarCache.scheduleCache[scheduleID] = scheduleData;
    }
    
    static internal func resetScheduleCache(){
        dataManager.calendarCache.scheduleCache = [:];
    }
    
    static public func getCachedScheduleData(_ scheduleID: String) -> scheduleCalendarData?{
        return dataManager.calendarCache.scheduleCache[scheduleID];
    }
    
    ///
    
    static internal func getWeekDataForWeekNum(_ weekNum: Int, _ shouldGetFreshData: Bool = false, completion: @escaping (weekCalendarData) -> Void){ // 1 based
        
        let cachedData = getCachedWeekData(weekNum);
        if !shouldGetFreshData && cachedData != nil{
            completion(cachedData!);
        }
        else{
            
            setupConnection();
            
            if (internetConnected && weekNum >= 1){
                
                dataRef.child("weekIDs").child("\(weekNum - 1)").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    guard let weekID = snapshot.value as? String else{
                        return;
                    }
                    
                    getWeekData(weekID, nil, completion: { (weekdata, _) in
                        
                        updateWeekDataForWeekNumCache(weekNum, weekdata);
                        
                        completion(weekdata);
                        
                    });
                    
                });
                
            }
        }
        
    }
    
    static internal func updateWeekDataForWeekNumCache(_ weekNum: Int, _ weekData: weekCalendarData){
        dataManager.calendarCache.weekDataForWeekNumCache[weekNum] = weekData;
    }
    
    static internal func resetWeekDataForWeekNumCache(){
        dataManager.calendarCache.weekDataForWeekNumCache = [:];
    }
    
    static public func getCachedWeekData(_ weekNum: Int) -> weekCalendarData?{
        return dataManager.calendarCache.weekDataForWeekNumCache[weekNum];
    }
    
    ///
    
    static internal func saveCalendarCacheData(){
        DispatchQueue.global(qos: .background).async {
            do{
                dataManager.saveUserDefault(dataManager.calendarCacheKey, try dataManager.jsonEncoder.encode(dataManager.calendarCache));
            }
            catch{
                print("error encoding calendar cache data - no data was saved");
            }
        }
    }
    
    ///
    
    static public func getTodaySchedule(completion: @escaping (scheduleCalendarData) -> Void){ // needs to be cached
                
        getWeekDataForWeekNum(timeManager.iso.getWeekInt(), completion: { (weekdata) in
            
            let dayOfWeek = timeManager.iso.getDayOfWeekInt();
            
            guard dayOfWeek > -1 && dayOfWeek < weekdata.scheduleIDs.count else{
                return;
            }
                        
            getScheduleData(weekdata.scheduleIDs[dayOfWeek], completion: { (scheduledata) in
                
                completion(scheduledata);
                
            });
            
        });
    }
    
}
