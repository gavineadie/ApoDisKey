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

    let model = DisKeyModel.shared

    guard data.count == 4 else {
        logger.log("\(#function): not four bytes")
        return nil
    }

    let byte = [UInt8](data)

    if ((byte[0] == 0xff) &&
        (byte[1] == 0xff) &&
        (byte[2] == 0xff) &&
        (byte[3] == 0xff)) {
        logger.log("       111111111 111111111111111")
        return nil
    }

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

        case 0o011:                 // flags for indicator lamps
            logger.log("»»» display \(ZeroPadWord(value, to: 8)) bits")
            model.comp = ("", value & 0x02 > 0)

        case 0o012,                 // CM and LM actions ..
             0o013,                 // DSKY lamp tests ..
             0o014:                 // CM and LM Gyro celection ..
//            logger.log("    channel \(channel, format: .octal(minDigits: 3)): \(ZeroPadWord(value))")
            break

        case 0o005...0o006, 0o015...0o035:
//            logger.log("»»» fiction \(channel, format: .octal(minDigits: 3)): \(ZeroPadWord(value))")
            break

        case 0o163:
            logger.log("»»» DSKY163 \(ZeroPadWord(value, to: 10)) bits")

        case 0o164...0o177:
            logger.log("»»» fiction \(channel, format: .octal(minDigits: 3)): \(ZeroPadWord(value))")

        default:
            logger.log("??? channel \(channel, format: .octal(minDigits: 3)): \(ZeroPadWord(value))")

    }

    return (channel, value, (byte[0] & 0b00100000) > 0)
}

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
let symbolArray = ["----",
                   "3435", "3233", "2531", "2324", "2122",
                   "1415", "1213", "..11", "N1N2", "V1V2", "M1M2"]

let digitsDict = [  0: "_",
                    21: "0",  3: "1", 25: "2", 27: "3", 15: "4",
                    30: "5", 28: "6", 19: "7", 29: "8", 31: "9"]

func dskyInterpretation(_ code: UInt16) {
    let model = DisKeyModel.shared

    let  rowCode = (code & 0b01111_0_00000_00000) >> 11

    switch rowCode {
        case 12:
            logger.log("""
                ***    DSKY 010: \(ZeroPadWord(code).prefix(5))   \
                \(ZeroPadWord(code).dropFirst(5)) \
                lights \(ZeroPadWord((code & 0b0000_0111_1111_1111), to: 9))
                """)

        case 0:
            return // logger.log("ooo    DSKY 010: \(ZeroPadWord(code))")

        default:

//            logger.log("""
//                !!!    DSKY 010: \(ZeroPadWord(code).prefix(4))_\
//                \(ZeroPadWord(code).prefix(5).suffix(1))_\
//                \(ZeroPadWord(code).dropFirst(5).dropLast(5))_\
//                \(ZeroPadWord(code).dropFirst(10))
//                """)

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
                                  -AAAA B CCCCC DDDDD
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
            let BBBBB = (code & 0b00000_1_00000_00000) >> 10
            let CCCCC = (code & 0b0000_0011_1110_0000) >> 5
            let DDDDD = (code & 0b0000_0000_0001_1111) >> 0

            var aStr = "????"
            if rowCode < symbolArray.count {
                aStr = symbolArray[Int(rowCode)]
            }
            let cStr = digitXlate(CCCCC)
            let dStr = digitXlate(DDDDD)

            logger.log("""
                >>>    DSKY 010: \(ZeroPadWord(code).prefix(4)) \
                \(ZeroPadWord(code).prefix(5).suffix(1)) \
                \(ZeroPadWord(code).dropFirst(5).dropLast(5)) \
                \(ZeroPadWord(code).dropFirst(10)) \
                (\(aStr) ±\(BBBBB == 0 ? "↓" : "↑") "\(cStr)\(dStr)\"
                """)

            switch rowCode {
                case 1:         // "3435"
                    model.register3.0 = model.register3.0.dropLast(2) + cStr + dStr
                case 2:         // "3233"
                    model.register3.0 = model.register3.0.prefix(2) + cStr + dStr + model.register3.0.suffix(2)
                case 3:         // "2531"
                    model.register2.0 = model.register2.0.dropLast(1 ) + cStr
                    model.register3.0 = model.register3.0.prefix(1) + dStr + model.register3.0.suffix(4)
                case 4:         // "2324"
                    model.register2.0 = model.register2.0.prefix(3) + cStr + dStr + model.register2.0.suffix(1)
                case 5:         // "2122"
                    model.register2.0 = model.register2.0.prefix(1) + cStr + dStr + model.register3.0.suffix(3)
                case 6:         // "1415"
                    model.register1.0 = model.register1.0.dropLast(2) + cStr + dStr
                case 7:         // "1213"
                    model.register1.0 = model.register1.0.prefix(2) + cStr + dStr + model.register1.0.suffix(2)
                case 8:         // "..11"           //TODO: fix stuck top digit ..
                    model.register1.0 = model.register1.0.prefix(1) + dStr + cStr + model.register1.0.suffix(3)

                case 9:         // NOUN
                    model.noun.0 = cStr + dStr
                case 10:        // VERB
                    model.verb.0 = cStr + dStr
                case 11:        // PROG
                    model.prog.0 = cStr + dStr
                default:
                    break
            }

    }

    return
}

func digitXlate(_ ccccc: UInt16) -> String { digitsDict[Int(ccccc)] ?? "?" }
