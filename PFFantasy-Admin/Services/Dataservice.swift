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

typealias FetchedPicksCompletion = ()->()

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
    

    func uploadContest(_ key:String, _ data:Extras,leaguedata:Extras, handler:@escaping(_ success:Bool, _ err:Error?, _ extra:String )->()){
        let url:URLConvertible = URL(string: URL_CONTESTS)!
        let param = ["key":key, "data":data, "lgdata":leaguedata] as [String : Any];
        //log("The key is \(key)");
        Alamofire.request(url, method: .post, parameters:param, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            if response.result.isSuccess {
                handler(true, nil,response.result.description)
                Swift.print("Succesfully poasted: ", response.result.debugDescription)
            }
        }
    }
    
    func uploadQuestion(_ key:String, _ data:Extras, handler:@escaping(_ success:Bool, _ err:Error?, _ extra:String )->()){
        let url:URLConvertible = URL(string: URL_QUESTIONS)!
        let param = ["key":key, "data":data] as [String : Any];
        //log("The key is \(key)");
        Alamofire.request(url, method: .post, parameters:param, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            if response.result.isSuccess {
                handler(true, nil,response.result.description)
                Swift.print("Succesfully poasted: ", response.result.debugDescription)
            }
        }
    }
    
    func postCorrectPick(data:Extras, handler:@escaping(_ success:Bool, _ err:Error?, _ extra:String )->()){
        let url:URLConvertible = URL(string: URL_POST_ALL_CORRECT_PICKS)!
        
        Alamofire.request(url, method: .post, parameters: data, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            if response.result.isSuccess {
                handler(true, nil,response.result.description)
                Swift.print("Succesfully poasted: ", response.result.debugDescription)
            }else{
                handler(response.result.isSuccess,response.error,response.result.description)
            }
        }
    }
    
    func postLeaderbaord(data:Extras, handler:@escaping(_ success:Bool, _ err:Error?, _ extra:String )->()){
        let url:URLConvertible = URL(string: URL_POST_LEADERBOARD)!
        
        Alamofire.request(url, method: .post, parameters: data, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            if response.result.isSuccess {
                handler(true, nil,response.result.description)
                Swift.print("Succesfully poasted: ", response.result.debugDescription)
            }else{
                handler(false, response.error,"")
            }
        }
    }
    
    // TODO: - CHECK who is connected
    
    func getTransactions(){
        let url:URLConvertible = URL(string: PATH_TRANSACT)!
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            if let data = response.value as? Extras{
                log(data.debugDescription)
                for (key, value) in data{
                    CoreService.service.makeTransaction(key, value)
                }
            }
        }
    }
    
    
    
    
    func getAllPicks(handler:@escaping(_ success:Bool, _ err:Error?, _ data:Any? )->()){
         let url:URLConvertible = URL(string: URL_GET_ALL_PICKS)!
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (dataresponse) in
            log("We git here");
            print(dataresponse)
            handler(dataresponse.result.isSuccess, dataresponse.result.error, dataresponse.result.value)
            
        }
    }
}
