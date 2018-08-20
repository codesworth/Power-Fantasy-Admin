//
//  CXFCVC.swift
//  PFFantasy-Admin
//
//  Created by Mensah Shadrach on 03/07/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Cocoa

class CXFCVC: NSViewController, NSTableViewDelegate,NSTableViewDataSource {
    
    @IBOutlet weak var paymentType: NSComboBox!
    @IBOutlet weak var uploadContestButton: NSButton!
    @IBOutlet weak var contestValidation: NSButton!
    @IBOutlet weak var winningPrice: NSTextField!
    @IBOutlet weak var numberOfContestants: NSTextField!
    @IBOutlet weak var contestMaxEntry: NSTextField!
    @IBOutlet weak var contestFee: NSTextField!
    @IBOutlet weak var contestID: NSTextField!
    @IBOutlet weak var genKeyButton: NSButton!
    @IBOutlet weak var keyTextField: NSTextField!
    @IBOutlet weak var contestType: NSComboBox!
    @IBOutlet weak var sportsype: NSComboBox!
    @IBOutlet weak var questionTableView: NSTableView!
    @IBOutlet weak var q_id: NSTextField!
    @IBOutlet weak var tableView:NSTableView!
    @IBOutlet var contestView: NSView!
    var name:String?
    var key:String = ""
    var questionID:String = ""
    var fees:Double?
    var question:String?
    var league:String?
    var prize:Double?
    var numCon:Int?
    var type:Int?
    var pmType:Int?
    var maxE:Int?
    var timestamp:Int64!
    var availableQuestions:[Any]!

    override func viewDidLoad() {
        super.viewDidLoad()
        q_id.isEditable = false
        uploadContestButton.isEnabled = false
        availableQuestions = []
        tableView.delegate = self
        tableView.dataSource = self
        // Do view setup here.
    }
    
    
    
    @IBAction func validateContests(_ sender: Any) {
        questionID = q_id.stringValue
        name = contestID.stringValue
        key = keyTextField.stringValue
        fees = Double(contestFee.stringValue)
        league = sportsype.stringValue
        prize = Double(winningPrice.stringValue)
        numCon = Int(numberOfContestants.stringValue)
        type = makeType(string: contestType.stringValue)
        maxE = Int(contestMaxEntry.stringValue)
        pmType = makePaymentType(string: paymentType.stringValue)
        if questionID != "" && name != "" && key != "" && fees != nil && league != "" && prize != nil && numCon != nil && type != nil && maxE != nil && pmType != nil{
            contestValidation.title = "Validated"
            uploadContestButton.isEnabled = true
        }
        
        
    }
    
    
    @IBAction func uploadContets(_ sender: Any) {
        if uploadContestButton.isEnabled{
            let json:Extras = [
                _CONTEST_NAME : name!,
                _QUESTION_ID : questionID,
                _FEE : fees!,
                _LEAGUE_TYPE : league!,
                _PRICE : prize!,
                _NO_CONTESTANTS : 0,
                _PAYMENT_TYPE: pmType!,
                _ENTRY_CAP : numCon!,
                _TYPE : type!,
                _MAX_ENTRY : maxE!,
                _TS : timestamp,
                _STATUS: AVAILABLE
                
            ]
            let leageudata:Extras = ["ts":timestamp,"lg":league!]
            Dataservice.service.uploadContest(key, json,leaguedata:leageudata) { (success, err, ex) in
                if success{
                    alert(title: "Contest Succesfully Uploaded", message: ex)
                    let contest = Contest(context: CoreDataStack.persistentContainer.viewContext)
                    contest.cap = Int64(self.numCon!)
                    contest.timestamp = self.timestamp
                    contest.fee = self.fees!;
                    contest.status = Int32(AVAILABLE)
                    contest.key = self.keyTextField.stringValue
                    contest.maxEntry = Int64(self.maxE!)
                    contest.priceMoney = self.prize!
                    contest.questionID = self.questionID
                    contest.contestType = Int32(self.type!)
                    contest.title = self.name!; contest.sport = self.league!
                    CoreDataStack.saveContext()
                }
            }
        }
    }
    
    
    @IBAction func generateKey(_ sender: NSButton) {
        let id = Date().unixTimestamp();
        keyTextField.stringValue = "\(id)"
        print(id)
    }
    @IBAction func contestTypeSelected(_ sender: Any) {
        if let combo =  sender as? NSComboBox{
            if combo.stringValue == ContestType.regular.rawValue{
                availableQuestions = CoreService.service.fetchRegular()
                tableView.reloadData()
                
            }else if combo.stringValue == ContestType.blaze.rawValue{
                availableQuestions = CoreService.service.fetchBlaze()
                tableView.reloadData()
                
            }
        }
    }
    
    @IBAction func sportsTypeSelected(_ sender: Any) {
        
    }
    
    func makeType(string:String)->Int?{
        if string == "Regular"{
            return 100
        }else if string == "Blaze"{return 200}
        return nil
        
    }
    
    func makePaymentType(string:String)->Int?{
        if string == "Virtual"{
            return 500
        }else if string == "Cash"{return 600}
        return nil
        
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return availableQuestions.count
    }
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "QID"), owner: self) as? NSTableCellView{
            if let q = availableQuestions[row] as? BlazeQuestion{
                let labl = cell.viewWithTag(2) as! NSTextField
                cell.textField?.stringValue = q.id!
                let date = Date(timeIntervalSince1970: (TimeInterval(q.timestamp / 1000)))
                labl.stringValue = stringFrom(date)
            }else if let q = availableQuestions[row] as? RegularQuestions{
                cell.textField?.stringValue = q.id!
                let labl = cell.viewWithTag(2) as! NSTextField
                let date = Date(timeIntervalSince1970: (TimeInterval(q.timestamp / 1000)))
                labl.stringValue = stringFrom(date)
            }
           return cell
        }
        
        return NSTableCellView()
        
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 55
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let index = tableView.selectedRow
        if let sq = availableQuestions[index] as? RegularQuestions{
            timestamp = sq.timestamp
            questionID = sq.id!
            sportsype.stringValue = sq.league!
            q_id.stringValue = questionID
        }else if let sq = availableQuestions[index] as? BlazeQuestion{
            timestamp = sq.timestamp
            sportsype.stringValue = sq.league!
            questionID = sq.id!
             q_id.stringValue = questionID
        }
    }
}
