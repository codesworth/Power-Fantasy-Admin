//
//  Constants.swift
//  PFFantasy-Admin
//
//  Created by Mensah Shadrach on 2/15/18.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import AppKit




/*******************************************************************************************/
//PATHS


let FIRST_R = "first"
/*******************************************************************************************/
let FIR_REF_PLAYERS = "Players"
let REUSE_ID_CXFANSWERCELL = "CXFANSWERCELL"
let SEGUE__CNTEST_ANSWERS = "CXFANSWERVC"
let SHADOW_COLOR:CGFloat = 157.0 / 255
let _DATE = "date"
let _CREATED = "created"
let LEDGER_REF = "CXFLedger"
let _FEE = "fee"
let CONTEST_REGULAR = 100
let CONTEST_BLAZE = 200
let UNSOLVED = 50
let EXPIRED = 60
let CAPPED_OUT = 45
let AVAILABLE = 40
let _MAX_ENTRY = "maxEntry"
let _PRICE = "price"
let _SPORT = "sports"
let _LEAGUE_TYPE = "league"
let _CONTEST_NAME = "name"
let _QUESTION = "question"
let _CATEGORY = "cat"
let _CAT_POINTS = "catPoints"
let _OPTION_NAME = "name"
let _AVERAGE = "average"
let _POINTS = "points"
let _MATCHUP = "matchup"
let _TYPE = "type"
let _ID = "ID"
let _PICK_NAMES = "spickNames"
let _PICK_ACTUAL_SCORES = "ActualScores"
let _EXTRAS = "extras"
let _COLOR_HEX = "color"
let _USERNAME = "username"
let CREDIT = "credit"
let _STATUS = "status"
let _Q1 = "q1"
let _Q2 = "q2"
let _Q3 = "q3"
let _Q4 = "q4"
let R_POSITION = "rPosition"
let PICK_ID = "pickId"
let _WINS = "wins"
let _Q5 = "q5"
let _Q6 = "q6"
let _Q7 = "q7"
let _Q8 = "q8"
let  FIELD_UTILITY_ACC_SERVER_EDITING = "serverEditing"
let _PAYMENT_TYPE = "paymentType"
let _NO_CONTESTANTS = "numberOfContestants"
let _ENTRY_CAP = "cap"
let _TS = "ts"
let _CONTESTS_ACTIVE = "Active Contests"
let SEGUE_PICKS_VC = "myPickViewSegue"
let _REUSE_ID_EX_CONTESTCELLS = "EXPCONTESTSCELLS"
let MENUNAVCONTROLLER = "MenuNav"
let _LIFETIME_POINTS = "lifetimePoints";
let H_NAV = "HomeNav"
let STORY_ID_MY_CONT = "MyContest"
let _ISLOGGEDIN = "loggedIn"
var menuIndex = 0
let REF_QNA = "Questions"
let ID_CXFCCVCell = "CXFCCollectionCell"
let REF_LEAGUE = "Leagues"
let REF_CONTESTS = "Contests"
let LATEST = "Latest Contest"
let _OPTIONS = "options"
let _QUESTION_ID = "qid"
let IMAGE_PATH_DIR = "Images"
let IMAG_DIR = "imdir"
let _STAT = "stat"
//let _DEEP_BLUE = UIColor("#022858")
let PAYMENT_METHOD_DEFAULT = 1
let TRANSAC_ACC_NUM = "tAccNumber"
let TRANSAC_ACC_NAME = "tAccName"
let TRANSAC_CLIENT_ID = "cluid"
let TRANSAC_AMOUNT = "tAmount"
let PICKS_ALL_PICKS_ID = "spickNames";
let PICKS_ALL_POINTS = "allPoints";
let PICKS_PLAYER_ID = "pluid";
let FIELD_CONTEST_ID = "contestID";
let TRANSAC_TYPE = "tType"
let TRANSACTION = "Transactions"
let DEF_MAKE_DEFACC = "defaultacc"
let TRANSAC_BALANCE = "balance"
let TRANSAC_STATUS = "status"
let IS_IPHONE_6 = "iPhone 6"
let IS_IPHONE_6_PLUS = "iPhone 6 Plus"
let IS_IPHONE_6S = "iPhone 6s"
let IS_IPHONE_6S_PLUS = "iPhone 6s Plus"
let IS_IPHONE_7 = "iPhone 7"
let IS_IPHONE_7_PLUS = "iPhone 7 Plus"
let IS_IPHONE_SE = "iPhone SE"
let TRANSAC_PAYMETH = "pmethod"
let TRANSAC_FINDETAIL = "final"
let REF_PIN_TOKEN = "Pintoken"
let _PIN = "pin"
let _IS_CREDIT = "isCredit"
let _DRAW = "DRAW"
let _SGID = "sgID"
let _QID = "qid"
let _TITLE = "title"
let _HTEAM = "homeTeam"
let _ATEAM = "awayTeam"
let _SEGTYPE = "segType"
let _HM_POINT = "homePoint"
let _AW_POINT2 = "awayPoint"
let _DRW_POINT = "drawPoint"
let _CHOICES = "choices"
let _HOMCOL = "homeColor"
let _HOMREC = "homeRecord"
let _AWCOL = "awayColor"
let _AWREC = "awayRecord"

