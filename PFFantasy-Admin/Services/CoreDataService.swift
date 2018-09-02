//
//  CoreDataService.swift
//  PFFantasy-Admin
//
//  Created by Mensah Shadrach on 2/15/18.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Foundation
import CoreData

class CoreDatabase {
    
    private static let _service = CoreDatabase()
    
    static var service:CoreDatabase{
        return _service
    }
    
    
    func cacheUnIndexedTransaction(_ key:String, _ obj:Any){


    }
    
    func fetchBlaze()->[BlazeQuestion]{
        var blazes = [BlazeQuestion]()
        var returnedblazes = [BlazeQuestion]()
        let fetchRequest = NSFetchRequest<BlazeQuestion>(entityName: String(describing:BlazeQuestion.self))
    
        do {
            blazes = try CoreDataStack.persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error {
            log("Error occurred with sig. \(error.localizedDescription)")
        }
        for item in blazes {
            
            if item.timestamp > Date().unixTimestamp(){
                returnedblazes.append(item)
            }
        }
        return returnedblazes
    }
    func fetchRegular()->[RegularQuestions]{
        var regulars = [RegularQuestions]()
        var returnedreg = [RegularQuestions]()
        let fetchRequest = NSFetchRequest<RegularQuestions>(entityName: String(describing:RegularQuestions.self))
        
        do {
            regulars = try CoreDataStack.persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error {
            log("Error occurred with sig. \(error.localizedDescription)")
        }
        for item in regulars {
            
            if item.timestamp > Date().unixTimestamp(){
                returnedreg.append(item)
            }
        }

        return returnedreg
    }
    
    
    
    func trimAllLeagues(){
        let alls = fetchRegular()
        for item in alls {
            var nitems = item.getOptions()
            nitems.removeValue(forKey: "ts")
            item.options = nitems as NSObject
            CoreDataStack.saveContext()
            
        }
    }
    
    func fetchLogs()->[Logs]{
        var sgroup = [Logs]()
        let fetchRequest = NSFetchRequest<Logs>(entityName: String(describing:Logs.self))
        
        do {
            sgroup = try CoreDataStack.persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error {
            log("Error occurred with sig. \(error.localizedDescription)")
        }
        return sgroup
    }
    
    func fetchAdmins()->[Admins]{
        var sgroup = [Admins]()
        let fetchRequest = NSFetchRequest<Admins>(entityName: String(describing:Admins.self))
        
        do {
            sgroup = try CoreDataStack.persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error {
            log("Error occurred with sig. \(error.localizedDescription)")
        }
        return sgroup
    }
    
    
    func fetchAllColors()->[TeamColor]{
        var sgroup = [TeamColor]()
        let fetchRequest = NSFetchRequest<TeamColor>(entityName: String(describing:TeamColor.self))
        
        do {
            sgroup = try CoreDataStack.persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error {
            log("Error occurred with sig. \(error.localizedDescription)")
        }
        return sgroup
    }
    
    func fetchAnswer(id:String)->CorrectPicks?{
        
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: CorrectPicks.self))
        let sortDesc = NSSortDescriptor(key: "timestamp", ascending: false)
        fetchReq.sortDescriptors = [sortDesc]
        let pred = NSPredicate(format: "%K = %@", "id", id)
        fetchReq.predicate = pred
        do {
            let corr = try CoreDataStack.persistentContainer.viewContext.fetch(fetchReq) as! [CorrectPicks]
            return corr.first
        } catch let error {
            Swift.print("Error Occurred")
            alert(title: "Coredata Error", message: error.localizedDescription)
        }
        return nil
    }
    
    func fetchContestsBy(an id:String) -> [Contest]{
        let sumn:[Contest] = []
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Contest.self))
        let sortDesc = NSSortDescriptor(key: "timestamp", ascending: false)
        fetchReq.sortDescriptors = [sortDesc]
        let pred = NSPredicate(format: "%K = %@", "key", id)
        fetchReq.predicate = pred
        do {
            let corr = try CoreDataStack.persistentContainer.viewContext.fetch(fetchReq) as! [Contest]
            return corr
        } catch let error {
            Swift.print("Error Occurred")
            alert(title: "Coredata Error", message: error.localizedDescription)
        }
        return sumn
    }
    
    func fetchEntityBy(an id:String, for property:FetchPropertyKeys,with objectName:String) -> [NSManagedObject]{
        let sumn:[NSManagedObject] = []
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: objectName)
        let sortDesc = NSSortDescriptor(key: property.rawValue, ascending: false)
        fetchReq.sortDescriptors = [sortDesc]
        let pred = NSPredicate(format: "%K = %@", property.rawValue, id)
        fetchReq.predicate = pred
        do {
            let corr = try CoreDataStack.persistentContainer.viewContext.fetch(fetchReq) as! [NSManagedObject]
            return corr
        } catch let error {
            Swift.print("Error Occurred")
            alert(title: "Coredata Error", message: error.localizedDescription)
        }
        return sumn
    }
    
