//
//  EncryptUtil.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 12/21/15.
//  Copyright © 2015 SL Studio. All rights reserved.
//

import Foundation

extension String{
    static var iv: NSData? = nil
    
    var md5: String! {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CUnsignedInt(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        
        CC_MD5(str!, strLen, result)
        var hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.dealloc(digestLen)
        return String(format:hash as String)
    }
    
    func encryptWith(algorithm: SymmetricCryptorAlgorithm,key: String) -> String?{
        let cypher = SymmetricCryptor(algorithm: algorithm, options: kCCOptionPKCS7Padding)
        if String.iv == nil {
            cypher.setRandomIV()
            String.iv = cypher.iv
        }else{
            cypher.iv = String.iv
        }
        
        do {
            //let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
            let cypherText = try cypher.crypt(string: self, key: key)
            print("\(cypherText)")
            
            return cypherText.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        } catch {
            return nil
        }
    }
    
    func decryptWith(algorithm: SymmetricCryptorAlgorithm, key: String) -> String? {
        let cypher = SymmetricCryptor(algorithm: algorithm, options: kCCOptionPKCS7Padding)
        if String.iv == nil {
            cypher.setRandomIV()
            String.iv = cypher.iv
        }else{
            cypher.iv = String.iv
        }
        do{
            
            let cypherData = NSData.init(base64EncodedString: self, options: NSDataBase64DecodingOptions(rawValue: 0))
            print("encrypted:\(cypherData)")
            let clearData = try cypher.decrypt(cypherData!, key: key)
            
            return String(data: clearData, encoding: NSUTF8StringEncoding)
        }catch{
            return nil
        }
    }
}