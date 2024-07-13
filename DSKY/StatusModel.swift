//
//  StatusModel.swift
//  DSKY
//
//  Created by Gavin Eadie on 7/11/24.
//

import Foundation

enum BackColor {
    case off
    case on
    case white
    case yellow
    case green
    case orange
}

var statusArray: [(String, BackColor)] = [ 
    ("UPLINK\nACTY", .off),             // #0
    ("NO  ATT", .off),                  // #1
    ("STBY", .off),                     // #2
    ("KEY  REL", .off),                 // #3
    ("OPR  ERR", .off),                 // #4

    ("TEMP", .on),                      // #5
    ("GIMBAL\nLOCK", .off),             // #6
    ("PROG", .off),                     // #7
    ("RESTART", .off),                  // #8
    ("TRACKER", .off),                  // #9
    ("ALT", .off),                      // #10
    ("VEL", .off)                       // #11
]

func allOn() {
    logger.log("\(#function) ..")
    for index in 0..<statusArray.count {
        statusArray[index].1 = .on
    }
}
