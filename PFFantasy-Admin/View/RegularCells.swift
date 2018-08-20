//
//  RegularCells.swift
//  PFFantasy-Admin
//
//  Created by Mensah Shadrach on 02/07/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import Cocoa


protocol RegularProtocol:class {
    
    func didFinishValidating(_ choice:Extras, _ number:String)
}


class RegularCells: NSTableCellView, NSComboBoxDelegate, NSComboBoxDataSource, NSControlTextEditingDelegate {
    
    @IBOutlet weak var catePoints: NSTextField!
    @IBOutlet weak var categoryField: NSTextField!
    @IBOutlet weak var question: NSTextField!
    @IBOutlet weak var firststack:NSStackView!
    @IBOutlet weak var secondstack:NSStackView!
    @IBOutlet weak var thirdstack:NSStackView!
    @IBOutlet weak var fourthstack:NSStackView!
    @IBOutlet weak var crrctImageV: NSImageView!
    @IBOutlet weak var validateButton: FlatButton!
    @IBOutlet weak var firstopName: NSTextField!
    @IBOutlet weak var secondopName: NSTextField!
    @IBOutlet weak var thirdopName: NSTextField!
    @IBOutlet weak var fourthopName: NSTextField!
    @IBOutlet weak var firstopMatchup: NSTextField!
    @IBOutlet weak var secondopMatchup: NSTextField!
    @IBOutlet weak var thirdopMatchup: NSTextField!
    @IBOutlet weak var fourthopMatchup: NSTextField!
    @IBOutlet weak var firstopAverage: NSTextField!
    @IBOutlet weak var secondopAverage: NSTextField!
    @IBOutlet weak var thirdopAverage: NSTextField!
    @IBOutlet weak var fourthopAverage: NSTextField!
    @IBOutlet weak var firstopPoints: NSTextField!
    @IBOutlet weak var secondopPoints: NSTextField!
    @IBOutlet weak var thirdopPoints: NSTextField!
    @IBOutlet weak var fourthopPoints: NSTextField!
    @IBOutlet weak var firstopcolor: NSComboBox!
    @IBOutlet weak var secondopcolor: NSComboBox!
    @IBOutlet weak var thirdopcolor: NSComboBox!
    @IBOutlet weak var fourthopcolor: NSComboBox!
    @IBOutlet weak var capacity: NSComboBox!
    weak var delegate:RegularProtocol?
    var optioncapacity:Int!
    var colors:[TeamColor]!
    var colorNames:[String] = []
    var choiceNumebr:Int!
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpColors();
        firstopcolor.delegate = self
        secondopcolor.delegate = self
        thirdopcolor.delegate = self
        fourthopcolor.delegate = self
        firstopcolor.dataSource = self
        secondopcolor.dataSource = self
        thirdopcolor.dataSource = self
        fourthopcolor.dataSource = self
        firstopcolor.completes = true
        secondopcolor.completes = true
        thirdopcolor.completes = true
        fourthopcolor.completes = true
        optioncapacity = 2
        capacity.stringValue = "2";
        layoutOptions()
        
    }
    
    func setUpColors(){
        colorNames = []
        colors = CoreService.service.fetchAllColors();
        for item in colors {
            colorNames.append(item.name!)
        }
        Swift.print(colorNames)
        //colorNames = NSMutableArray(array: ncolorNames)
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        
    }
    
    func configureCell(index:Int){
        choiceNumebr = index + 1;
    }
    
    func layoutOptions(capacity:Int? = 2){
        switch capacity {
        case 2:
            thirdstack.isHidden = true
            fourthstack.isHidden = true
            break
        case 3:
            thirdstack.isHidden = false
            fourthstack.isHidden = true
            break
        case 4:
            thirdstack.isHidden = false
            fourthstack.isHidden = false
            break
        default:
            break
        }
    }
    
    
    @IBAction func capacitySelected(_ sender: Any) {
        if let capacitycombo = sender as? NSComboBox{
            if capacitycombo.stringValue == "2"{
                layoutOptions(capacity: 2);
                optioncapacity = 2
            }else if capacitycombo.stringValue == "3"{
                layoutOptions(capacity: 3);
                optioncapacity = 3
            }else if capacitycombo.stringValue == "4"{
                layoutOptions(capacity: 4)
                optioncapacity = 4
            }
        }
    }
    
    
    @IBAction func validatePressed(_ sender: Any) {
        if validate() {
            crrctImageV.image = NSImage(named: NSImage.Name("valid"))
        }else{
           crrctImageV.image = NSImage(named: NSImage.Name("invalid"))
            alert(title: "Invalid Fields", message: "Please make sure all Fileds are correctly filled");
        }
    }
    
    
    func findColorBy(_ name:String)->String{
        for item in colors {
            if item.name! == name{
                return item.hexValue!
            }
        }
        return "#000000"
    }
    
    func validate()->Bool{
        let fon = firstopName.stringValue
        let son = secondopName.stringValue
        let fmt = firstopMatchup.stringValue
        let smt = secondopMatchup.stringValue
        let fpn = Int(firstopPoints.stringValue)
        let fav = Double(firstopAverage.stringValue)
        let sav = Double(secondopAverage.stringValue)
        let spn = Int(secondopPoints.stringValue)
        let fcol = findColorBy(firstopcolor.stringValue)
        let scol = findColorBy(secondopcolor.stringValue)
        let question = self.question.stringValue
        let cat = categoryField.stringValue
    
        let catPoint = Int(catePoints.stringValue)
        switch optioncapacity {
        case 2:
            if question != "" && cat != "" && catPoint != nil && fon != "" && son != "" && fmt != "" && smt != "" && fpn != nil && spn != nil && fav != nil && sav != nil && fcol != "" && scol != "" && fcol.first! == "#" && scol.first! == "#" {
                let s:Array<Extras> = [[
                    _OPTION_NAME:fon, _MATCHUP: fmt, _AVERAGE: fav!, _POINTS:fpn!, _COLOR_HEX:fcol
                    ], [_OPTION_NAME:son, _MATCHUP: smt, _AVERAGE: sav!, _POINTS:spn!, _COLOR_HEX:scol]]
                let final:Extras = [_QUESTION: question, _CATEGORY:cat, _CAT_POINTS:catPoint!, _OPTIONS:s]
                delegate?.didFinishValidating(final, "q\(choiceNumebr!)")
                return true
            }
        case 3:
            let ton = thirdopName.stringValue
            let tmt = thirdopMatchup.stringValue
            let tpn = Int(thirdopPoints.stringValue)
            let tav = Double(thirdopAverage.stringValue)
            let tcol = findColorBy(thirdopcolor.stringValue)
            if question != "" && cat != "" && catPoint != nil && fon != "" && son != "" && fmt != "" && smt != "" && fpn != nil && spn != nil && fav != nil && sav != nil && fcol != "" && scol != "" && fcol.first! == "#" && scol.first! == "#" && ton != "" && tmt != "" && tpn != nil && tav != nil && tcol.first! == "#"{
                let s:Array<Extras> = [[
                    _OPTION_NAME:fon, _MATCHUP: fmt, _AVERAGE: fav!, _POINTS:fpn!, _COLOR_HEX:fcol
                    ], [_OPTION_NAME:son, _MATCHUP: smt, _AVERAGE: sav!, _POINTS:spn!, _COLOR_HEX:scol],[_OPTION_NAME:ton, _MATCHUP: tmt, _AVERAGE: tav!, _POINTS:tpn!, _COLOR_HEX:tcol]]
                let final:Extras = [_QUESTION: question, _CATEGORY:cat, _CAT_POINTS:catPoint!, _OPTIONS:s]
                delegate?.didFinishValidating(final, "q\(choiceNumebr!)")
                return true
            }
        case 4:
            let ton = thirdopName.stringValue
            let tmt = thirdopMatchup.stringValue
            let tpn = Int(thirdopPoints.stringValue)
            let tav = Double(thirdopAverage.stringValue)
            let tcol = findColorBy(thirdopcolor.stringValue)
            let f4on = fourthopName.stringValue
            let f4mt = fourthopMatchup.stringValue
            let f4av = Double(fourthopAverage.stringValue)
            let f4pn = Int(fourthopPoints.stringValue)
            let f4col = findColorBy(fourthopcolor.stringValue)
            
            if question != "" && cat != "" && catPoint != nil && fon != "" && son != "" && fmt != "" && smt != "" && fpn != nil && spn != nil && fav != nil && sav != nil && fcol != "" && scol != "" && fcol.first! == "#" && scol.first! == "#" && ton != "" && tmt != "" && tpn != nil && tav != nil && tcol.first! == "#" && f4on != "" && f4mt != "" && f4pn != nil && f4av != nil && f4col.first! == "#"{
                let s:Array<Extras> = [[
                    _OPTION_NAME:fon, _MATCHUP: fmt, _AVERAGE: fav!, _POINTS:fpn!, _COLOR_HEX:fcol
                    ], [_OPTION_NAME:son, _MATCHUP: smt, _AVERAGE: sav!, _POINTS:spn!, _COLOR_HEX:scol],[_OPTION_NAME:ton, _MATCHUP: tmt, _AVERAGE: tav!, _POINTS:tpn!, _COLOR_HEX:tcol],[_OPTION_NAME:f4on, _MATCHUP: f4mt, _AVERAGE: f4av!, _POINTS:f4pn!, _COLOR_HEX:f4col]]
                let final:Extras = [_QUESTION: question, _CATEGORY:cat, _CAT_POINTS:catPoint!, _OPTIONS:s]
                delegate?.didFinishValidating(final, "q\(choiceNumebr!)")
                return true
            }
        default:
            return false
        }
        return false;
        
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


