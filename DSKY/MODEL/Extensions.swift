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

let tt: (Bool, Bool) = (true, true)
let tf: (Bool, Bool) = (true, false)
let ft: (Bool, Bool) = (false, true)
let ff: (Bool, Bool) = (false, false)

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

struct FourByte {
    var byte_0: UInt8
    var byte_1: UInt8
    var byte_2: UInt8
    var byte_3: UInt8

    init(byte_0: UInt8, byte_1: UInt8, 
         byte_2: UInt8, byte_3: UInt8) {
        self.byte_0 = byte_0
        self.byte_1 = byte_1
        self.byte_2 = byte_2
        self.byte_3 = byte_3
    }

    init(_ bytes: Data) {
        self.init(byte_0: bytes[0], byte_1: bytes[2],
                  byte_2: bytes[2], byte_3: bytes[3])
    }

    var packet: Data { Data([byte_0, byte_1, byte_2, byte_3]) }

    var pretty: String { "\(ZeroPadByte(packet[0])) \(ZeroPadByte(packet[1])) " +
                         "\(ZeroPadByte(packet[2])) \(ZeroPadByte(packet[3]))" }
}


func prettyPrint(_ data: Data) {
    logger.log("\(ZeroPadByte(data[0])) \(ZeroPadByte(data[1])) \(ZeroPadByte(data[2])) \(ZeroPadByte(data[3]))")
}

func prettyString(_ data: Data) -> String {
    "\(ZeroPadByte(data[0])) \(ZeroPadByte(data[1])) \(ZeroPadByte(data[2])) \(ZeroPadByte(data[3]))"
}


func ZeroPadByte(_ code: UInt8, _ length: Int = 8) -> String {
    String(("000000000" + String(UInt16(code), radix: 2)).suffix(length))
}

func ZeroPadWord(_ code: UInt16, to length: Int = 15) -> String {
    String(("0000000000000000" + String(UInt16(code), radix: 2)).suffix(length))
}
