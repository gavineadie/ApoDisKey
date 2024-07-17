//
//  PacketRecv.swift
//  DSKY
//
//  Created by Gavin Eadie on 7/16/24.
//

import Foundation

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ Converts a 4-byte yaAGC channel i/o packet to integer channel-number and value ..                ┆
  ┆╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┆
  ┆ bytes: 00pppppp 01pppddd 10dddddd 11dddddd                                                       ┆
  ┆        ^^       ^^       ^^       ^^            packet validation bits                           ┆
  ┆╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┆
  ┆           ppppppppp is the 9-bit channel               ddddddddddddddd is the 15-bit value.      ┆
  ┆                                                                                                  ┆
  ┆            00pppppp                                           01pppddd                           ┆
  ┆             << 3                                          << 12                                  ┆
  ┆    0000000pppppp---                                    ddd------------                           ┆
  ┆                                                                                                  ┆
  ┆            01pppddd                                           10dddddd                           ┆
  ┆                >> 3                                             << 6                             ┆
  ┆    0000000------ppp                                    ---dddddd------                           ┆
  ┆                                                                                                  ┆
  ┆                   u is the "u-bit"                            11dddddd                           ┆
  ┆                                                                                                  ┆
  ┆            00pppppp                                    ---------dddddd                           ┆
  ┆                                                                                                  ┆
  ┆            --u-----                                                                              ┆
  ┆                                                                                                  ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/

/// This function is the reverse of FormIoPacket:
/// A 4-byte packet representing yaAGC channel i/o can be converted to an integer channel-number and value.
func parseIoPacket (_ data: Data) -> (UInt16, UInt16, Bool)? {

    guard data.count == 4 else {
        logger.log("\(#function): not four bytes")
        return nil
    }

    let byte = [UInt8](data)

    if (byte[0] / 64) != 0 || (byte[1] / 64) != 1 ||
       (byte[2] / 64) != 2 || (byte[3] / 64) != 3 {
        logger.log("\(#function): prefix bits wrong [\(prettyString(data))]")
        return nil
    }

    let channel: UInt16 = UInt16(byte[0] & UInt8(0b00111111)) << 3 |
                          UInt16(byte[1] & UInt8(0b00111000)) >> 3

    let value: UInt16 =   UInt16(byte[1] & UInt8(0b00000111)) << 12 |
                          UInt16(byte[2] & UInt8(0b00111111)) << 6 |
                          UInt16(byte[3] & UInt8(0b00111111))

    switch channel {
        case 0o010:                 // DSKY
            dskyInterpretation(value)

        case 0o011,                 // flags for indicator lamps
             0o012,                 // CM and LM actions ..
             0o013,                 // DSKY lamp tests ..
             0o014:                 // CM and LM Gyro celection ..
            logger.log("    channel \(channel, format: .octal(minDigits: 3)): \(ZeroPadWord(value))")

        case 0o163...0o177:
            logger.log("»»» fiction \(channel, format: .octal(minDigits: 3)): \(ZeroPadWord(value))")

        default:
            logger.log("••• channel \(channel, format: .octal(minDigits: 3)): \(ZeroPadWord(value))")
    }

    return (channel, value, (byte[0] & 0b00100000) > 0)
}

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
func dskyInterpretation(_ code: UInt16) {

    let symbolArray = ["----",
                       "3435", "3233", "2531", "2324", "2122",
                       "1415", "1213", "..11", "N1N2", "V1V2", "M1M2"]

    let digitsDict = [  0: "_",
                       21: "0",  3: "1", 25: "2", 27: "3", 15: "4",
                       30: "5", 28: "6", 19: "7", 29: "8", 31: "9"]

    let  AAAA = code >> 11

    switch AAAA {
        case 12:
            logger.log("""
                ***    DSKY 010: \(ZeroPadWord(code).dropLast(10)) \
                \(ZeroPadWord(code).dropFirst(5).dropLast(9)) \
                \(ZeroPadWord(code).dropFirst(6)) \
                lights \(ZeroPadWord((code & 0b0000_0111_1111_1111), to: 9))
                """)

        case 0:
            return // logger.log("ooo    DSKY 010: \(ZeroPadWord(code))")

        default:

            let BBBBB = code & 0b0000_0100_0000_0000 // >> 10
            let CCCCC = code & 0b0000_0011_1110_0000 // >> 5
            let DDDDD = code & 0b0000_0000_0001_1111 // >> 0

            var aStr = "????"
            if AAAA < symbolArray.count {
                aStr = symbolArray[Int(AAAA)]
            }
            let cStr = digitsDict[Int(CCCCC)] ?? "?"
            let dStr = digitsDict[Int(DDDDD)] ?? "?"

            logger.log("""
                >>>    DSKY 010: \(ZeroPadWord(code).dropLast(10)) \
                \(ZeroPadWord(code).dropFirst(5).dropLast(5)) \
                \(ZeroPadWord(code).dropFirst(10)) \
                (\(aStr) ±\(BBBBB == 0 ? "↓" : "↑") "\(cStr)\(dStr)\"
                """)
    }

    return
}