//Accounts IDS
let FIELD_TRANSAC_ID = "transactionId"
let FIELD_TRANSAC_AMOUNT = "amount";
let FIELD_TRANSAC_BALANCE  = "balance";
let FIELD_TRANSAC_MODE = "transactionMode";
let FIELD_TRANSAC_CURTYPE = "currencyType";
let FIELD_TRANSAC_TYPE = "transactionType";
let FIELD_TRANSAC_ACC_ID = "accountId";
let FIELD_TRANSAC_CLUID = "clientUid";
let FIELD_TRANSAC_STATUS = "status";
let FIELD_TRANSAC_FIN_DET = "finalDetail"
let FIELD_TRANSAC_TS = "ts";
let FIELD_MUTATED = "mutated";

let  FIELD_AGGRE_CREDIT_ = "aggregatedcredit";
let  FIELD_AGGRE_GAIN = "aggregatedgain";
let  FIELD_AGGRE_LOSS = "aggregatedlosses";
let  FIELD_VIRT_BALANCE = "virtualBalance";
let  FIELD_CREDIT_BALANCE = "creditBalance";
let  FIELD_ACC_USER_ID = "accountUserID";
let  FIELD_FULL_NAME = "fullname";
let  FIELD_LAST_UP = "lastupdate";
let FIELD_ACC_ID = "accountNumber"
let  FIELD_PHONE = "phone";


let alphas = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Z",]

/*******************************************************************************************/


public var AgentID:String = ""
public  var SERIAL = ""
var ACCESS_LEVEL:String = AccessLevel.noAccess.rawValue
var LOG_DOMAIN:String = ""



func dateFromString(_ string:String)->Date?{
    
    let df = DateFormatter()
    df.dateStyle = .short
    df.timeZone = TimeZone(secondsFromGMT: 0)
    df.dateFormat = "MM-dd-yyyy HH:mm"
    let date = df.date(from: string)
    return date
}

func stringFrom(_ date:Date)->String{
    
    let df = DateFormatter()
    df.dateStyle = .short
    df.timeZone = TimeZone(secondsFromGMT: 0)
    df.dateFormat = "MM-dd-yyyy HH:mm"
    let adate = df.string(from: date)
    return adate
}


func alert(title:String, message:String){
    let alert = NSAlert()
    alert.alertStyle = .warning
    alert.informativeText = message
    alert.messageText = title

    alert.runModal()
}


func log(_ message:String){
    Swift.print(message)
}

func getMachineSerial()->String{
    var serialNumber: String? {
        let platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice") )
        
        guard platformExpert > 0 else {
            return nil
        }
        
        guard let serialNumber = (IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformSerialNumberKey as CFString, kCFAllocatorDefault, 0).takeUnretainedValue() as? String) else {
            return nil
        }
        
        
        IOObjectRelease(platformExpert)
        
        return serialNumber
    }
    return ""
}

let QUESIDCOUNT = "quesID"

enum QuestionType :String{
    
    case regular = "Regular"
    case blaze = "Blaze"
}

func questionIDGenerators(type:QuestionType, league:String)-> String{
    
    let num = UserDefaults.standard.integer(forKey: QUESIDCOUNT)
    if type == .blaze{
        return "BLZ\(league)Question00\(num + 1)"
    }
    return "\(league)Question00\(num + 1)"
    
}

func incrementQNum(){
    var num = UserDefaults.standard.integer(forKey: QUESIDCOUNT)
    num = num + 1;
    UserDefaults.standard.set(num, forKey: QUESIDCOUNT);
}



// As Modal window:
func messageBox(_ title: String!, message: String! = nil,
                firstOption: String? = nil, secondOption: String? = nil, thirdOption: String? = nil,
                firstAction: (() -> ())? = nil, secondAction: (() -> ())? = nil, thirdAction: (() -> ())? = nil )  {
    
    let alert = NSAlert()
    
    alert.messageText = title ?? ""
    alert.informativeText = message ?? ""
    
    [firstOption, secondOption, thirdOption].forEach { if let option = $0 { alert.addButton(withTitle: option) } }
    [firstAction ?? {}, secondAction ?? {}, thirdAction ?? {}][alert.runModal().rawValue - 1000]?()
}

// As Sheet:
func sheetBox(_ title: String!, message: String? = nil,
              firstOption: String? = nil, secondOption: String? = nil, thirdOption: String? = nil,
              firstAction: @escaping (() -> ()), secondAction: @escaping (() -> ()))  {
    
    let alert = NSAlert()
    
    alert.messageText = title ?? ""
    alert.informativeText = message ?? ""
    
    [firstOption, secondOption, thirdOption].forEach { if let option = $0 { alert.addButton(withTitle: option) } }
    alert.beginSheetModal(for: NSApp.keyWindow!) { (response) in
        if(response == NSApplication.ModalResponse.alertFirstButtonReturn){
            firstAction()
        }else if (response == NSApplication.ModalResponse.alertSecondButtonReturn){
            secondAction()
        }
    }
    
}

/* Usage:
messageBox("You are removing recurring event. What should be done?", message: nil,
           
           firstOption: "Remove this event only",
           secondOption: "Remove all related events",
           thirdOption: "Cancel",
           
           /* UPDATE ONE EVENT */
    firstAction:
    {
        
},
    
    /* UPDATE ALL EVENTS */
    secondAction:
    {
        
},
    
    /* CANCELLING - DO NOTHING */
    thirdAction: nil
)

// Both closures and bottons are optional, hence can be omitted:
messageBox("Hello world")
 */
