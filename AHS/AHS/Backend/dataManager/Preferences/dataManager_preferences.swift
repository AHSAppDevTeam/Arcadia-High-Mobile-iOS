//
//  dataManager_preferences.swift
//  AHS
//
//  Created by Richard Wei on 4/12/21.
//

import Foundation
import UIKit

extension dataManager{
    
    struct appUserPreferences : Codable{
        
        internal init(){};
        
        //
        
        var fontSize : Int = 18{
            didSet{
                dataManager.savePreferences();
            }
        }
        
        var savedArticlesDict : [String : fullArticleData] = [:]{
            didSet{
                dataManager.savePreferences();
            }
        }
        
        //
        
        var savedArticlesSortPreference : savedSortingStruct = savedSortingStruct(){
            didSet{
                dataManager.savePreferences();
            }
        }
        
        //
        
        var notificationsSortPreference : notificationSortingStruct = notificationSortingStruct(){
            didSet{
                dataManager.savePreferences();
            }
        }
        
        var notificationsReadDict : [String : Bool] = [:]{
            didSet{
                dataManager.savePreferences();
            }
        }
        
    }
    
    public static func loadPreferences(){
        if let rawData = dataManager.getUserDefault(dataManager.preferencesKey) as? Data{
            
            do{
                dataManager.preferencesStruct = try dataManager.jsonDecoder.decode(appUserPreferences.self, from: rawData);
            }
            catch{
                print("error decoding preferences data");
            }
            
        }
    }
    
    public static func savePreferences(){
    
        DispatchQueue.global(qos: .background).async {
            do{
                dataManager.saveUserDefault(dataManager.preferencesKey, try dataManager.jsonEncoder.encode(dataManager.preferencesStruct));
            }
            catch{
                print("error encoding preferences data - no data was saved");
            }
        }
        
    }
    
}
