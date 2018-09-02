//
//  PFEngine.swift
//  PFFantasy-Admin
//
//  Created by Mensah Shadrach on 04/08/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Foundation


class PFEngine {
    
    private static let _mainEngine = PFEngine()
    
    static var mainEngine:PFEngine{
        return _mainEngine
    }
    
    func makeConsumable(largeData:Extras)->[String:FantasyConsumable]{
        var retdata:[String:FantasyConsumable] = [:]
        for (key, value) in largeData{
            if let value = value as? Extras{
                let fsc = FantasyConsumable(key: key, rawdata: value)
                retdata[fsc.id] = fsc
            }
        }
        return retdata
    }
    
    
    
    func prepareEngine(){
        
        
    }
    func engineContestWinners(key:String, positioning:[String:Positioning]) ->[String:Positioning]{
        var newd:[String:Positioning] = [:]
        for (key,value) in positioning {
            if (value.wins < 1){}else{
               newd[key] = value
            }
        }
        return newd
    }
    func engineMakeContestPayments(key:String, positioning:[String:PFPositioning])->ContestPayments{
        var retval:[String:Double] = [:]
        for (_,value) in positioning {
            if (value.wins < 1){}else{
                var mywins = retval[value.playerid] ?? 0.0
                mywins += value.wins
                retval[value.playerid] = mywins
            }
        }
        var allPayables:[String:PFPositioning] = [:]
        for(key, value) in positioning{
            if(value.wins > 0){
                allPayables[key] = value
            }
        }
        let pay = ContestPayments(key:key , ledger: retval, allPayables: allPayables)
        return pay
        
    }
    
    func enginemakeAccountPayments(){
        
    }
    
    func engineStart(consumable:FantasyConsumable, rightPick:EngineCorrectPicks)->Leaderboard{
        let allPicks = consumable.allPicks
        var positioningArray:Array<PFPositioning> = [];
        let totalshares = Double(allPicks.count) * consumable.contest.fee
        if consumable.contest.contestType == CONTEST_REGULAR {
            for aPick in allPicks{
                let postioning = engineBlockWorkRegular(rightPick: rightPick, pick: aPick)
                positioningArray.append(postioning)
            }
            let sorted = engineSortPositions(positions: positioningArray)
            let sortedWins = findandSetWinnings(sortedPositions: sorted, totalshare: totalshares)
            let leaderboard = Leaderboard(contestID: consumable.contest.key!, positioning: sortedWins)
            return leaderboard
            
        }else{
            for aPick in allPicks{
                let postioning = engineBlockWorkBlaze(rightPick: rightPick, pick: aPick)
                positioningArray.append(postioning)
                
            }
            let sorted = engineSortPositions(positions: positioningArray)
            let sortedWins = findandSetWinnings(sortedPositions: sorted, totalshare: totalshares)
            let leaderboard = Leaderboard(contestID: consumable.contest.key!, positioning: sortedWins)
            return leaderboard
        }
        
    }
    
    private func engineSortPositions(positions:[PFPositioning])->[String:PFPositioning]{
        
        let sorted = positions.sorted(by: {$0.points > $1.points})
        let nsarray = NSArray(array: sorted)
        
        var sortedobjs:[String:PFPositioning] = [:]
        for obj in nsarray {
            let pos = nsarray.index(of: obj) + 1
            sortedobjs["\(pos)"] = obj as? PFPositioning
            
        }
        
        for (key, value) in sortedobjs{
            let ikey = Int(key)
            if ikey != nil{
                value.relativePositon = ikey!
            }
        }
        return sortedobjs
    }
    
    private func engineBlockWorkRegular(rightPick:EngineCorrectPicks,pick:PFPicks)->PFPositioning{
        //if pick.validates(){}else{return}
        var consolidatedpoints = 0
        let totalPoints = pick.selectedPoints
        let rightOptions = rightPick.correctOption
        let actuals = rightPick.actualPoints
        let options = pick.picks
        for (key,value) in  options{
            let actual = actuals[key] as! Extras
            let bpoint = actual[(value as! String)] as! Int
            consolidatedpoints = consolidatedpoints + bpoint
            let roption:String = rightOptions[key] as! String
            if (value as! String) == roption{
                let point = totalPoints[key] as! Int
                consolidatedpoints = consolidatedpoints + point
            }else{}
        }
        let ps = PFPositioning(playerid: pick.playerID,points: consolidatedpoints,username: pick.username,pickid: pick.key)
        return ps
        
    }
    
    private func engineBlockWorkBlaze(rightPick:EngineCorrectPicks,pick:PFPicks)->PFPositioning{
        //if pick.validates(){}else{return}
        var consolidatedpoints = 0
        var numberOfWins = 0
        let totalPoints = pick.selectedPoints
        let rightOptions = rightPick.correctOption
        let options = pick.picks
        for (key,value) in  options{
            let roption:String = rightOptions[key] as! String
            if (value as! String) == roption{
                numberOfWins = numberOfWins + 1
                let point = totalPoints[key] as! Int
                consolidatedpoints = consolidatedpoints + point
            }else{}
        }
        consolidatedpoints = consolidatedpoints + numberOfWins
        let ps = PFPositioning(playerid: pick.playerID,points: consolidatedpoints,username: pick.username, pickid: pick.key)
        return ps
        
    }
    
    
    private func findandSetWinnings(sortedPositions:[String:PFPositioning], totalshare:Double)->[String:PFPositioning]{
        let size = sortedPositions.count
        var newSorted:[String:PFPositioning] = [:]
        for (key, item) in sortedPositions{
            let plce = item.relativePositon - 1
            if plce > -1 {
                let winshare = percentage(index: plce, capacity: size)
                let myshare = winshare * totalshare
                item.wins = myshare
                newSorted[key] = item
            }else{
                fatalError("Invalid Player Positionings")
            }
        }
        return newSorted
    }
    
    
    private func percentage(index:Int, capacity:Int)->Double{
        if capacity > 40 {
            return tenModelPercentages(index: index)
        }else if capacity > 15{
            return fiveModelPercentage(index: index)
        }else{
            return threeModelPercentage(index: index)
        }
    }
    
    //For 50+
    private func tenModelPercentages(index:Int)->Double{
        switch index {
        case 0:
            return 0.30;
        case 1:
            return 0.20 ;
        case 2:
            return 0.10;
        case 3:
            return 0.075;
        case 4:
            return 0.055;
        case 5:
            return 0.045;
        case 6:
            return 0.040;
        case 7:
            return 0.035;
        case 8:
            return 0.030;
        case 9:
            return 0.020;
            
        default:
            return 0.0;
        }
    }
    
    //For the 20 model
    private func fiveModelPercentage(index:Int)->Double{
        switch index {
        case 0:
            return 0.40
        case 1:
            return 0.25
        case 2:
            return 0.15
        case 3:
            return 010
        case 4:
            return 0.05
        default:
            return 0.0
        }
    }
    
    
    //For 10 n less
    private func threeModelPercentage(index:Int)->Double{
        switch index {
        case 0:
            return 0.50
        case 1:
            return 0.30
        case 2:
            return 0.15
        default:
            return 0.0
        }
    }
        
    
}


/*
 
 */
