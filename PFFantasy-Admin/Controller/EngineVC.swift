
//
//  EngineVC.swift
//  PFFantasy-Admin
//
//  Created by Lord Codesworth on 14/08/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Cocoa

class EngineVC: NSViewController,NSTableViewDelegate,NSTableViewDataSource {
    
    @IBOutlet weak var contestTable:NSTableView!
     @IBOutlet weak var leaderboardTable:NSTableView!
    var engineContests:[FantasyConsumable]!
    var leaderboard:Leaderboard?
    var heldContests:FantasyConsumable?
    var helpCpick:CorrectPicks?
    @IBOutlet weak var correctpick:NSTextField!
    @IBOutlet weak var workButt:NSButton!
    @IBOutlet weak var workAllButt:NSButton!
    
    @IBOutlet weak var pickdetails: NSTextField!
    @IBOutlet weak var publishButt: NSButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        engineContests = []
        
        contestTable.delegate = self
        leaderboardTable.delegate = self
        contestTable.dataSource = self
        leaderboardTable.dataSource = self
        workButt.isEnabled = false
        getConsumables()
        
    }
    
    
    
    func getCorrectAns(id:String){
        
    }
    
    
    func getConsumables(){
        Dataservice.service.getAllPicks { (success, err, data) in
            if success && data != nil{
                if let data = data as? Extras{
                    self.engineContests = PFEngine.mainEngine.makeConsumable(largeData: data)
                    self.contestTable.reloadData()
                }else{
                    Swift.print("This was encountered: ",data)
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
                leaderboardTable.reloadData()
            }
        }
    }
    
    @IBAction func uploadLeaderBoard(_ sender: NSButton){
        if leaderboard != nil{
            let extras:Extras = leaderboard!.jsonify()
            Dataservice.service.postLeaderbaord(data: extras) { (succes, err, mesage) in
                if(succes){
                    alert(title: "SUCESS", message: mesage)
                }else{
                    alert(title: "ERROR", message: err!.localizedDescription)
                }
            }
        }
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
        heldContests = engineContests[contestTable.selectedRow]
        helpCpick = CoreService.service.fetchAnswer(id: heldContests!.contest.questionID!)
        if helpCpick != nil {
            correctpick.stringValue = "Correct Pick available"
            workButt.isEnabled = true
            
        }
        
    }
    
    
    
}



