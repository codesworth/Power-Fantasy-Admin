//
//  CoreDataService.swift
//  PFFantasy-Admin
//
//  Created by Mensah Shadrach on 2/15/18.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Foundation
import CoreData

class CoreService {
    
    private static let _service = CoreService()
    
    static var service:CoreService{
        return _service
    }
    
    
    func makeTransaction(_ key:String, _ obj:Any){
        let data = obj as! Extras
        let transaction = CXFAccountTransaction(context: CoreDataStack.persistentContainer.viewContext)
        let account = CXFCreditAccount(context: CoreDataStack.persistentContainer.viewContext)
        let ledge = CXFLTransaction(context: CoreDataStack.persistentContainer.viewContext)
        transaction.cluid = data[TRANSAC_CLIENT_ID] as? String
        let type = data[TRANSAC_TYPE] as! Int
        let pmeth = data[TRANSAC_PAYMETH] as! Int
        let accN = data[TRANSAC_ACC_NAME] as! String
        let tamount = data[TRANSAC_AMOUNT] as! Double
        let status = data[TRANSAC_STATUS] as! Int
        let bal = data[TRANSAC_BALANCE] as! Double
        let accountNumb = data[TRANSAC_ACC_NUM] as! String
        let date = dateFromString(data[_DATE] as! String)
        let pin = data[_PIN] as! String
        let final = data[TRANSAC_FINDETAIL] as? String
        transaction.transType = Int16(type)
        transaction.finalDetail = final
        transaction.date = date
        transaction.pMethod = Int16(pmeth)
        transaction.id = key
        transaction.state = Int16(status)
        account.accountNo = accountNumb
        account.name = accN
        transaction.account = account
        ledge.amount = tamount
        ledge.balance = bal
        ledge.date = date
        ledge.id = key
        ledge.pin = pin
        ledge.type = Int16(type)
        transaction.ltrans = ledge
        CoreDataStack.saveContext()

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
}
