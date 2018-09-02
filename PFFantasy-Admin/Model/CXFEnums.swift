//
//  CXFEnums.swift
//  CXFantasy
//
//  Created by Mensah Shadrach on 8/23/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

import Foundation

enum CXFClaimCategory:Int{
    case withdrawal = 1
    case deposit
    case inconsistentBalance
    case reportUser
    case other
}

enum CXFCState:String {
    case active = "Active Contests"
    case completed = "Completed Contest"
}


enum LeagueType:String {
    case EPL = "EPL"
    case LaLiga = "La Liga"
    case UCL = "UEFA CL"
    case SERIE_A = "Serie A"
    case NBA = "NBA"
}

enum BlazeSegTypes:Int{
    case typeOne = 100
    case typeTwo = 200
}


enum CXFTransactionType:Int {
    case withdrawal = 1
    case deposit = 2
}

enum CXFCreditType:Int {
    case normalCurrency = 0
    case cryptoCurrency
}

enum CXFPaymentMethod:Int{
    case mobile = 1
    case crypto = 2
}


public enum CXFFAVS:String{
    
    case NO_SPECIFIC = "NOFAV"
}


enum CXFErrorType:Error{
    case networkError
    case unknownError
    case corruptData
    case insufficientFunding
    case maxNumberExceeds
    
}

enum CXFTransactionState:Int {
    case pending = 1
    case success = 2
    case failed = 3
}

enum CXFAnswerType:Int {
    case Normal = 1
    case Choice = 2
    case ThunderBolt = 3
}

enum ContestType:String {
    case regular = "Regular"
    case blaze = "Blaze"
}

enum FetchPropertyKeys:String{
    
    case creditAccountId = "accountNo"
    case playerUID = "uid"
    case accountPlayerid = "accountUserID"
}

enum ContestStatus:Int{
    
    case available = 40
    case cappedOut = 45
    case unsolved = 50
    case expired = 60
}

enum TRANSACTION_TYPE:Int16{
    case DEBIT = 2000
    case CREDIT = 2010
}


enum TRANSACTION_MODE:Int32{
    case DEPOSIT = 2020
    case CONTEST_ENTRY = 2040
    case CONTEST_WINS = 2050
    case CASHOUT = 2030
    
}


enum CURRENCY_TYPE:Int32 {
    case CASH = 2060
    case VIRTUAL = 2070
}


enum STATUS:Int32 {
    case PENDING = 5100
    case COMPLETED = 5200
    case REJECTED = 5500;
}

enum ContestPaymentType:Int32{
    case VIRTUAL = 500
    case CASH = 600
}


struct CXFError:Error{
    
    var errorType:CXFErrorType
    var info:String?
    var code:Int
    
    init(type:CXFErrorType, info:String?, code:Int) {
        errorType = type
        self.info = info
        self.code = code
    }
}
