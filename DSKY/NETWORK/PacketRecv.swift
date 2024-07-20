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
//        logger.log("       111111111 111111111111111")
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
//            logger.log("»»» display \(ZeroPadWord(value, to: 8)) bits")
            model.comp.1 = value & 0x02 > 0                             // "COMP ACTY"
            model.verb.1 = value & 0x20 > 0                             // flash "VERB"
            model.noun.1 = value & 0x20 > 0                             // flash "NOUN"

            model.lights[11]?.1 = (value & 0x04 > 0) ? .white : .off    // "UPLINK
            model.lights[14]?.1 = (value & 0x40 > 0) ? .white : .off    // "OPR ERR"

            model.lights[21]?.1 = (value & 0x08 > 0) ? .yellow : .off   // "TEMP"
            model.lights[24]?.1 = (value & 0x10 > 0) ? .yellow : .off   // "KEY REL"

        case 0o012:                 // CM and LM actions ..
            break

        case 0o013:                 // DSKY lamp tests ..
            model.lights[13]?.1 = (value & 0x0200 > 0) ? .white : .off  // "STBY"

        case 0o014:                 // CM and LM Gyro celection ..
//            logger.log("    channel \(channel, format: .octal(minDigits: 3)): \(ZeroPadWord(value))")
            break

        case 0o005...0o006, 0o015...0o035:
//            logger.log("»»» fiction \(channel, format: .octal(minDigits: 3)): \(ZeroPadWord(value))")
            break

        case 0o163:
            logger.log("»»» DSKY163 \(ZeroPadWord(value, to: 10)) bits")

//          model.lights[xx]?.1 = (value & 0x0001 > 0) ? .yellow : .off // Bit 1: AGC

            model.lights[13]?.1 = (value & 0x0100 > 0) ? .white : .off  // Bit 9: STBY lamp
            model.lights[14]?.1 = (value & 0x0010 > 0) ? .white : .off  // Bit 5: KEY REL lamp
            model.lights[15]?.1 = (value & 0x0040 > 0) ? .white : .off  // Bit 7: OPER ERR lamp

            model.lights[21]?.1 = (value & 0x0008 > 0) ? .yellow : .off // Bit 4: TEMP lamp

            model.verb.1 = value & 0x10 > 0                             // flash "VERB"
            model.noun.1 = value & 0x10 > 0                             // flash "NOUN"

//          model.lights[xx]?.1 = (value & 0x0010 > 0) ? .yellow : .off // Bit 6: VERB/NOUN flash
            model.lights[24]?.1 = (value & 0x0080 > 0) ? .yellow : .off // Bit 8: RESTART lamp
