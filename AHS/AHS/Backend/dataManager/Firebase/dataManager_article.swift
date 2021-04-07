//
//  dataManager_article.swift
//  AHS
//
//  Created by Richard Wei on 4/6/21.
//

import Foundation
import Firebase
import FirebaseDatabase

struct fullArticleData{
    var author : String = "";
    var body : String = "";
    var categoryID : String = "";
    var title : String = "";
    
    var views : Int64 = 0;
    var timestamp : Int64 = 0;
    
    var featured : Bool = false;
    var notified : Bool = false;
    
    var imageURLs : [String] = [];
    var thumbURLs : [String] = [];
    var videoIDs : [String] = [];
}

struct previewArticleData{
    var categoryID : String = "";
    var title : String = "";
    
    var timestamp : Int64 = 0;
    //var views : Int64 = 0; // might not be needed
    
    var thumbURLs : [String] = [];
}

extension dataManager{
    
    static public func getFullArticleData(_ id: String, completion: @escaping (fullArticleData) -> Void){
        
        
    }
    
    static public func getPreviewArticleData(_ id: String, completion: @escaping (previewArticleData) -> Void){
        
        
    }
    
    
    
}
