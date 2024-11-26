//
//  StatusModel.swift
//  ApoDisKey
//
//  Created by Gavin Eadie on Jul11/24.
//

import Foundation
import AVFoundation

@Observable
final class DisKeyModel: Sendable {

    static let shared = DisKeyModel()

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ .. the fourteen lights resentating status on the DSKY top-left ..                                ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
    public var statusLights : [Int: Light] = [
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

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ .. the electroluminescent DSKY top-right panel (initial values are cleared when AGC connects) .. ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
    public typealias Display = (String, Bool)

    public var comp: Display = ("--", false)            // numbers (none for COMP), placard=dark
    public var prog: Display = ("  ", true)
    public var verb: Display = ("88", true)             // numbers=35, placard=green
    public var noun: Display = ("88", true)

    public var reg1: Display = ("      ", true)
    public var reg2: Display = ("      ", false)        // TODO: what does "false" do here?
    public var reg3: Display = ("      ", true)

    public var r1Sign = (false, false)                  // blank prefix (± or blank)
    public var r2Sign = (false, false)
    public var r3Sign = (false, false)

    public var elPanelOff = false                       // electroluminescent power

    public let network = setNetwork()
}

extension DisKeyModel {
/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆  set light label texts for Apollo 11 • Command Module                             (Apollo 11-17) ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
    nonisolated(unsafe) static let CM : [Int: Light] = [
        11 : ("UPLINK\nACTY",   .off),
        12 : ("NO  ATT",        .off),
        13 : ("STBY",           .off),
        14 : ("KEY  REL",       .off),
        15 : ("OPR  ERR",       .off),
        16 : (" ",              .off),
        17 : (" ",              .off),

        21 : ("TEMP",           .off),
        22 : ("GIMBAL\nLOCK",   .off),
        23 : ("PROG",           .off),
        24 : ("RESTART",        .off),
        25 : ("TRACKER",        .off),
        26 : (" ",              .off),
        27 : (" ",              .off)
    ]

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ set light label texts for Apollo 11 • Lunar Module (Luminary099)                  (Apollo 11-14) ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
    nonisolated(unsafe) static let LM0 : [Int: Light] = [
        11 : ("UPLINK\nACTY",   .off),
        12 : ("NO  ATT",        .off),
        13 : ("STBY",           .off),
        14 : ("KEY  REL",       .off),
        15 : ("OPR  ERR",       .off),
        16 : (" ",              .off),
        17 : (" ",              .off),

        21 : ("TEMP",           .off),
        22 : ("GIMBAL\nLOCK",   .off),
        23 : ("PROG",           .off),
        24 : ("RESTART",        .off),
        25 : ("TRACKER",        .off),
        26 : ("ALT",            .off),
        27 : ("VEL",            .off)
    ]

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ set light label texts for Apollo 11 • Lunar Module                                (Apollo 15-17) ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
    nonisolated(unsafe) static let LM1 : [Int: Light] = [
        11 : ("UPLINK\nACTY",   .off),
        12 : ("NO  ATT",        .off),
        13 : ("STBY",           .off),
        14 : ("KEY  REL",       .off),
        15 : ("OPR  ERR",       .off),
        16 : ("PRIO DISP",      .off),
        17 : ("NO DAP",         .off),

        21 : ("TEMP",           .off),
        22 : ("GIMBAL\nLOCK",   .off),
        23 : ("PROG",           .off),
        24 : ("RESTART",        .off),
        25 : ("TRACKER",        .off),
        26 : ("ALT",            .off),
        27 : ("VEL",            .off)
    ]
}
