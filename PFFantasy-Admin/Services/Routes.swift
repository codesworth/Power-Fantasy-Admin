//
//  Routes.swift
//  CXFantasy-Admin
//
//  Created by Mensah Shadrach on 8/5/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

import Foundation
//import Alamofire
import CoreData

let BASEURL = "http://localhost:3000/api/v1"
let PATH_LEAGUE = "Leagues"
let BLAZEPATH = "BlazeLeague"
var CREDITPATH = "Credit"
var PATH_CONTEST = "Contests"
var PATH_PLAYERS = "Players"
var PATH_QUESTIONS = "Questions"
let PATH_TRANSACT = "Transactions"
let PATH_NEWUSERS = "NewUsers"


/***************************************************************************************/
 //CLOUD FUNCTION URLS

 var URL_QUESTIONS = "https://us-central1-xfantasy-423b8.cloudfunctions.net/postFantasyQuestion"
var URL_CONTESTS = "https://us-central1-xfantasy-423b8.cloudfunctions.net/postContests"
let URL_GET_ALL_PICKS = "https://us-central1-xfantasy-423b8.cloudfunctions.net/fetchContestedPicks"
 let URL_POST_ALL_CORRECT_PICKS = "https://us-central1-xfantasy-423b8.cloudfunctions.net/uploadCorrectPicks"
let URL_POST_LEADERBOARD = "https://us-central1-xfantasy-423b8.cloudfunctions.net/postLeaderBoard"
 /************************************************************************************/


var colors:[String:String] = [
    "Atlanta Hawks" : "#E03A3E",
    "Boston Celtics" :"#007A33",
    "Brooklyn Nets" : "#000000",
    "Charlotte Hornets": "#00788C",
    "Chicago Bulls": "#CE1141",
    "Cleveland Cavaliers" : "#6F263D",
    "Dallas Mavericks": "#00538C",
    "Denver Nuggets" : "#0E2240",
    "Detroit Pistons" : "#C8102E",
    "Golden State Warriors": "#006BB6",
    "Houston Rockets":"#CE1141",
    "Indiana Pacers" : "#002D62",
    "Los Angeles Clippers": "#C8102E",
    "Los Angeles Lakers": "#552583",
    "Memphis Grizzlies" : "#6189B9",
    "Miami Heat": "#98002E",
    "Milawaukee Bucks": "#00471B",
    "Minnesota Timberwolves": "#236192",
    "New Orleans Pelicans": "#C8102E",
    "New York Knicks": "#006BB6",
    "Oklahoma City Thunder" : "#EF3B24",
    "Orlando Magic": "#0077C0",
    "Philadelphia 76ers": "#006BB6",
    "Phoenix Suns": "#E56020",
    "Portland Trailblazers": "#E03A3E",
    "Sacremento Kings": "#5A2D81",
    "San Antonio Spurs": "#C4CED4",
    "Toronto Raptors": "#CE1141",
    "Utah Jazz" : "#002B5C",
    "Washington Wizards": "#E31837"
    
]

    


