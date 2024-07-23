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
/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ Network (singleton) - only one AGC per mission                                                   ┆
  ┆     AGC_Communication_Channel                                                                    ┆
  ┆         Open, Send, Revc .. four-byte packets                                                    ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/

//    public let mainBundle = Bundle.main
//    public let filesBase: URL

    public let network: Network
    public var netFailCode = 0

    public var lights: [Int: Light]

    static let shared = DisKeyModel()

    private init() {

//        filesBase = establishDirectory()

#if os(iOS) || os(tvOS)
        network = Network("192.168.1.232", 19697) // .. Ubuntu
//      network = Network("192.168.1.100", 19697) // .. MaxBook
#else
//      network = Network("192.168.1.232", 19697) // .. Ubuntu
        network = Network("127.0.0.1", 19697)
#endif

        lights = [ 11: ("", .off),
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
    }

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/

    func luminary099() {
        lights[11] = ("UPLINK\nACTY", .off)
        lights[12] = ("NO  ATT", .off)
        lights[13] = ("STBY", .on)
        lights[14] = ("KEY  REL", .off)
        lights[15] = ("OPR  ERR", .off)
        lights[16] = ("", .off)
        lights[17] = ("", .off)

        lights[21] = ("TEMP", .off)
        lights[22] = ("GIMBAL\nLOCK", .off)
        lights[23] = ("PROG", .off)
        lights[24] = ("RESTART", .off)
        lights[25] = ("TRACKER", .off)
        lights[26] = ("ALT", .off)
        lights[27] = ("VEL", .off)
    }

    func statusAllOff() {
        logger.log("... \(#function)")
        for (key, _) in lights { lights[key] = ("« OFF »", .off) }
        lights[17] = ("ALPHA\nTEST 2", .red)
    }

    func statusAllOn() {
        logger.log("... \(#function)")
        for (key, _) in lights { lights[key] = ("YELLOW", .yellow) }
    }

    func statusAlphaOn() {
        lights[16] = ("ALPHA\nTEST 1", .red)
        lights[17] = ("ALPHA\nTEST 2", .red)
    }


/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ .. the initial values don't mean anything, and the AGC sets them when the DSKY connects          ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
    public typealias Display = (String, Bool)

    public var comp: Display = ("00", false)
    public var prog: Display = ("19", true)
    public var verb: Display = ("35", false)
    public var noun: Display = ("77", true)

    public var register1: Display = (" 98765", true)
    public var register2: Display = ("-12345", false)
    public var register3: Display = ("+88888", true)

    public var reg1PlusMinus = (false, false)
    public var reg2PlusMinus = (false, false)
    public var reg3PlusMinus = (false, false)

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ the KeyPad has no lights or colors                                                               ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
    public var keyPad = 0
}

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
    File stuff ..
    .. establishDirectory:
    .. readInitializing:
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/

func establishDirectory() -> URL {
    return URL(fileURLWithPath: "~/DSKY")
}

func readInitializing() {

    if let path = Bundle.main.path(forResource: "Initialize", ofType: "txt"){
        do {
            let initContent = try String(contentsOfFile: path, encoding: .utf8)
            let lineArray = initContent.components(separatedBy: .newlines)
            for line in lineArray {
                logger.log("INIT: \(line)")
            }
        } catch {
            print(error)
        }
    }

}

func readCanned() -> [Data] {

    var packetArray = [Data]()
    
    if let path = Bundle.main.path(forResource: "Apollo11-landing", ofType: "canned"){
        do {
            let initContent = try String(contentsOfFile: path, encoding: .utf8)
            let lineArray = initContent.components(separatedBy: .newlines)

            for line in lineArray {
                if line.isEmpty || "!# ".contains(line.first!) { continue }
                let words = line.components(separatedBy: .whitespaces)
                if words.count > 2 {
                //   let milliSec = Int(words[0])!

                    packetArray.append(formIoPacket(UInt16(words[1], radix: 8)!,
                                                    UInt16(words[2], radix: 8)!))
                }
            }
        } catch {
            print(error)
        }
    }

    return packetArray
}


func cycleSecondsInR3() {
    
    let _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
        let timeString = String(String(Date.timeIntervalSinceReferenceDate)
            .dropFirst(4)
            .prefix(5))
        DisKeyModel.shared.register3 = ("+\(timeString)", true)
    }

}

func cycleCanned() {

    let packets = readCanned()
    var packetIndex = 0

    let _ = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
        if packetIndex < packets.count {
            logger.log("\(packetIndex): \(prettyString(packets[packetIndex]))")
            let bytes = parseIoPacket(packets[packetIndex])
            packetIndex += 1
        }
    }

}
