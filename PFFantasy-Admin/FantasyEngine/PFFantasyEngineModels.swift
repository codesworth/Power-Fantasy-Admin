//
//  PFFantasyModels.swift
//  PFFantasy-Admin
//
//  Created by Mensah Shadrach on 03/08/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Foundation


protocol PFValidates {
    func validates()->Bool
}



class EngineCorrectPicks{
    
    private var _questionID:String!
    private var _contestType:Int!
    private var _correctOption:Extras!
    private var _actualPoints:Extras!
    
    /**
     actualPoints
        questionNumner
            B.Griffin : 400
     */
    var questionID:String{
        return _questionID
    }
    
    var contestType:Int{
        return _contestType
    }
    var correctOption:Extras{
        return _correctOption
    }
    var actualPoints:Extras{
        return _actualPoints
    }
    
    init(questionID:String, type:Int, options:Extras, actual:Extras?) {
        _questionID = questionID
        _contestType = type
        _correctOption = options
        if type == CONTEST_REGULAR && actual != nil {
            _actualPoints = actual!
        }else if type == CONTEST_BLAZE && actual != nil{
           _actualPoints = JSON()
        }
        
    }
    
    convenience init(pick:CorrectPicks) {
        
        self.init(questionID: pick.id!, type: Int(pick.contestType), options: pick.getCorrectOptions() as Extras, actual: pick.getCorrectActuals())
    }
    

    
}

class PFEngineQuestionWrapper{
    private var _type:Int!
    private var _regualar:RegularQuestions?
    private var _blaze:BlazeQuestion?
    
    var type:Int{
        return _type
    }
    
    var regularQuestions:RegularQuestions?{
        return _regualar
    }
    
    var blazeQuestions:BlazeQuestion?{
        return _blaze
    }
    
    init(type:Int, regular:RegularQuestions?, blaze:BlazeQuestion?) {
        _type = type
        _regualar = regular
        _blaze = blaze
    }
}

class FantasyConsumable:Hashable{
    
    static func == (lhs: FantasyConsumable, rhs: FantasyConsumable) -> Bool {
        return lhs._id == rhs._id
    }
    
    var hashValue: Int {
        return _id.hashValue
    }
    
    
    private var _contest:Contest!
    private var _id:String!
    private var _allpicks:[PFPicks]!
    
    var contest:Contest{
        return _contest
    }
    
    var id:String{
        return _id
    }
    
    var allPicks:[PFPicks]{
        return _allpicks
    }
    init(contest:Contest,allpicks:[PFPicks]) {
        _contest = contest
        _allpicks = allpicks
        _id = contest.key!
    }
    
    convenience init(key:String, rawdata:Extras) {
        let contdata = rawdata["contest"] as! Extras
        let contest = CoreDatabase.service.createContestFrom(key: key, data: contdata)
        let pickdata = rawdata["picks"] as! Extras
        var allpiks:[PFPicks] = []
        for (key,value) in pickdata {
            let value = value as! Extras
            let aPick = PFPicks(rawData: value, key: key)
            allpiks.append(aPick)
        }
        self.init(contest: contest, allpicks: allpiks)
        
    }
}


class PFPicks{
    private var _username:String!
    private var _player_uid:String!
    private var _picks:Extras
    private var _selectedPoints:Extras
    private var _key:String!
    private var _contestKey:String!
    
    var picks:Extras{
        get{
            return _picks
        }
        set{
            _picks = newValue
        }
    }
    
    var contestKeys:String{
        return _contestKey
    }
    
    var selectedPoints:Extras{
        get{
            return _selectedPoints
        }
        set{
            _selectedPoints = newValue
        }
    }
    
    var playerID:String{
        return _player_uid
    }
    
    var username:String{
        return _username
    }

    
    var key:String{
        get{
            return _key
        }set{
            _key = newValue
        }
    }
    
    func validates()->Bool{
        if picks.count == selectedPoints.count{
            return true
        }
        return false
    }
    
    
    
    init(picks:Extras, points:Extras, key:String, contestKey:String, playerID:String,username:String) {
        _contestKey = contestKey
        _key = key
        _picks = picks
        _selectedPoints = points
        _player_uid = playerID
        _username = username
    }
    
