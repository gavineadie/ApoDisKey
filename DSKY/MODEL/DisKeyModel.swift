//
//  StatusModel.swift
//  DSKY
//
//  Created by Gavin Eadie on 7/11/24.
//

import Foundation

public enum BackColor {
    case off
    case on
    case white
    case yellow
    case green
    case orange
    case red
}

typealias Light = (String, BackColor)
typealias Display = (String, Bool)

@Observable
class DisKeyModel {

    public var statusFooter = " ••• "

    public let network: Network

    public var statusLights = [
        11: ("", BackColor.off),                  // initial state
        12: ("", .off),
        13: ("", .off),
        14: ("", .off),
        15: ("", .off),
        16: ("", .off),
        17: ("", .off),

        21: ("", .off),
        22: ("", .off),
        23: ("", .off),
        24: ("", .off),
        25: ("", .off),
        26: ("", .off),
        27: ("", .off)
    ]

    static let shared = DisKeyModel()

    private init() {

#if os(iOS) || os(tvOS)
//      network = Network("192.168.1.232", 19697)   // .. Ubuntu
        network = Network("192.168.1.100", 19698)   // .. MaxBook
#else
//      network = Network("192.168.1.232", 19697)   // .. Ubuntu
        network = Network("127.0.0.1", 19697)
#endif

    }

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ .. the initial Display values don't mean anything; the AGC sets them when the DSKY connects      ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
    public typealias Display = (String, Bool)

    public var comp: Display = ("--", false)            // numbers (none for COMP), placard=dark
    public var prog: Display = ("19", true)
    public var verb: Display = ("35", true)             // numbers=35, placard=green
    public var noun: Display = ("77", true)

    public var reg1: Display = (" 98765", true)
    public var reg2: Display = ("-12345", false)        // TODO: what does "false" do here?
    public var reg3: Display = ("+88888", true)

    public var r1Sign = (false, false)                  // blank prefix (± or blank)
    public var r2Sign = (false, false)
    public var r3Sign = (false, false)

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ the KeyPad has no lights or colors                                                               ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
    public var keyPad = 0


/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ set light label texts for Apollo 11 • Lunar Module                                               ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
    func luminary099() {
        statusLights[11] = ("UPLINK\nACTY", .off)
        statusLights[12] = ("NO  ATT", .off)
        statusLights[13] = ("STBY", .on)
        statusLights[14] = ("KEY  REL", .off)
        statusLights[15] = ("OPR  ERR", .off)
        statusLights[16] = ("", .off)
        statusLights[17] = ("", .off)

        statusLights[21] = ("TEMP", .off)
        statusLights[22] = ("GIMBAL\nLOCK", .off)
        statusLights[23] = ("PROG", .off)
        statusLights[24] = ("RESTART", .off)
        statusLights[25] = ("TRACKER", .off)
        statusLights[26] = ("ALT", .off)
        statusLights[27] = ("VEL", .off)

        footerText("Apollo 11 • LM", reset: true)
    }

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆  set light label texts for Apollo 11 • Command Module                                            ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
    func comanche055() {
        statusLights[11] = ("UPLINK\nACTY", .off)
        statusLights[12] = ("NO  ATT", .off)
        statusLights[13] = ("STBY", .on)
        statusLights[14] = ("KEY  REL", .off)
        statusLights[15] = ("OPR  ERR", .off)
        statusLights[16] = ("PRIO\nDISP", .off)         // CM lights
        statusLights[17] = ("NO DAP", .off)             // CM lights

        statusLights[21] = ("TEMP", .off)
        statusLights[22] = ("GIMBAL\nLOCK", .off)
        statusLights[23] = ("PROG", .off)
        statusLights[24] = ("RESTART", .off)
        statusLights[25] = ("TRACKER", .off)
        statusLights[26] = ("ALT", .off)
        statusLights[27] = ("VEL", .off)

        footerText("Apollo 11 • CM", reset: true)
    }

}
