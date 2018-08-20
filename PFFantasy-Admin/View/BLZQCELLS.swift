//
//  BLZQCELLS.swift
//  PFFantasy-Admin
//
//  Created by Mensah Shadrach on 2/17/18.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Cocoa

typealias Extras = Dictionary<String, Any>

protocol BlazeQprotocol:class {
    
    func didFinishValidating(_ choice:Extras, _ number:String)
}

class BLZQCELLS: NSTableCellView {

    @IBOutlet weak var choiceNumber: NSTextField!
    @IBOutlet weak var drawPoints: NSTextField!
    @IBOutlet weak var crrctImageV: NSImageView!
    @IBOutlet weak var segTypecombo: NSComboBox!
    @IBOutlet weak var drawStack: NSStackView!
    @IBOutlet weak var homeTeam: NSTextField!
    @IBOutlet weak var homePoints: NSTextField!
    @IBOutlet weak var homeColors: NSComboBox!
    @IBOutlet weak var homeRecord: NSTextField!
    @IBOutlet weak var awayTeam: NSTextField!
    @IBOutlet weak var awayPoints: NSTextField!
    @IBOutlet weak var awayColors: NSComboBox!
    @IBOutlet weak var awayRecord: NSTextField!
    @IBOutlet weak var validateButton: FlatButton!
    weak var delegate:BlazeQprotocol?
    var colors:[TeamColor]!
    var colorNames:[String] = []
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpColors()
        drawStack.isHidden = true
        homeColors.delegate = self
        awayColors.delegate = self
        homeColors.dataSource = self
        awayColors.dataSource = self
        homeColors.completes = true
        awayColors.completes = true
    }
    
    @IBAction func segChanged(_ sender: Any) {
        if segTypecombo.stringValue == "2"{
            drawStack.isHidden = true
        }else{
            drawStack.isHidden = false
        }
    }
    @IBAction func validatePressed(_ sender: Any) {
        if validateFields() {
            validateButton.title = "Validated"
            crrctImageV.image = NSImage(named: NSImage.Name("valid"))
            //Set imageFields
        }else{
           crrctImageV.image = NSImage(named: NSImage.Name("invalid"))
        }
    }
    
    func configure(index:Int){
        
        choiceNumber.stringValue = "\(index + 1)"
    }
    
    func findColorBy(_ name:String)->String{
        for item in colors {
            if item.name! == name{
                return item.hexValue!
            }
        }
        return "#000000"
    }
    
    func validateFields()->Bool{
        let dp:Int? = Int(drawPoints.stringValue)
        //
        let hp:Int? = Int(homePoints.stringValue)
        let ht = homeTeam.stringValue
        let hc = findColorBy(homeColors.stringValue)
        let hr = homeRecord.stringValue
        let at = awayTeam.stringValue
        let ap:Int? = Int(awayPoints.stringValue)
        let ar = awayRecord.stringValue
        let ac = findColorBy(awayColors.stringValue)
        let s:Int? = Int(segTypecombo.stringValue)
        
        guard s != nil else{
            alert(title: "Incomplete fields", message: "Enter Segment Type")
            return false
        }
        
        if s! == 2{
            if s != nil && hp != nil && ht != "" && hc.contains("#") && hr != "" && ap != nil && at != "" && ac.contains("#") && ar != ""{
                let js:Extras = [
                        _SEGTYPE : s!,
                        _HTEAM : ht,
                        _HM_POINT: hp!,
                        _HOMCOL: hc,
                        _HOMREC: hr,
                        _AWCOL: ac,
                        _AWREC : ar,
                        _AW_POINT2: ap!,
                        _ATEAM : at
                    ]
                delegate?.didFinishValidating(js,choiceNumber.stringValue)
                return true
            }
        }else{
            if s != nil && hp  != nil && dp != nil && ht != "" && hc.contains("#") && hr != "" && ap != nil && at != "" && ac.contains("#") && ar != ""{
                let js:Extras = [
                        _SEGTYPE : s!,
                        _HTEAM : ht,
                        _HM_POINT: hp!,
                        _HOMCOL: hc,
                        _HOMREC: hr,
                        _AWCOL: ac,
                        _AWREC : ar,
                        _AW_POINT2: ap!,
                        _ATEAM : at,
                        _DRW_POINT : dp!
                    ]
                delegate?.didFinishValidating(js,choiceNumber.stringValue)
                return true
            }
        }
        return false
    }
}


extension BLZQCELLS: NSComboBoxDelegate, NSComboBoxDataSource, NSControlTextEditingDelegate{
    func setUpColors(){
        colorNames = []
        colors = CoreService.service.fetchAllColors();
        for item in colors {
            colorNames.append(item.name!)
        }
        
    }
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return colorNames.count
    }
    
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        return colorNames[index]
    }
    
    func comboBox(_ comboBox: NSComboBox, indexOfItemWithStringValue string: String) -> Int {
        return self.colorNames.index(of: string) ?? 0
    }
    
    func comboBox(_ comboBox: NSComboBox, completedString string: String) -> String? {
        var returnString = ""
        for dataString in self.colorNames{
            if  dataString.commonPrefix(with: string, options: NSString.CompareOptions.caseInsensitive).lengthOfBytes(using: String.Encoding.utf8) == string.lengthOfBytes(using: String.Encoding.utf8)
            {
                returnString = dataString
                self.filterDataArray(string)
                return returnString
            }
        }
        if returnString.isEmpty{
            comboBox.stringValue = ""
        }
        self.filterDataArray(string)
        return returnString
    }
    
    
    
    func filterDataArray(_ string:String){
    }

}
