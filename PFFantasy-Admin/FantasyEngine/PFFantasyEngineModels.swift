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

class FantasyConsumable{
    
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
        let contest = CoreService.service.createContestFrom(key: key, data: contdata)
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
        let username = rawData[_USERNAME] as! String
        self.init(picks: picks, points: points, key: key, contestKey:conid,playerID:r,username:username)
    }
}


class Leaderboard{
    private var _contestID:String!
    private var _positioning:[String:Positioning]
//    private var _playerid:String!
//    private var _wins:Double!
//    private var _points:Int!
//    private var _username:String
    
    var contestId:String{
        return _contestID
    }
    
    var positioning:[String:Positioning]{
        return _positioning
    }
    
    init(contestID:String, positioning:[String:Positioning]) {
        _contestID = contestID
        _positioning = positioning
    }
    
    func jsonify()->Extras{
        var ex:Extras = [:]
        for item in _positioning {
            ex[item.key] = item.value.jsonify()
        }
        return ["key":contestId,"data":ex]
    }
    
    
}


class Positioning{
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
            _USERNAME:_username
            ] as Extras
    }
    
    init(playerid:String, points:Int, username:String) {
        _playerid = playerid
        _wins = 0.0
        _points = points
        _username = username
        _relativePositon = 0
    }
}
