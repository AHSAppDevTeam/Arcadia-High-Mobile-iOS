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
        nfcSession?.alertMessage = "Hold your iPhone near an NFC reader.";
        nfcSession?.begin();
    }
    
    internal func generateNFCPayload(){
        let textPayload = NFCNDEFPayload.wellKnownTypeTextPayload(
            string: "https://ahs.app/",
            locale: Locale(identifier: "EN")
        )
        nfcMessage = NFCNDEFMessage(records: [textPayload!]);
    }
    
    //
    
    public func initNFC(_ studentID: String){
        if (studentID.count != 5 && Int(studentID) != nil){
            print("Invalid studentID passed to nfc function \(studentID)")
            return;
        }
        
        if (isNFCAvailable()){
            beginNFCSession();
        }
    }
    
}
