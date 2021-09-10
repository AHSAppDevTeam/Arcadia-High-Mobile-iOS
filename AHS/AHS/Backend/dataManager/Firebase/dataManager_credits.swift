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
    
    public func getTitleString() -> String{
        switch self {
        case .programmerWeb:
            return "Web Programmer";
        case .programmerServer:
            return "Server Programmer";
        case .programmerAndroid:
            return "Android Programmer";
        case .programmeriOS:
            return "iOS Programmer";
        case .editor:
            return "Content Editor";
        case .designer:
            return "Graphic Designer";
        case .manager:
            return "Manager";
        default:
            return "";
        }
    }
    
}

struct creditCategory{
    var title : String = "";
    var list : [creditData] = [];
    
    static public func getCategoryList() -> [String]{
        return ["Programmers", "Graphic Designer", "Content Editors", "Managers", "Former Members"];
    }
    
    static public func getCategoryIndex(_ role: creditRole) -> Int{
        switch role {
        case .programmerWeb:
            return 0;
        case .programmerServer:
            return 0;
        case .programmerAndroid:
            return 0;
        case .programmeriOS:
            return 0;
        case .editor:
            return 2;
        case .designer:
            return 1;
        case .manager:
            return 3;
        default:
            return 4;
        }
    }
    
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
            data.retired = dataDict?["retired"] as? Bool ?? false;
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
        case "programmer.ios":
            return .programmeriOS;
        default:
            return .none;
        }
        
    }
}
