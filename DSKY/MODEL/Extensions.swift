//
//  Extensions.swift
//  DSKY
//
//  Created by Gavin Eadie on 7/21/24.
//

import Foundation

let bit1: UInt16 = 0b0000_0000_0000_0001
let bit2: UInt16 = 0b0000_0000_0000_0010
let bit3: UInt16 = 0b0000_0000_0000_0100
let bit4: UInt16 = 0b0000_0000_0000_1000
let bit5: UInt16 = 0b0000_0000_0001_0000
let bit6: UInt16 = 0b0000_0000_0010_0000
let bit7: UInt16 = 0b0000_0000_0100_0000
let bit8: UInt16 = 0b0000_0000_1000_0000
let bit9: UInt16 = 0b0000_0001_0000_0000
let bit10: UInt16 = 0b0000_0010_0000_0000

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆                                                                                                  ┆
  ┆ The sign (or blank) characters, which can be "+" or "-" or " " is based of the 0/1 values of     ┆
  ┆ the "+" and "-" bits if the command sent to the DSKY.  The book says:                            ┆
  ┆                                                                                                  ┆
  ┆     .. bit 11 contains discrete information, a "1" (true) indicating that the discrete is on.    ┆
  ┆                                                                                                  ┆
  ┆     A one in bit 11 of DSPTAB+1 indicates that R3 has a plus sign.                               ┆
  ┆     If the sign bits associated with a given register are both zeros, then the content of        ┆
  ┆     that particular register is octal; if either of the bits is set, the register content is     ┆
  ┆     decimal data.                                                                                ┆
  ┆                                                                                                  ┆
  ┆ or:                                                                                              ┆
  ┆                                                                                                  ┆
  ┆     .. it is unclear to me how the +/- signs can be blanked, using the commands outlined below.  ┆
  ┆     It seems as though it would involve sending two output-channel commands, (say) with both     ┆
  ┆     1+ and 1- bits zeroed.                                                                       ┆
  ┆                                                                                                  ┆
  ┆     .. the most recent 1+ and 1- flags are saved. If both are 0, then the +/- sign is blank;     ┆
  ┆     if 1+ is set and 1- is not, then the '+' sign is displayed; if just the 1- flag is set,      ┆
  ┆     or if both 1+ and 1- flags are set, the '-' sign is displayed                                ┆
  ┆                                                                                                  ┆
  ┆                                                                                                  ┆
  ┆                                           +1    +0                                               ┆
  ┆                                         +-----+-----+                                            ┆
  ┆                                         |     |     |                                            ┆
  ┆                                     -1  | "-" | "-" |                                            ┆
  ┆                                         |     |     |                                            ┆
  ┆                                         +-----+-----+                                            ┆
  ┆                                         |     |     |                                            ┆
  ┆                                     -0  | "+" | " " |                                            ┆
  ┆                                         |     |     |                                            ┆
  ┆                                         +-----+-----+                                            ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/

public func plu_min(_ pm: (Bool, Bool)) -> String {
    switch pm {
        case (false, false): return " "
        case (true, false): return "+"
        case (false, true): return "-"
        case (true, true): return "-"
    }
}


func prettyPrint(_ data: Data) {
    logger.log("\(ZeroPadByte(data[0])) \(ZeroPadByte(data[1])) \(ZeroPadByte(data[2])) \(ZeroPadByte(data[3]))")
}

func prettyString(_ data: Data) -> String {
    "\(ZeroPadByte(data[0])) \(ZeroPadByte(data[1])) \(ZeroPadByte(data[2])) \(ZeroPadByte(data[3]))"
}


private func ZeroPadByte(_ code: UInt8, _ length: Int = 8) -> String {
    String(("000000000" + String(UInt16(code), radix: 2)).suffix(length))
}

func ZeroPadWord(_ code: UInt16, to length: Int = 15) -> String {
    String(("0000000000000000" + String(UInt16(code), radix: 2)).suffix(length))
}

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
let symbolArray = ["----",
                   "3435", "3233", "2531", "2324", "2122",
                   "1415", "1213", "..11", "N1N2", "V1V2", "M1M2"]

let digitsDict = [  0: "_",
                    21: "0",  3: "1", 25: "2", 27: "3", 15: "4",
                    30: "5", 28: "6", 19: "7", 29: "8", 31: "9"]

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆          Bit 1 lights the "PRIO DISP" indicator       -- ?                                       ┆
  ┆          Bit 2 lights the "NO DAP" indicator          -- ?                                       ┆
  ┆          Bit 3 lights the "VEL" indicator.                                                       ┆
  ┆          Bit 4 lights the "NO ATT" indicator          -- in left column                          ┆
  ┆          Bit 5 lights the "ALT" indicator.                                                       ┆
  ┆          Bit 6 lights the "GIMBAL LOCK" indicator.                                               ┆
  ┆          Bit 7                                        -- ?                                       ┆
  ┆          Bit 8 lights the "TRACKER" indicator.                                                   ┆
  ┆          Bit 9 lights the "PROG" indicator.                                                      ┆
  ┆                                                                                                  ┆
  ┆ Note:                     "TEMP" and                                                             ┆
  ┆                           "RESTART" are not controlled here                                      ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
