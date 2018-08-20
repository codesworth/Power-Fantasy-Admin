//
//  EngineVCells.swift
//  PFFantasy-Admin
//
//  Created by Lord Codesworth on 14/08/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Cocoa

class EngineContestsCells:NSTableCellView{
    
    @IBOutlet weak var contestName:NSTextField!
    @IBOutlet weak var details:NSTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureView(econ:FantasyConsumable){
        contestName.stringValue = econ.contest.title!
        details.stringValue = "\(econ.allPicks.count) Entries"
    }
}





class LeaderBoardCells:NSTableCellView{
    
    @IBOutlet weak var position:NSTextField!
    @IBOutlet weak var username:NSTextField!
    @IBOutlet weak var winnings:NSTextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureTable(item:Positioning){
        position.stringValue = "\(item.relativePositon)"
        username.stringValue = "\(item.username)/\(item.points)"
        winnings.stringValue = "GHS\(item.wins)"
    }
}