    func createNewPlayer(largedata:Extras,h:(_ success:Bool,_ keys:[String])->()){
        var progress = false
        var list:[String] = []
        for (key, value) in largedata{
            let player = Players(context: CoreDataStack.getContext())
            if let value = value as? Extras{
                if let pvalue = value["data"] as? Extras{
                    player.uid = key
                    let ts = pvalue[_CREATED] as! Int
                    player.created = Date.init(timeIntervalSince1970: TimeInterval(ts))
                    player.username = pvalue[_USERNAME] as? String
                    if let acval = value["account"] as?  Extras{
                        let account = CXFCreditAccount(context: CoreDataStack.getContext())
                        account.accountNo = pvalue[FIELD_ACC_ID] as? String
                        account.accountPhone = acval[FIELD_PHONE] as? String
                        account.accountUserID = key
                        account.aggregatedCredit = acval[FIELD_AGGRE_CREDIT_] as! Double
                        account.aggregatedGains  = acval[FIELD_AGGRE_GAIN] as! Double
                        account.aggregatedLosses = acval[FIELD_AGGRE_LOSS] as! Double
                        account.balance = acval[FIELD_CREDIT_BALANCE] as! Double
                        account.virtualCoins = acval[FIELD_VIRT_BALANCE] as! Double
                        account.mutated = acval[FIELD_MUTATED] as! Bool
                        account.name = acval[FIELD_FULL_NAME] as? String
                        let lastup = acval[FIELD_LAST_UP] as? Int
                        if(lastup != nil){
                            account.lastUpdated = Date.init(timeIntervalSince1970: (TimeInterval(lastup! / 1000)))
                        }else{
                            account.lastUpdated = Date()
                        }
                        account.player = player
                        player.creditAccount = account
                        CoreDataStack.saveContext()
                        list.append(key)
                        progress = true
                    }
                }
            }
        }
        h(progress,list)
    }
    
    func createContestFrom(key:String, data:Extras)->Contest{
        
        let cap = data[_ENTRY_CAP] as! Int64
        let fee = data[_FEE] as! Double
        let laegue = data[_LEAGUE_TYPE] as! String
        let maxE = data[_MAX_ENTRY] as! Int64
        let name = data[_CONTEST_NAME] as! String
        let payT = data[_PAYMENT_TYPE] as! Int32
        let numcon = data[_NO_CONTESTANTS] as! Int32
        let status = data[_STATUS] as! Int32
        let qid = data[_QUESTION_ID] as! String
        let ts = data[_TS] as! Int64
        let type = data[_TYPE] as! Int32
        let price = data[_PRICE] as! Double
        let fetched = fetchContestsBy(an: key)
        var contest:Contest!
        if fetched.isEmpty {
            contest = Contest(context: CoreDataStack.persistentContainer.viewContext)
            contest.key = key
            contest.cap = cap
            contest.fee = fee
            contest.sport = laegue
            contest.maxEntry = maxE
            contest.priceMoney = price
            contest.timestamp = ts
            contest.questionID = qid
            contest.title = name
            contest.contestType = type
            contest.status = status
            contest.numberOfContestants = numcon
            contest.paymentType = payT
        }else{
            contest = fetched.first!
            contest.key = key
            contest.cap = cap
            contest.fee = fee
            contest.sport = laegue
            contest.maxEntry = maxE
            contest.priceMoney = price
            contest.timestamp = ts
            contest.questionID = qid
            contest.title = name
            contest.contestType = type
            contest.status = status
            contest.numberOfContestants = numcon
            contest.paymentType = payT
        }
        
        CoreDataStack.saveContext()
        return contest
    }
    
