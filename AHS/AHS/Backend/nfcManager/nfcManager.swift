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
    
    private func getNFCSalt() -> [UInt]?{
        let nfcsaltstr = Bundle.main.infoDictionary?["nfcsalt"] as? String;
        let nfcsalt = nfcsaltstr?.components(separatedBy: .whitespaces).compactMap{ UInt($0) };
        return nfcsalt;
    }
    
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
            try idData.pack(dataManager.getIDFromStudentEmail(dataManager.getSignedInUserData()?.profile?.email ?? ""));
        }
        catch{
            nfcSession?.invalidate(errorMessage: "Unable to generate ID payload.");
            return;
        }
        
        guard let nfcSaltString = Bundle.main.infoDictionary?["nfcsalt"] as? String else{
            nfcSession?.invalidate(errorMessage: "Invalid nfc configuration");
            return;
        }
        
        let nfcsalt = nfcSaltString.split(separator: " ").compactMap { UInt8($0) };
        
        let hashedData = SHA256.hash(data: Data(dataManager.convertDataToAUInt8(idData) + nfcsalt));
        
        generateNFCPayload(hashedData.data, idData);
    }
    
    internal func generateNFCPayload(_ hashedData: Data, _ idData: Data){
        /*let textPayload = NFCNDEFPayload.wellKnownTypeTextPayload(
            string: "https://ahs.app/",
            locale: Locale(identifier: "EN")
        )*/
        
        //print("generating nfc payload")
        
        let hashedPayload = NFCNDEFPayload(format: .nfcExternal, type: "nfc_h".data(using: .ascii)!, identifier: "ahs".data(using: .ascii)!, payload: hashedData);
        let idDataPayload = NFCNDEFPayload(format: .nfcExternal, type: "nfc_d".data(using: .ascii)!, identifier: "ahs".data(using: .ascii)!, payload: idData);
        
        nfcMessage = NFCNDEFMessage(records: [hashedPayload, idDataPayload]);
    }
    
    //
    
    public func initNFC(){
        if (dataManager.getIsStudentSignedIn() && isNFCAvailable()){
            beginNFCSession();
        }
    }
    
}
