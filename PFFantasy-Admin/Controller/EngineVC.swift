
//
//  EngineVC.swift
//  PFFantasy-Admin
//
//  Created by Lord Codesworth on 14/08/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Cocoa

class EngineVC: NSViewController,NSTableViewDelegate,NSTableViewDataSource,UpdatedContestWins {
    
    @IBOutlet weak var contestTable:NSTableView!
    @IBOutlet weak var leaderboardTable:NSTableView!
    var engineContests:[FantasyConsumable]!
    var engineContestSource:[String:FantasyConsumable]!
    var leaderboard:Leaderboard?
    var heldContests:FantasyConsumable?
    var batchContests:Set<FantasyConsumable>!
    var helpCpick:CorrectPicks?
    var Allleaderbaords:[String:Leaderboard] = [:]
    var contestPays:ContestPayments!
    @IBOutlet weak var correctpick:NSTextField!
    @IBOutlet weak var workButt:NSButton!
    @IBOutlet weak var workAllButt:NSButton!
    var heldKeys:Set<String>!
    @IBOutlet weak var pickdetails: NSTextField!
    @IBOutlet weak var publishButt: NSButton!
    var verified = false
    override func viewDidLoad() {
        super.viewDidLoad()
        engineContests = []
        
        heldKeys = []
        batchContests = []
        contestTable.allowsMultipleSelection = true
        contestTable.delegate = self
        leaderboardTable.delegate = self
        contestTable.dataSource = self
        leaderboardTable.dataSource = self
        workButt.isEnabled = false
        getConsumables()
        
    }
    override func viewWillAppear() {
        super.viewWillAppear()
        
    }
    
    func makeContestsArray(){
       engineContests = []
        engineContests = engineContestSource.compactMap { (arg0) -> FantasyConsumable? in
            
            let (_, value) = arg0
            return value
        }
        
    }
    
    
    
    func getCorrectAns(id:String){
        
    }
    
    
    func getConsumables(){
        Dataservice.service.getAllPicks { (success, err, data) in
            if success && data != nil{
                if let data = data as? Extras{
                    self.engineContestSource = PFEngine.mainEngine.makeConsumable(largeData: data)
                    self.makeContestsArray()
                    self.contestTable.reloadData()
                }else{
                   
                }
            }else if err != nil{
                alert(title: "ERROR", message: err.debugDescription)
            }
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView == contestTable {
            return engineContests.count
        }else if tableView == leaderboardTable{
            guard leaderboard == nil else{
                return leaderboard!.positioning.count

            }
        }
        return 0
    }
    
    @IBAction func workSingle(_ sender: NSButton){
        
        if heldContests != nil && helpCpick != nil{
            if helpCpick!.id! == heldContests!.contest.questionID{
                let results = PFEngine.mainEngine.engineStart(consumable: heldContests!, rightPick: EngineCorrectPicks(pick: helpCpick!))
                leaderboard = results
                makeContestPayes()
                leaderboardTable.reloadData()
            }
        }
    }
    
    
    
    @IBAction func workMultiple(_ sender:NSButton){
        var error:Set<String> = []
        for item in batchContests{
            if let rpick = CoreDatabase.service.fetchAnswer(id: item.contest.questionID!) {
                let result = PFEngine.mainEngine.engineStart(consumable: item, rightPick: EngineCorrectPicks(pick: rpick))
                Allleaderbaords[result.contestId] = result
            }else{
                error.insert(item.contest.title!)
            }
        }
        if error.count > 0 {
            var cats = ""
            for e in error{
                cats.append("/ \(e)")
            }
            alert(title: "UNAVAILABLE PICKS", message: "There were no available correct picks for \(cats)")
        }
        leaderboard = Allleaderbaords.first?.value
        leaderboardTable.reloadData()
    }
 
    
    
    
    
    @IBAction func uploadLeaderBoard(_ sender: NSButton){
        if Allleaderbaords.count > 0 {
            var extras:Extras = [:]
            for (key, val) in Allleaderbaords{
                extras[key] = val.jsonify()
            }
            let data = ["data":extras]
            Dataservice.service.postLeaderbaord(data: data) { (succes, err, mesage) in
                if(succes){
                    for e in self.batchContests{
                        self.engineContestSource.removeValue(forKey:e.id)
                        
                    }
                    self.makeContestsArray()
                    let ts = self.makeContetstPayments()
                    self.performSegue(withIdentifier: NSStoryboard.SegueIdentifier.init("ECONPAYS"), sender: ts)
                    alert(title: "SUCESS", message: mesage)
                }else{
                    alert(title: "ERROR", message: err!.localizedDescription)
                }
            }
        }
    }
    
    func makeContetstPayments()->Set<ContestPayments>{
        var set:Set<ContestPayments> = []
        for ld in Allleaderbaords{
            let p =  PFEngine.mainEngine.engineMakeContestPayments(key: ld.key, positioning: ld.value.positioning)
            set.insert(p)
        }
        
        return set
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if (tableView == contestTable){
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue:String.init(describing: EngineContestsCells.self)), owner: self) as? EngineContestsCells{
                let fc = engineContests[row]
                cell.configureView(econ: fc)
                return cell
                
                }
            }else if tableView == leaderboardTable{
                if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: String(describing: LeaderBoardCells.self)), owner: self) as? LeaderBoardCells{
                    let r = row + 1
                    let pos = leaderboard?.positioning["\(r)"]
                    cell.configureTable(item: pos!)
                    return cell
                }
            }
        
        return NSTableCellView()
        
    }
    
    
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 55
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if contestTable.selectedRow >= engineContests.count{return}
        heldKeys.removeAll()
        heldContests = engineContests[contestTable.selectedRow]
        batchContests.insert(heldContests!)
        heldKeys.insert(heldContests!.id)
        helpCpick = CoreDatabase.service.fetchAnswer(id: heldContests!.contest.questionID!)
        if helpCpick != nil {
            correctpick.stringValue = "Correct Pick available"
            workButt.isEnabled = true
            
        }
        if Allleaderbaords.count > 0{
            leaderboard = Allleaderbaords[heldContests!.id]
            leaderboardTable.reloadData()
        }
        
    }
    
    func tableView(_ tableView: NSTableView, selectionIndexesForProposedSelection proposedSelectionIndexes: IndexSet) -> IndexSet {
        for index in proposedSelectionIndexes {
            batchContests.insert(engineContests[index])
        }
        
        return proposedSelectionIndexes
    }
    
    func makeContestPayes(){
        contestPays = PFEngine.mainEngine.engineMakeContestPayments(key: leaderboard!.contestId, positioning: leaderboard!.positioning)
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier!.rawValue == "ECONPAYS" {
            if let payments = sender as? Set<ContestPayments>, let controller = segue.destinationController as? AccountsUpdatesVC{
                controller.contestPayments = payments
                controller.delegate = self
            }
        }
    }
    
    func notifyViewWillBecomeKey() {
        if(heldContests != nil){
            contestTable.reloadData()
            heldContests = nil
            leaderboard = nil
            leaderboardTable.reloadData()
        }
    }
    
    
}