//          model.lights[xx]?.1 = (value & 0x0200 > 0) ? .white : .off  // Bit 9: EL lamp

                                                                        // Bit 10: EL off
        case 0o165:
            logger.log("»»» DSKY165 \(ZeroPadWord(value)) TIME1")

        case 0o164, 0o166...0o177:
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
                lights \(ZeroPadWord((code & 0b0000_0_00_111111111), to: 9))
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
  ┆                               -AAAA B CCCCC DDDDD                                                ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
            let bBit = (code & 0b00000_1_00000_00000) >  0
            let cInt = (code & 0b00000_0_11111_00000) >> 5
            let dInt = (code & 0b00000_0_00000_11111) >> 0

            var aStr = "????"
            if rowCode < symbolArray.count {
                aStr = symbolArray[Int(rowCode)]
            }

            let cStr = digitXlate(cInt)
            let dStr = digitXlate(dInt)

            logger.log("""
                >>>    DSKY 010: \(ZeroPadWord(code).prefix(4)) \
                \(ZeroPadWord(code).prefix(5).suffix(1)) \
                \(ZeroPadWord(code).dropFirst(5).dropLast(5)) \
                \(ZeroPadWord(code).dropFirst(10)) \
                (\(aStr)) ±\(bBit ? "↑" : "↓") "\(cStr)\(dStr)\"
                """)

            switch rowCode {
                case 9:         // NOUN
                    model.noun.0 = cStr + dStr
                case 10:        // VERB
                    model.verb.0 = cStr + dStr
                case 11:        // PROG
                    model.prog.0 = cStr + dStr
                default:
                    break
            }

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ these are " " or "+" or "-" ..                                                                   ┆
  ┆                                                                                                  ┆
  ┆ B sets or resets a +/- sign                                                                      ┆
  ┆                                                                                                  ┆
  ┆ It is unclear to me how the +/- signs can be blanked, using the commands outlined below. It      ┆
  ┆ seems as though it would involve sending two output-channel commands, (say) with both 1+ and     ┆
  ┆ 1- bits zeroed.                                                                                  ┆
  ┆                                                                                                  ┆
  ┆ (That is the approach taken in yaDSKY: for each sign bit, the most recent 1+ and 1- flags are    ┆
  ┆ saved. If both are 0, then the +/- sign is blank; if 1+ is set and 1- is not, then the '+' sign  ┆
  ┆ is displayed; if just the 1- flag is set, or if both 1+ and 1- flags are set, the '-' sign is    ┆
  ┆ displayed.)                                                                                      ┆
  ┆                                                                                                  ┆
  ┆ +↑ = "+"                                                                                         ┆
  ┆       +↓ = "+" (+↓ means don't change)                                                           ┆
  ┆       -↓ = " " (-↓ after +↓ = " ")                                                               ┆
  ┆                                                                                                  ┆
  ┆ -↑ = "-"                                                                                         ┆
  ┆       -↓ = leave the "-"                                                                         ┆
  ┆       +↓ = " " (+↓ after -↓ = " ")                                                               ┆
  ┆                                                                                                  ┆
  ┆                                                                                                  ┆
  ┆ "-" +     THIS IS PRETTY HORRIBLE .. THERE MUST BE A BETTER WAY                                  ┆
  ┆                                                                                                  ┆
  ┆ from: https://www.ibiblio.org/apollo/Documents/R-693-GSOP-Skylark1-Section2-DataLinks.pdf        ┆
  ┆                                                                                                  ┆
  ┆     Bit 11 of some of the DSPTABs contains discrete information, a one indicating that the       ┆
  ┆     discrete is on. For example, a one in bit 11 of DSPTAB+1 indicates that R3 has a plus sign.  ┆
  ┆                                                                                                  ┆
  ┆     If the sign bits associated with a given register are both zeros, then the content of that   ┆
  ┆     particular register is octal; if either is set, the register content is decimal data.        ┆
  ┆                                                                                                  ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/

            var reg1Bytes = model.register1.0.map { String($0) }
            var reg2Bytes = model.register2.0.map { String($0) }
            var reg3Bytes = model.register3.0.map { String($0) }

            precondition(reg1Bytes.count == 6 && [" ", "+", "-"].contains(reg1Bytes[0]))
            precondition(reg2Bytes.count == 6 && [" ", "+", "-"].contains(reg2Bytes[0]))
            precondition(reg3Bytes.count == 6 && [" ", "+", "-"].contains(reg3Bytes[0]))

            switch rowCode {
/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ no sign bit setting ..                                                                           ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
                case 8:         // "..11"
                    reg1Bytes[1] = dStr
                    model.register1.0 = reg1Bytes.joined()

                case 3:         // "2531"
                    reg2Bytes[5] = cStr
                    model.register2.0 = reg2Bytes.joined()
                    reg3Bytes[1] = dStr
                    model.register3.0 = reg3Bytes.joined()

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ sign bit manipulation ..                                                                         ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
                case 7:         // "1213" & "R1+"
                    model.reg1PlusMinus.0 = bBit
                    switch model.reg1PlusMinus {
                        case (false, false): reg1Bytes[0] = " "
                        case (true, false): reg1Bytes[0] = "+"
                        case (false, true): reg1Bytes[0] = "-"
                        case (true, true): reg1Bytes[0] = "+"           // TODO: Really?
                    }
                    reg1Bytes[2] = cStr
                    reg1Bytes[3] = dStr
                    model.register1.0 = reg1Bytes.joined()

                case 6:         // "1415" & "R1-"
                    model.reg1PlusMinus.1 = bBit
                    switch model.reg1PlusMinus {
                        case (false, false): reg1Bytes[0] = " "
                        case (true, false): reg1Bytes[0] = "+"
                        case (false, true): reg1Bytes[0] = "-"
                        case (true, true): reg1Bytes[0] = "+"           // TODO: Really?
                    }
                    reg1Bytes[4] = cStr
                    reg1Bytes[5] = dStr
                    model.register1.0 = reg1Bytes.joined()

                case 5:         // "2122" & "R2+"
                    model.reg2PlusMinus.0 = bBit
                    switch model.reg2PlusMinus {
                        case (false, false): reg2Bytes[0] = " "
                        case (true, false): reg2Bytes[0] = "+"
                        case (false, true): reg2Bytes[0] = "-"
                        case (true, true): reg2Bytes[0] = "+"           // TODO: Really?
                    }
                    reg2Bytes[1] = cStr
                    reg2Bytes[2] = dStr
                    model.register2.0 = reg2Bytes.joined()

                case 4:         // "2324" & "R2-"
                    model.reg2PlusMinus.1 = bBit
                    switch model.reg2PlusMinus {
                        case (false, false): reg2Bytes[0] = " "
                        case (true, false): reg2Bytes[0] = "+"
                        case (false, true): reg2Bytes[0] = "-"
                        case (true, true): reg2Bytes[0] = "+"           // TODO: Really?
                    }
                    reg2Bytes[3] = cStr
                    reg2Bytes[4] = dStr
                    model.register2.0 = reg2Bytes.joined()

                case 2:         // "3233" & "R3+"
                    model.reg3PlusMinus.0 = bBit
                    switch model.reg3PlusMinus {
                        case (false, false): reg3Bytes[0] = " "
                        case (true, false): reg3Bytes[0] = "+"
                        case (false, true): reg3Bytes[0] = "-"
                        case (true, true): reg3Bytes[0] = "+"           // TODO: Really?
                    }
                    reg3Bytes[2] = cStr
                    reg3Bytes[3] = dStr
                    model.register3.0 = reg3Bytes.joined()

                case 1:         // "3435" & "R3-"
                    model.reg3PlusMinus.1 = bBit
                    switch model.reg3PlusMinus {
                        case (false, false): reg3Bytes[0] = " "
                        case (true, false): reg3Bytes[0] = "+"
                        case (false, true): reg3Bytes[0] = "-"
                        case (true, true): reg3Bytes[0] = "+"           // TODO: Really?
                    }
                    reg3Bytes[4] = cStr
                    reg3Bytes[5] = dStr
                    model.register3.0 = reg3Bytes.joined()

                default:
                    break
            }

    }

    return
}

func digitXlate(_ ccccc: UInt16) -> String { digitsDict[Int(ccccc)] ?? "?" }
