//
//  nfcManager.swift
//  AHS
//
//  Created by Richard Wei on 7/17/22.
//

import Foundation
import CryptoKit
import CoreNFC
import UIKit
import SwiftMsgPack

class nfcManager : NSObject{
    
    static public let obj = nfcManager();
    
    //
    
    internal var nfcSession : NFCNDEFReaderSession? = nil;
    internal var nfcMessage : NFCNDEFMessage? = nil;
    
    //
    
    private override init(){
        super.init();
    }
    
    //
    
    /*guard let data = "HI".data(using: .ascii) else {return}
     for i in data{
     print(i);
     }
     //let data : [UInt8] = [34];
     let digest = SHA512.hash(data: (data));
     print(digest.bytes);*/
    
    private func isNFCAvailable() -> Bool{
        guard NFCNDEFReaderSession.readingAvailable else{
            let alertController = UIAlertController(
                title: "NFC Not Supported",
                message: "This device doesn't support NFC",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            AppUtility.presentAlertController(alertController);
            return false;
        }
        return true;
    }
    
    private func beginNFCSession(){
        nfcSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false);
        nfcSession?.alertMessage = "Hold your iPhone next to the NFC scanner.";
        nfcSession?.begin();
    }
    
    internal func generatePayload(){
        guard dataManager.getIsStudentSignedIn() else{
            nfcSession?.invalidate(errorMessage: "User not signed in.");
            return;
        }
        
        var idData = Data();
        do{
            let id = Int(dataManager.getIDFromStudentEmail(dataManager.getSignedInUserData()?.profile?.email ?? "") ?? "");
            try idData.pack(id);
        }
        catch{
            nfcSession?.invalidate(errorMessage: "Unable to generate ID payload.");
            return;
        }
                
        guard let nfcSaltString = Bundle.main.infoDictionary?["nfcsalt"] as? String else{
            nfcSession?.invalidate(errorMessage: "Invalid NFC configuration");
            return;
        }
        
        let nfcsalt = nfcSaltString.split(separator: " ").compactMap { UInt8($0) };
        
        let prehashData = dataManager.convertDataToAUInt8(idData) + nfcsalt;
                
        let hashedData = SHA256.hash(data: Data(prehashData)).data;
                
        let hashedDataArray = dataManager.convertDataToAUInt8(hashedData);
        
        let splitHashedDataArray = Array(ArraySlice<UInt8>(hashedDataArray[0..<hashedDataArray.count/2]));
        
        //print(dataManager.convertDataToAUInt8(hashedData.data))
        
        generateNFCPayload(dataManager.convertAUInt8ToData(splitHashedDataArray), idData);
    }
    
    internal func generateNFCPayload(_ hashedData: Data, _ idData: Data){
        /*let textPayload = NFCNDEFPayload.wellKnownTypeTextPayload(
            string: "https://ahs.app/",
            locale: Locale(identifier: "EN")
        )*/
        
        //print("hashed size = \(hashedData.count), idData = \(idData.count)")
        
        let hashedPayload = NFCNDEFPayload(format: .nfcExternal, type: "a:h".data(using: .ascii)!, identifier: "a".data(using: .ascii)!, payload: hashedData);
        let idDataPayload = NFCNDEFPayload(format: .nfcExternal, type: "a:d".data(using: .ascii)!, identifier: "a".data(using: .ascii)!, payload: idData);
        
        nfcMessage = NFCNDEFMessage(records: [hashedPayload, idDataPayload]);
        
        //print("message size = \(nfcMessage?.length)");
    }
    
    //
    
    public func initNFC(){
        if (dataManager.getIsStudentSignedIn() && isNFCAvailable()){
            generatePayload();
            beginNFCSession();
            
        }
    }
    
}
