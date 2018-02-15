//
//  KeyChainService.swift
//  PFFantasy-Admin
//
//  Created by Mensah Shadrach on 2/15/18.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Foundation
import Security
import CoreServices


class AuthenticationService {
    
    private static let _main = AuthenticationService()
    
    static var main:AuthenticationService{
        return _main
    }
    
    func addPassswordDataToStore(passPointer:UnsafeRawPointer, lenght:UInt32)-> OSStatus{
        var status:OSStatus
        status = SecKeychainAddGenericPassword(nil, 9, "CXfantasy", 14, "CXAdminShadrach", lenght, passPointer, nil)
        return status
    }
    
    func getPassword(length:UnsafeMutablePointer<UInt32>, passdata:UnsafeMutablePointer<UnsafeMutableRawPointer?>?)-> OSStatus{
        
        let status = SecKeychainFindGenericPassword(nil, 9, "CXfantasy", 14, "CXAdminShadrach", length, passdata, nil)
        return status
    }
    

    
}
