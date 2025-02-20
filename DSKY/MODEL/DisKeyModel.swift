//
//  StatusModel.swift
//  ApoDisKey
//
//  Created by Gavin Eadie on Jul11/24 (copyright 2024-25)
//

import Foundation
import AVFoundation

public enum BackColor: Sendable {
    case off
    case white
    case yellow
    case green
    case orange
    case red
}

typealias Light = (String, BackColor)

typealias Display = (String, Bool)

@MainActor @Observable final class DisKeyModel {

    @MainActor static let shared = DisKeyModel()

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ .. properties relating to the application itself ..                                              ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
    public var fullSize = true
    public var haveCmdArgs = false

    public var windowX: CGFloat = -99.0
    public var windowY: CGFloat = -99.0
    public var windowW: CGFloat = -99.0
	public var windowH: CGFloat = -99.0

    public var ch15ResetCount = 0

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ .. the fourteen annunciator lamps resentating status on the DSKY top-left ..                     ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
    public var statusLights: [Int: Light] = [
            11: ("   ", .off),              //  ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮
            12: ("   ", .off),              //  ┆ UPLINK ┆ ┆  TEMP  ┆
            13: ("   ", .off),              //  ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮
            14: ("   ", .off),              //  ┆ NO ATT ┆ ┆ GIMBAL ┆
            15: ("   ", .off),              //  ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮
            16: ("   ", .off),              //  ┆  STBY  ┆ ┆  PROG  ┆
            17: ("   ", .off),              //  ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮
                                            //  ┆KEY REL ┆ ┆RESTART ┆
            21: ("   ", .off),              //  ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮
            22: ("   ", .off),              //  ┆OPR ERR ┆ ┆TRACKER ┆
            23: ("   ", .off),              //  ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮
            24: ("   ", .off),              //  ┆PRIODISP┆ ┆  ALT   ┆
            25: ("   ", .off),              //  ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮
            26: ("   ", .off),              //  ┆ NO DAP ┆ ┆  VEL   ┆
            27: ("   ", .off)               //  ╰╌╌╌╌╌╌╌╌╯ ╰╌╌╌╌╌╌╌╌╯
        ]

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ .. the electroluminescent DSKY top-right panel (initial values are cleared when AGC connects) .. ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
    public var elPowerOn = false                        // electroluminescent power (starts OFF)

    public var comp: Display = ("--", false)            // numbers (none for COMP), placard=dark
    public var prog: Display = ("__", false)
    public var verb: Display = ("__", false)            // numbers=35, placard=green
    public var noun: Display = ("__", false)

    public var reg1: Display = (" _____", true)
    public var reg2: Display = (" _____", false)        // what does "false" do here?
    public var reg3: Display = (" _____", true)

    public var r1Sign = (false, false)                  // blank prefix (± or blank)
    public var r2Sign = (false, false)
    public var r3Sign = (false, false)

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ .. network information for connecting to AGC (default values) ..                                 ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
    public var ipAddr: String = "localhost"
    public var ipPort: UInt16 = 19697
    public var network = Network()                  // initializes but doesn't start
}

extension DisKeyModel {
/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆  set light label texts for Apollo 11 • Command Module                          (Apollo CM 11-17) ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
    static let commandModule: [Int: Light] = [
        11: ("UPLINK\nACTY",   .off),
        12: ("NO ATT",         .off),
        13: ("STBY",           .off),
        14: ("KEY REL",        .off),
        15: ("OPR ERR",        .off),
        16: (" ",              .off),
        17: (" ",              .off),

        21: ("TEMP",           .off),
        22: ("GIMBAL\nLOCK",   .off),
        23: ("PROG",           .off),
        24: ("RESTART",        .off),
        25: ("TRACKER",        .off),
        26: (" ",              .off),
        27: (" ",              .off)
    ]

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ set light label texts for Apollo 11 • Lunar Module (Luminary099)               (Apollo LM 11-14) ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
    static let lunarModule0: [Int: Light] = [
        11: ("UPLINK\nACTY",   .off),
        12: ("NO ATT",         .off),
        13: ("STBY",           .off),
        14: ("KEY REL",        .off),
        15: ("OPR ERR",        .off),
        16: (" ",              .off),
        17: (" ",              .off),

        21: ("TEMP",           .off),
        22: ("GIMBAL\nLOCK",   .off),
        23: ("PROG",           .off),
        24: ("RESTART",        .off),
        25: ("TRACKER",        .off),
        26: ("ALT",            .off),
        27: ("VEL",            .off)
    ]

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ set light label texts for Apollo 11 • Lunar Module                             (Apollo LM 15-17) ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
    static let lunarModule1: [Int: Light] = [
        11: ("UPLINK\nACTY",   .off),
        12: ("NO ATT",         .off),
        13: ("STBY",           .off),
        14: ("KEY REL",        .off),
        15: ("OPR ERR",        .off),
        16: ("PRIO DISP",      .off),
        17: ("NO DAP",         .off),

        21: ("TEMP",           .off),
        22: ("GIMBAL\nLOCK",   .off),
        23: ("PROG",           .off),
        24: ("RESTART",        .off),
        25: ("TRACKER",        .off),
        26: ("ALT",            .off),
        27: ("VEL",            .off)
    ]

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆  set light label texts "powered off" mode ..                                                     ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
    static let OFF: [Int: Light] = [
        11: ("   ",            .off),
        12: ("   ",            .off),
        13: ("   ",            .off),
        14: ("   ",            .off),
        15: ("   ",            .off),
        16: ("   ",            .off),
        17: ("   ",            .off),

        21: ("   ",            .off),
        22: ("   ",            .off),
        23: ("   ",            .off),
        24: ("   ",            .off),
        25: ("   ",            .off),
        26: ("   ",            .off),
        27: ("   ",            .off)
    ]
}

func keyText(_ code: UInt16) -> String { keyDict[code] ?? "ERROR" }

let keyDict: [UInt16: String] = [
    17: "VERB",
    31: "NOUN",
    16: "0",
    01: "1",
    02: "2",
    03: "3",
    04: "4",
    05: "5",
    06: "6",
    07: "7",
    08: "8",
    09: "9",
    27: "-",
    26: "+",
    30: "CLR",
    99: "PRO",
    25: "KEY\nREL",
    28: "ENTR",
    18: "RSET"
]
