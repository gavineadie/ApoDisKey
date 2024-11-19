//
//  StatusModel.swift
//  ApoDisKey
//
//  Created by Gavin Eadie on Jul11/24.
//

import Foundation
import AVFoundation

class DisKeyModel: ObservableObject {

    static let shared = DisKeyModel()

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ .. the fourteen lights resentating status on the DSKY top-left ..                                ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
    public var statusLights : [Int: Light]

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ .. the electroluminescent DSKY top-right panel (initial values are cleared when AGC connects) .. ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
    public typealias Display = (String, Bool)

    public var comp: Display = ("--", false)            // numbers (none for COMP), placard=dark
    public var prog: Display = ("19", true)
    public var verb: Display = ("35", true)             // numbers=35, placard=green
    public var noun: Display = ("77", true)

    public var reg1: Display = (" 54321", true)
    public var reg2: Display = ("-12345", false)        // TODO: what does "false" do here?
    public var reg3: Display = ("+88888", true)

    public var r1Sign = (false, false)                  // blank prefix (± or blank)
    public var r2Sign = (false, false)
    public var r3Sign = (false, false)

    public var elPanelOff = false                       // electroluminescent power

    public let network: Network

    private init() {

        let userDefaults = UserDefaults.standard

/*┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ defaults set by:                                                                                 │
  │         defaults write com.ramsaycons.ApoDisKey ipAddr "127.0.0.1"                               │
  │         defaults write com.ramsaycons.ApoDisKey ipPort 19697                                     │
  │ defaults removed by:                                                                             │
  │         defaults delete com.ramsaycons.ApoDisKey ipAddr                                          │
  │         defaults delete com.ramsaycons.ApoDisKey ipPort                                          │
  └──────────────────────────────────────────────────────────────────────────────────────────────────┘*/
        let ipAddr = userDefaults.string(forKey: "ipAddr") ?? "localhost"
        let ipPort = UInt16(userDefaults.integer(forKey: "ipPort")) == 0
                    ? 19697
                    : UInt16(userDefaults.integer(forKey: "ipPort"))

        logger.log("→→→ appDefaults: \(ipAddr):\(ipPort)")

#if os(iOS) || os(tvOS)
//      network = Network("192.168.1.232", 19697)   // .. Ubuntu
        network = Network("192.168.1.100", 19698)   // .. MaxBook
#else
//      network = Network("192.168.1.232", 19697)   // .. Ubuntu
//      network = Network(192.168.1.100, ipPort)    // 172.19.131.37
        network = Network("192.168.1.100", 19698)   // .. MaxBook
#endif

        statusLights = [                // initial state
            11: ("", .off),             //  ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮
            12: ("", .off),             //  ┆ UPLINK ┆ ┆  TEMP  ┆
            13: ("", .off),             //  ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮
            14: ("", .off),             //  ┆ NO ATT ┆ ┆ GIMBAL ┆
            15: ("", .off),             //  ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮
            16: ("", .off),             //  ┆  STBY  ┆ ┆  PROG  ┆
            17: ("", .off),             //  ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮
                                        //  ┆KEY REL ┆ ┆RESTART ┆
            21: ("", .off),             //  ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮
            22: ("", .off),             //  ┆OPR ERR ┆ ┆TRACKER ┆
            23: ("", .off),             //  ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮
            24: ("", .off),             //  ┆        ┆ ┆  ALT   ┆
            25: ("", .off),             //  ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮
            26: ("", .off),             //  ┆        ┆ ┆  VEL   ┆
            27: ("", .off)              //  ╰╌╌╌╌╌╌╌╌╯ ╰╌╌╌╌╌╌╌╌╯
        ]
    }
}

extension DisKeyModel {
/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆  set light label texts for Apollo 11 • Command Module                                            ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
    static let comanche055 : [Int: Light] = [
        11 : ("UPLINK\nACTY", .off),
        12 : ("NO  ATT", .off),
        13 : ("STBY", .on),
        14 : ("KEY  REL", .off),
        15 : ("OPR  ERR", .off),
        16 : ("PRIO\nDISP", .off),        // CM lights
        17 : ("NO DAP", .off),            // CM lights

        21 : ("TEMP", .off),
        22 : ("GIMBAL\nLOCK", .off),
        23 : ("PROG", .off),
        24 : ("RESTART", .off),
        25 : ("TRACKER", .off),
        26 : ("ALT", .off),
        27 : ("VEL", .off)
    ]

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ set light label texts for Apollo 11 • Lunar Module                                               ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
    static let luminary099 : [Int: Light] = [
        11 : ("UPLINK\nACTY", .off),
        12 : ("NO  ATT", .off),
        13 : ("STBY", .on),
        14 : ("KEY  REL", .off),
        15 : ("OPR  ERR", .off),
        16 : ("", .off),
        17 : ("", .off),

        21 : ("TEMP", .off),
        22 : ("GIMBAL\nLOCK", .off),
        23 : ("PROG", .off),
        24 : ("RESTART", .off),
        25 : ("TRACKER", .off),
        26 : ("ALT", .off),
        27 : ("VEL", .off)
    ]
}
