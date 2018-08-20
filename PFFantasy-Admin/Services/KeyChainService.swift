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
import KeychainAccess

enum AccessLevel:String{
    
    case root = "CXFantasyDomain.root"
    case user = "CXFantasy.user"
    case noAccess = "CXFantasy.noAcess"
}


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
    
     func createRootUser(username:String, password:String){
        let kc = Keychain(service: AccessLevel.root.rawValue)
        kc[username] = password
        Swift.print("Succesfully created Root admin")
    }
    
    func createUser(username:String, password:String){
        let kc = Keychain(service: AccessLevel.user.rawValue)
        kc[username] = password
    }
    
    func updatePasswordFor(username:String, oldpass:String, newPass:String)->(NSError?, Bool){
        let res = retrieveUserAccount(username: username, password: oldpass)
        if res.0{
            let kc = Keychain(service: AccessLevel.user.rawValue)
            kc[username] = newPass
            Log.log(statement: "User \(username) password successfully changed", domain: LoggerDomain.preferencePain.rawValue)
            log("Succesfully updated user password")
            return (nil, true)
        }else{
            let err = NSError(domain: LoggerDomain.authDomain.rawValue, code: 0, userInfo:["m":"Unmatching older password"])
            return (err, false)
        }
        
    }
    
    func retrieveUserAccount(username:String, password:String)->(Bool,AccessLevel?){
        let keychain = Keychain(service: AccessLevel.user.rawValue)
        do {
            let token =  try keychain.get(username)
            Swift.print("The token is: ", token ?? "No Token");
            if token != nil{
                if token! == password{
                    
                    return (true, AccessLevel.user)
                }else{
                    return (false,AccessLevel.noAccess)
                }
            }
        } catch let error  {
            Swift.print(error)
            return (false,AccessLevel.noAccess)
        }
        return (false,AccessLevel.noAccess)
    }
    
    func retrieveAccount(username:String, password:String)->(Bool,AccessLevel?){
       let keychain = Keychain(service: AccessLevel.root.rawValue)
        do {
            
             let token =  try keychain.get(username)
            Swift.print("The token is: ", token ?? "No Token");
            if token != nil{
                if token! == password{
                    return (true, AccessLevel.root)
                }else{
                   return (false,AccessLevel.noAccess)
                }
            }
        } catch let error  {
            Swift.print(error)
            return (false,AccessLevel.noAccess)
        }
        return (false,AccessLevel.noAccess)
    }
    
    

    
}