let ch010Labs = [" ??? ",
                 "PROG ",    // b9
                 "TRAK ",    // b8
                 " b7? ",    // b7
                 "GMBL ",    // b6
                 " ALT ",    // b5
                 "NOAT ",    // b4
                 " VEL ",    // b3
                 "NODP ",    // b2
                 "PRIO ",    // b1
                 "NEVER"]

func prettyCh010(_ code: UInt16) -> String {
    let bitArray = ZeroPadWord(code, to: 10).split(separator: "")
    var catString = ""

    for index in 0..<bitArray.count {
        catString += (bitArray[index] == "0") ? "  ↓  " : ch010Labs[index]
    }

    return catString
}

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ All LATCHES                                                                                      ┆
  ┆                                                                                                  ┆
  ┆          Bit 1:                                                                                  ┆
  ┆          Bit 2: Lights the "COMP ACTY" indicator.                                                ┆
  ┆          Bit 3: Lights the "UPLINK ACTY" indicator.                                              ┆
  ┆          Bit 4: Lights the "TEMP" indicator.                                                     ┆
  ┆          Bit 5: Lights the "KEY REL" indicator.                                                  ┆
  ┆          Bit 6: Flashes the VERB/NOUN display areas.                                             ┆
  ┆                 This means to flash the digits in the NOUN and VERB areas.                       ┆
  ┆          Bit 7: Lights the "OPR ERR" indicator.                                                  ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
let ch011Labs = [" ??? ",    // b8
                 "OPER ",    // b7
                 "V+N↕︎ ",    // b6
                 "KREL ",    // b5
                 "TEMP ",    // b4
                 "UPLK ",    // b3
                 "COMP ",    // b2
                 " ??? ",    // b1
                 "NEVER"]

func prettyCh011(_ code: UInt16) -> String {
    let bitArray = ZeroPadWord(code, to: 8).split(separator: "")
    var catString = "          "

    for index in 0..<bitArray.count {
        catString += (bitArray[index] == "0") ? "  ↓  " : ch011Labs[index]
    }

    return catString
}

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆          Bit 1:               AGC warning                                                        ┆
  ┆          _                                                                                       ┆
  ┆          _                                                                                       ┆
  ┆          Bit 4:            TEMP lamp                                                             ┆
  ┆          Bit 5:           KEY REL lamp                                                           ┆
  ┆          Bit 6:          VERB/NOUN flash                                                         ┆
  ┆          Bit 7:         OPER ERR lamp                                                            ┆
  ┆          Bit 8:        RESTART lamp                                                              ┆
  ┆          Bit 9:       STBY lamp                                                                  ┆
  ┆          Bit 10:     EL off                                                                      ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
let ch163Labs = [" EL↓ ",    // b10
                 "STBY ",    // b9
                 "RSRT ",    // b8
                 "OPER ",    // b7
                 "V+N↕︎ ",    // b6
                 "KREL ",    // b5
                 "TEMP ",    // b4
                 "  3  ",    // b3
                 "  2  ",    // b2
                 " AGC ",    // b1
                 "NEVER"]

func prettyCh163(_ code: UInt16) -> String {
    let bitArray = ZeroPadWord(code, to: 10).split(separator: "")
    var catString = ""

    for index in 0..<bitArray.count {
        catString += (bitArray[index] == "0") ? "  ↓  " : ch163Labs[index]
    }

    return catString
}


/*┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  ┃ File stuff ..                                                                                    ┃
  ┃──────────────────────────────────────────────────────────────────────────────────────────────────┃
  ┃ .. establishDirectory:                                                                           ┃
  ┃ .. readInitializing:                                                                             ┃
  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛*/

func establishDirectory() -> URL { URL(fileURLWithPath: "~/DSKY") }

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

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ File stuff ..                                                                                    ┆
  ┆ .. readCanned: reads DSKY channel i/o actions from a file and injects them into the DSKY ..      ┆
  ┆     "#" .. a comment (ignore)                                                                    ┆
  ┆     "--" .. a comment (ignore)                                                                   ┆
  ┆     "!" .. send remainer of the line to logger                                                   ┆
  ┆     "-end-of-file-" .. stop reading the file                                                     ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
func readCanned(path: String) {
    logger.log("canned script: \(path)")
    do {
        var timerDeadline: TimeInterval = Date.now.timeIntervalSinceNow
        let initContent = try String(contentsOfFile: path, encoding: .utf8)
        let lineArray = initContent.components(separatedBy: .newlines)

        for line in lineArray {
            let words = line
                .components(separatedBy: .whitespaces)
                .filter({!$0.isEmpty})
            if words.isEmpty || words[0].starts(with: /#|--/) || words.count < 3 { continue }
            if words[0].starts(with: "-end-of-file-") { return }

            let delaySecs = Double(Int(words[0]) ?? 0) / 1000.0
            timerDeadline += delaySecs

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/

            Timer.scheduledTimer(withTimeInterval: timerDeadline, repeats: false) { _ in

                if words[0].starts(with: "!") {
                    logger.log("!!\(line)")
                } else {
                    if let channel = UInt16(words[1], radix: 8),
                       let action = UInt16(words[2], radix: 8) {
                        channelAction(channel, action)
                    } else {
                        logger.log("'\(line)' -- bad format")
                    }
                }

            }
        }
    } catch {
        print(error)
    }

}
