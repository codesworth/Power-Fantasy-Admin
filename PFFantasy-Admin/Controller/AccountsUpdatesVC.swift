//
//  AccountsUpdatesVC.swift
//  PFFantasy-Admin
//
//  Created by Mensah Shadrach on 26/08/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Cocoa

protocol UpdatedContestWins:class {
    func notifyViewWillBecomeKey()
}

let EDITING_MODE = "canEdit"

class AccountsUpdatesVC: NSViewController,NSTableViewDataSource,NSTableViewDelegate,NSComboBoxDelegate,NSComboBoxDataSource {

    @IBOutlet weak var syncAccountsButt: FlatButton!
    @IBOutlet weak var searchAccountField: NSSearchField!
    @IBOutlet weak var tableView:NSTableView!
    @IBOutlet weak var sortbyCombo: NSComboBox!
    @IBOutlet weak var updateAccountButton: FlatButton!
    @IBOutlet weak var addUpbutton: FlatButton!
    @IBOutlet weak var addFundsTextField: NSTextField!
    var modifiableAccounts:[String:CXFCreditAccount]!
    var modArray:[CXFCreditAccount]!
    var selectedPayment:ContestPayments?
    @IBOutlet weak var updateContestWIns: FlatButton!
    var transactions:[CXTransaction]?
    private var leaderboard:Leaderboard!
    weak var delegate:UpdatedContestWins?
    var contestPayments:Set<ContestPayments>!
    var contest:Contest?
    var canEdit = false
    @IBOutlet weak var canEditButton:FlatButton!
    var combodata:Array<(String,String)>!
    override func viewDidLoad() {
        super.viewDidLoad()
        modifiableAccounts = [:]
        modArray = []
        combodata = []
        canEditButton.wantsLayer = true
        tableView.delegate = self
        tableView.dataSource = self
        syncAccountsButt.isEnabled = canEdit
        updateAccountButton.isEnabled = false
        addUpbutton.isEnabled = false;
        setup()
        switchEditingColor()
        selectedPayment = contestPayments.first
        contest = CoreDatabase.service.fetchContestsBy(an: ((selectedPayment?.contestKey)!)).first
    }
    
    func setup(){

        combodata = contestPayments.compactMap({ psys -> (String,String) in
            let con = CoreDatabase.service.fetchContestsBy(an: psys.contestKey).first!
            return (psys.contestKey,con.title!)
            
        })
        sortbyCombo.dataSource = self
        sortbyCombo.delegate = self
    }
    
    
    @IBAction func turnOnEditing(_ sender:FlatButton){
        if canEdit {
            canEdit = false
        }else{canEdit = true}
        canEditButton.isEnabled = false
        let string = getString(title: "Enter Admin Password", question: "Toggling Editing mode on blocks all mobile application access to user accounts on the server. Please validate before proceeding", defaultValue: "")
        let access = AuthenticationService.main.retrieveAccount(username: AgentID, password: string)
        if access.0 {
            Dataservice.service.toggleAccountMutability(canMutate: canEdit) { (success, err, writeTime) in
                self.canEditButton.isEnabled = true
                if(success){
                    self.switchEditingColor()
                    self.syncAccountsButt.isEnabled = true
                    
                    
                }else{
                    alert(title: "ERROR", message: err?.localizedDescription ?? "UNKOWN ERROR")
                    self.canEdit = !self.canEdit
                    
                }
            }
        }else{
            alert(title: "INVALID CREDENTIALS", message: "Please enter correct admin password")
            canEdit = !canEdit
            canEditButton.isEnabled = true
        }
    }
    
    @IBAction func syncAccountsPressed(_ sender: FlatButton) {
        Dataservice.service.getAccounts { (succes, eerr, data) in
            if (succes && data != nil){
                if let data = data as? Extras{
                    let saved = CoreDatabase.service.sycronizeAccounts(data: data)
                    if saved{
                        alert(title: "Success", message: "User Credit Accounts updated succcesfully")

                    }else{
                        alert(title: "Error", message: "Incomplete Database action: Could not save to context")
                    }
                    
                }
            }
        }
    }
    
    
    @IBAction func sortByCompressed(_ sender: NSComboBox) {
        
        let k = sender.stringValue.split(separator: "/")
        
        if !k.isEmpty{
            selectedPayment = findPaymentToList(key: String(k.last!))
            contest = CoreDatabase.service.fetchContestsBy(an: selectedPayment!.contestKey).first
            if selectedPayment != nil{
                tableView.reloadData()
            }
        }
    }
    
    
    @IBAction func addUpPressed(_ sender: FlatButton) {
    }
    @IBAction func updateContestWins(_ sender: FlatButton) {
        for item in contestPayments{
            let task = CoreDatabase.service.createTransactionForWinsAndUpdateAccounts(winnings: item)
            if task == nil{
                alert(title: "ERROR", message: "Something went wrong updating contest Wins")
            }else{
                modifiableAccounts = task!
                transactions = CoreDatabase.service.fetchUnIndexedTransactions()
                modArray = getModifiableArray()
                
            }
        }

            tableView.reloadData()
            updateAccountButton.isEnabled = true
        
    }
    