    func fetchPlayer(uid:String)->Players?{
        
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Players.self))
        let sortDesc = NSSortDescriptor(key: "timestamp", ascending: false)
        fetchReq.sortDescriptors = [sortDesc]
        let pred = NSPredicate(format: "%K = %@", "key", uid)
        fetchReq.predicate = pred
        do {
            let corr = try CoreDataStack.persistentContainer.viewContext.fetch(fetchReq) as! [Players]
            return corr.first
        } catch let error {
            Swift.print("Error Occurred")
            alert(title: "Coredata Error", message: error.localizedDescription)
        }
        return nil
    }
    
    
    func updateWinningAccounts(ledger:ContestPayments)->Extras{
        var updated:Extras = [:]
        
        for (key, value) in ledger.paymentLedger {
            let player = fetchPlayer(uid: key)
            if player != nil{
                let account = player!.creditAccount
                account?.balance += value
                account?.lastUpdated = Date()
                updated[key] = true
                player?.creditAccount = account
                CoreDataStack.saveContext()
            }
        }
        
        return updated
    }
    
    func createTransactionForWinsAndUpdateAccounts(winnings:ContestPayments)->[String:CXFCreditAccount]?{
        var extras:[String:CXFCreditAccount] = [:]
        var contest:Contest?
        let contests = fetchContestsBy(an: winnings.contestKey)
        if !contests.isEmpty && contests.count == 1 {contest = contests.first!}else{
            alert(title: "FATAL", message: "Multiple contests with same id: Consider Revisions")
            return nil
        }
        Swift.print("This is AllPauyables: ",winnings.allPayables)
        for (_,value) in winnings.allPayables {
            let account = fetchEntityBy(an: value.playerid, for: FetchPropertyKeys.accountPlayerid, with: String(describing: CXFCreditAccount.self)) as? [CXFCreditAccount]
            if account != nil && account!.count == 1{}else{return nil}
            let acc = account!.first!
            Swift.print("The balance is: ",acc)
            let trans =  CXTransaction(context: CoreDataStack.getContext())
            trans.accountId = acc.accountNo
            trans.amount = value.wins
            
            trans.indexed = false
            trans.cluid = value.playerid
            trans.finalDetail = "Winnings from \(contest!.title!) contest"
            trans.id = String(Int64(Date().timeIntervalSince1970 * 100))
            trans.date = Date()
            trans.transactionMode = TRANSACTION_MODE.CONTEST_WINS.rawValue
            trans.transactionType = TRANSACTION_TYPE.CREDIT.rawValue
            trans.status = STATUS.COMPLETED.rawValue
            if (contest!.paymentType == ContestPaymentType.CASH.rawValue){
                acc.balance = acc.balance + value.wins
                trans.balance = acc.balance
                trans.currencyType = Int32(CURRENCY_TYPE.CASH.rawValue)
                acc.lifetimePoints += Int64(pointsworker(points: value.points, fee: contest!.fee))
            }else if(contest?.paymentType == ContestPaymentType.VIRTUAL.rawValue){
                acc.virtualCoins = acc.virtualCoins + value.wins
                trans.balance = acc.virtualCoins
                trans.currencyType = CURRENCY_TYPE.VIRTUAL.rawValue
                
            }else{
                return nil
            }
            Swift.print("The final balance is: ",acc)
            extras[acc.accountNo!] = acc
            CoreDataStack.saveContext()
            
        }
        
        return extras
    }
    
    func pointsworker(points:Int,fee:Double)->Int{
        let p = fee * Double(points)
        let n = p/10000
        return Int(n)
    }
    
    func sycronizeAccounts(data:Extras)->Bool{
       
        var didSave = false
        for (key,value) in data{
            let value = value as! Extras
            if let accholder = fetchEntityBy(an: key, for: .creditAccountId, with: String(describing: CXFCreditAccount.self)) as? [CXFCreditAccount]{
                if !accholder.isEmpty{
                    let acc = accholder.first!
                    acc.balance = value[FIELD_CREDIT_BALANCE] as! Double
                    acc.lastUpdated = Date()
                    acc.mutated = value[FIELD_MUTATED] as! Bool
                    acc.aggregatedCredit = value[FIELD_AGGRE_CREDIT_] as! Double
                    acc.virtualCoins = value[FIELD_VIRT_BALANCE] as! Double
                    CoreDataStack.saveContext()
                    
                    didSave = true
                }
            }
        }

        return didSave

    }
    
    func fetchUnIndexedTransactions()->[CXTransaction]?{
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: CXTransaction.self))
        let sortDesc = NSSortDescriptor(key: "indexed", ascending: false)
        fetchReq.sortDescriptors = [sortDesc]
        let pred = NSPredicate(format:"indexed == false")
        fetchReq.predicate = pred
        do {
            let corr = try CoreDataStack.persistentContainer.viewContext.fetch(fetchReq) as! [CXTransaction]
            return corr
        } catch let error {
            Swift.print("Error Occurred")
            alert(title: "Coredata Error", message: error.localizedDescription)
        }
        return nil
    }
    
    func fetchEntitiesByKeys(keys:Dictionary<String,Double>.Keys)->[CXFCreditAccount]{
        var accs:[CXFCreditAccount] = []
        for key in keys {
            let obj = fetchEntityBy(an: key, for: FetchPropertyKeys.creditAccountId, with: String(describing: CXFCreditAccount.self))
            
            if(!obj.isEmpty && obj as? [CXFCreditAccount] != nil){
                let cr = obj.first!
                accs.append(cr as! CXFCreditAccount)
            }
        }
        return accs
    }
    
    func deleteAllObjects(){
        let fr:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: String(describing: CXTransaction.self));
        let dele = NSBatchDeleteRequest(fetchRequest: fr)
        
        do{
            try CoreDataStack.persistentContainer.persistentStoreCoordinator.execute(dele, with: CoreDataStack.getContext())
        }catch let err{
            Swift.print("Error occurred: ",err.localizedDescription)
        }
    }
    
    func correct(){
        let questions = fetchBlaze()
        for ques in questions {
            print(ques.description)
            if ques.id! == "BLZEPLQuestion0010"{
               ques.timestamp = 1543622400000
                CoreDataStack.saveContext()
            }else if ques.id! == "BLZEPLQuestion0011"{
                CoreDataStack.getContext().delete(ques)
                CoreDataStack.saveContext()
            }
        }
        
    }
}


