//
//  StatusModel.swift
//  ApoDisKey
//
//  Created by Gavin Eadie on Jul11/24 (copyright 2024-25)
//

// swiftlint:disable blanket_disable_command
// swiftlint:disable identifier_name
// swiftlint:disable comma

import Foundation
import AVFoundation

public enum BackColor: Sendable {
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

@MainActor
@Observable
final class DisKeyModel {

    static let shared = DisKeyModel()

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ .. properties relating to the application itself ..                                              ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
    public var fullSize = true
    public var haveCmdArgs = false

    public var fX: CGFloat = -99.0
    public var fY: CGFloat = -99.0

    public var logTimer = false

    public var ch15ResetCount = 0

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ .. the fourteen lights resentating status on the DSKY top-left ..                                ┆
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
            24: ("   ", .off),              //  ┆        ┆ ┆  ALT   ┆
            25: ("   ", .off),              //  ╭╌╌╌╌╌╌╌╌╮ ╭╌╌╌╌╌╌╌╌╮
            26: ("   ", .off),              //  ┆        ┆ ┆  VEL   ┆
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
  ┆ .. network imnformation for connecting to AGC ..                                                 ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
    public var ipAddr: String = "localhost"
    public var ipPort: UInt16 = 19697

    public var network = setNetwork()
}

extension DisKeyModel {
/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆  set light label texts for Apollo 11 • Command Module                          (Apollo CM 11-17) ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
    static let CM: [Int: Light] = [
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
    static let LM0: [Int: Light] = [
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
    static let LM1: [Int: Light] = [
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