    @IBAction func updateAccountsOnServer(_ sender: FlatButton) {
        var accounts:Extras = [:]
        var tss:Extras = [:]
        for (_,val) in modifiableAccounts {
            let acc = createServerObjectForAccount(account: val)
            accounts[val.accountNo!] = acc
        }
        
        for item in transactions! {
            let obj = createServerObjectForTransactions(transaction: item)
            tss[item.id!] = obj
        }
        let data = ["acc":accounts,"trans":tss]
        Dataservice.service.updateContestWinnersAccounts(data) { (success, error, data) in
            if(success){
                self.transactions?.forEach({ (transac) in
                    transac.indexed = true
                })
                CoreDataStack.saveContext()
                alert(title: "SCESS", message: "Accounts succesfully Updated")
                self.dismiss(nil)
                self.delegate?.notifyViewWillBecomeKey()
            }
        }
        
    }
    func turnToggleEditModeOff(){
        if canEdit {
            Dataservice.service.toggleAccountMutability(canMutate: false) { (success, err, writeTime) in
                if(success){
                self.switchEditingColor()
                    self.canEdit = false
                
                }else{
                alert(title: "ERROR", message: err?.localizedDescription ?? "UNKOWN ERROR")
                self.canEdit = !self.canEdit
                }
            }
        }
    }
    
    func getString(title: String, question: String, defaultValue: String) -> String {
        let msg = NSAlert()
        msg.addButton(withTitle: "Enter")      // 1st button
        msg.addButton(withTitle: "Cancel")  // 2nd button
        msg.messageText = title
        msg.informativeText = question
        
        let txt = NSSecureTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        
        txt.stringValue = defaultValue
        
        msg.accessoryView = txt
        let response = msg.runModal()
        
        if (response == .alertFirstButtonReturn) {
            return txt.stringValue
        } else {
            return ""
        }
        
    }
    
    override func viewWillDisappear() {
        turnToggleEditModeOff()
    }
    
    func switchEditingColor(){
        if !canEdit {
            canEditButton.layer?.backgroundColor = NSColor.green.cgColor
            canEditButton.title = "TURN ON EDITING MODE"
        }else{
            canEditButton.layer?.backgroundColor = NSColor.red.cgColor
            canEditButton.title = "TURN OFF EDITING MODE"
        }
        
        
    }
    
    
    func findPaymentToList(key:String)->ContestPayments?{
        
        for item in contestPayments {
            if item.contestKey == key{
                return item
            }
        }
        return nil
    }
    
}


extension AccountsUpdatesVC{
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return modifiableAccounts.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue:String.init(describing: AccoutsCell.self)), owner: self) as? AccoutsCell{
            let fc = modArray[row]
            let win = selectedPayment!.paymentLedger[fc.accountUserID!]
            cell.configure(account: fc,win:win ?? 0.00, contestType: (contest?.contestType)!)
            return cell
            
        }
        return AccoutsCell()
    }
    
    
    func getModifiableArray()->[CXFCreditAccount]{
        var modArr:[CXFCreditAccount] = []
        for (_, val) in modifiableAccounts {
            modArr.append(val)
        }
        
        modArr.sort { (x, y) -> Bool in
            return y.balance > x.balance
        }
        Swift.print("The items are: ",modArr)
        return modArr
    }
    
    func createServerObjectForAccount(account:CXFCreditAccount)->Extras{
        return [
            FIELD_CREDIT_BALANCE : account.balance,
            FIELD_LAST_UP : Int64((account.lastUpdated!.timeIntervalSince1970) * 1000),
            FIELD_AGGRE_GAIN: account.aggregatedGains,
            FIELD_VIRT_BALANCE : account.virtualCoins,
            FIELD_MUTATED : false,
            _LIFETIME_POINTS: account.lifetimePoints
            ] as Extras
    }
    
    func createServerObjectForTransactions(transaction:CXTransaction)->Extras{
        return [
            FIELD_TRANSAC_ID : transaction.id!,
            FIELD_TRANSAC_TS : Int64((transaction.date!.timeIntervalSince1970) * 1000),
            FIELD_TRANSAC_MODE: transaction.transactionMode,
            FIELD_TRANSAC_CLUID :transaction.cluid!,
            "indexed" : true,
            FIELD_TRANSAC_AMOUNT: transaction.amount,
            FIELD_TRANSAC_ACC_ID: transaction.accountId!,
            FIELD_TRANSAC_STATUS : transaction.status,
            FIELD_TRANSAC_CURTYPE : transaction.currencyType,
            FIELD_TRANSAC_FIN_DET: transaction.finalDetail!,
            FIELD_TRANSAC_BALANCE: transaction.balance,
            FIELD_TRANSAC_TYPE:transaction.transactionType
            ] as Extras
    }
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return contestPayments.count
    }
    
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        return "\(combodata[index].1) /\(combodata[index].0)"
    }
    
//    func comboBox(_ comboBox: NSComboBox, indexOfItemWithStringValue string: String) -> Int {
//        if  {
//
//        }
//    }
}


/**
 
 //        accountChanges = AccountChanges(context: CoreDataStack.getContext())
 //        accountChanges.accessLevel = ACCESS_LEVEL
 //        accountChanges.agentID = AgentID
 //        accountChanges.isCommitted = false
 //            for(key, value) in contestPayments!.paymentLedger{
 //            let players = CoreDatabase.service.fetchEntityBy(an: key, for:FetchPropertyKeys.playerUID, with: String(describing: Players.self))
 //            if (!players.isEmpty){
 //                if let player = players.first as? Players{
 //                    let account = player.creditAccount!
 //                    let achange = UnitAccountChange(context: CoreDataStack.getContext())
 //                    achange.before = account.balance
 //                    account.balance = account.balance + value
 //                    account.aggregatedGains += value
 //                    player.creditAccount = account
 //                    achange.timestamp = Int64(Date().timeIntervalSince1970 * 1000)
 //                    achange.accountNumber = account.accountNo!
 //                    achange.accountUserId = player.uid!
 //                    achange.after = account.balance
 //                    accountChanges.addToActualChanges(achange)
 //                    CoreDataStack.saveContext()
 //                    modifiableAccounts[key] = account
 //                }
 //            }
 
 
 //            modArray = getModifiableArray()
 //            Swift.print("The modaArr: ",modArray)
 */