    convenience init(rawData:Extras, key:String) {
        var conid:String = ""
        let picks = rawData[PICKS_ALL_PICKS_ID] as! Extras
        let points = rawData[PICKS_ALL_POINTS] as! Extras
        if let ex = rawData[FIELD_CONTEST_ID] as? String{
            conid = ex
        }else if let ex = rawData[FIELD_CONTEST_ID] as? Int{
            conid = String(ex)
        }
        assert(conid != "", "ContestID cannot be nil")
        let r = rawData[PICKS_PLAYER_ID] as! String
        //Swift.print("This nigga has no username: ",key)
        let username = rawData[_USERNAME] as! String
        self.init(picks: picks, points: points, key: key, contestKey:conid,playerID:r,username:username)
    }
}




class Leaderboard{
    private var _contestID:String!
    private var _positioning:[String:PFPositioning]
//    private var _playerid:String!
//    private var _wins:Double!
//    private var _points:Int!
//    private var _username:String
    //mz9r4QfLAJfr4zAtFB11
    
    var contestId:String{
        return _contestID
    }
    
    var positioning:[String:PFPositioning]{
        return _positioning
    }
    
    init(contestID:String, positioning:[String:PFPositioning]) {
        _contestID = contestID
        _positioning = positioning
    }
    
    func jsonify()->Extras{
        var ex:Extras = [:]
        for item in _positioning {
            ex[item.key] = item.value.jsonify()
        }
        return ex
    }
    
    
}


class PFPositioning{
    private var _pickId:String
    private var _relativePositon:Int!
    private var _playerid:String!
    private var _wins:Double!
    private var _points:Int!
    private var _username:String
    
    var relativePositon:Int{
        get{
            return _relativePositon
        }
        set{
            _relativePositon = newValue
        }
    }
    
    var pickId:String{
        return _pickId
    }
    var playerid:String{
        return _playerid
    }
    var wins:Double{
        get{
            return _wins
        }
        set{
            _wins = newValue
        }
    }
    var points:Int{
        return _points
    }
    var username:String{
        return _username
    }
    
    func jsonify()->Extras{
        return [
            R_POSITION: _relativePositon,
            PICKS_PLAYER_ID:playerid,
            _WINS:_wins,
            _POINTS:_points,
            _USERNAME:_username,
            PICK_ID: _pickId
            ] as Extras
    }
    
    init(playerid:String, points:Int, username:String,pickid:String) {
        _playerid = playerid
        _wins = 0.0
        _points = points
        _username = username
        _relativePositon = 0
        _pickId = pickid
    }
    
}


class ContestPayments:NSObject{
    static func == (lhs: ContestPayments, rhs: ContestPayments) -> Bool {
        return lhs._contestKey == rhs.contestKey
    }
    
//    var hashValue:Int{
//        return contestKey.hashValue
//    }
    
    
    
    private var _contestKey:String!
    private var _paymentLedger:[String:Double]!
    private var _maxSize:Int!
    private var _allpayables:[String:PFPositioning]
    var contestKey:String{
        return _contestKey
    }
    
    var paymentLedger:[String:Double]{
        return _paymentLedger
    }
    
    var allPayables:[String:PFPositioning]{
        return _allpayables
    }
    
    var maxSize:Int{
        return _maxSize
    }
    
    init(key:String, ledger:Dictionary<String,Double>, allPayables:[String:PFPositioning]) {
        _contestKey = key
        _paymentLedger = ledger
        _maxSize = allPayables.count
        _allpayables = allPayables
    }
    
    func contains(key:String)->Bool{
        for (pkey,_) in _paymentLedger {
            if key == pkey{
                return true
            }
        }
        return false
    }
    
    func getTotalFor(key:String)->Double{
        var retval = 0.0
        for (pkey,value) in _paymentLedger {
            if pkey == key{
                retval += value
            }
        }
        
        return retval
    }
    
    func numberOfOccurrenceOf(key:String)->Int{
        
        var occurs = 0
        for (pkey, _) in _allpayables{
            if(pkey == key){
                occurs += 1
            }
        }
        
        return occurs
    }
    

}


