//
//  dataManager_layout.swift
//  AHS
//
//  Created by Richard Wei on 3/18/21.
//

import Foundation
import Firebase
import FirebaseDatabase

extension dataManager{
    static internal func getLayout(){
        dataRef.child("layout").observeSingleEvent(of: .value) { (snapshot) in
            
            print("observed");
            let enumerator = snapshot.children;
            
            while let section = enumerator.nextObject() as? DataSnapshot{ // iterate through 0, 1, ... , x
               
                print("section - \(section.key)")
                let sectionEnumerator = section.children;
                
                while let sectionAttributes = sectionEnumerator.nextObject() as? DataSnapshot{ // id, title, catagories
                   
                    //print("section attributes - \(sectionAttributes.key)")
                    
                    if (sectionAttributes.key == "id"){
                        print("id - \(sectionAttributes.value as? String ?? "")")
                    }
                    else if (sectionAttributes.key == "title"){
                        print("title - \(sectionAttributes.value as? String ?? "")")
                    }
                    else if (sectionAttributes.key == "categories"){
                        //let arr = sectionAttributes.value as? [DataSnapshot] ?? [];
                        print("categories size - \(sectionAttributes.childrenCount)")
                    }
                    
                }
                
            }
            
        }
    }
}
