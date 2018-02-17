//
//  Dataservice.swift
//  CXFantasy-Admin
//
//  Created by Mensah Shadrach on 7/30/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

import Foundation
import Alamofire

typealias JSON = Dictionary<String,AnyObject>

class Dataservice{
    
    static let service = Dataservice()
    
    func postTofirebase(key:String,data:JSON, path:String){
        let params = [key : data]
        let url:URLConvertible = URL(string:path)!
        
        Alamofire.request(url, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: nil).validate().responseString { (response) in
            print("Hey the response: ", response.debugDescription)
        }
    }
    
    func getUsers(){
        let url = URL(string:"http://localhost:3000/api/v1/NewUsers")
        Alamofire.request(url!, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (resp) in
            log(resp.debugDescription)
        
        }
    }
    
    // TODO: - CHECK who is connected
    
}
