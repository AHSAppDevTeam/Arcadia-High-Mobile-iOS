//
//  dataManager_credits.swift
//  AHS
//
//  Created by Richard Wei on 9/2/21.
//

import Foundation
import Firebase
import FirebaseDatabase

enum creditRole{
    case programmerWeb
    case programmerServer
    case programmerAndroid
    case programmeriOS
    
    case editor
    
    case designer
    
    case manager
    
    case none
}

struct creditData{
    var id: String = "";
    var name : String = "";
    var retired : Bool = false;
    var role : creditRole = .none;
    var url : URL? = nil;
}

extension dataManager{
    static public func getCreditsList(completion: @escaping ([creditData]) -> Void){
        dataRef.child("credits").observeSingleEvent(of: .value, with: { (snapshot) in
            
            var creditList : [creditData] = [];
            
            let enumerator = snapshot.children;
            while let person = enumerator.nextObject() as? DataSnapshot{
                
                creditList.append(parseCredit(person));
                
            }
            
            completion(creditList);
            
        });
    }
    
    static private func parseCredit(_ snapshot: DataSnapshot) -> creditData{
        var data = creditData();
        
        if (snapshot.exists()){
            let dataDict = snapshot.value as? NSDictionary;
            
            data.id = snapshot.key;
            
            data.name = dataDict?["name"] as? String ?? "";
            data.retired = dataDict?["dataDict"] as? Bool ?? false;
            data.role = parseCreditRole(dataDict?["role"] as? String ?? "");
            data.url = URL(string: dataDict?["url"] as? String ?? "");
            
        }
        
        return data;
    }
    
    static private func parseCreditRole(_ rawRole: String) -> creditRole{
        //print(rawRole);
        
        switch rawRole {
        case "editor":
            return .editor;
        case "designer":
            return .designer;
        case "manager":
            return .manager;
        case "programmer.web":
            return .programmerWeb;
        case "programmer.server":
            return .programmerServer;
        case "programmer.android":
            return .programmerAndroid;
        case "programmer.iOS":
            return .programmeriOS;
        default:
            return .none;
        }
        
    }
}
