//
//  nfcManager.swift
//  AHS
//
//  Created by Richard Wei on 7/17/22.
//

import Foundation
import CryptoKit
import CoreNFC

class nfcManager : NSObject{
    static public let obj = nfcManager();
    
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
    
}
