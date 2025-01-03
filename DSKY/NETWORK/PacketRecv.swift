//
//  PacketRecv.swift
//  ApoDisKey
//
//  Created by Gavin Eadie on Jul16/24 (copyright 2024-25)
//

// swiftlint:disable blanket_disable_command
// swiftlint:disable identifier_name
// swiftlint:disable switch_case_alignment
// swiftlint:disable large_tuple

import Foundation

@MainActor
func channelAction(_ channel: UInt16, _ value: UInt16, _ tf: Bool = true) {

    switch channel {
        case 0o005...0o006:
            break

        case 0o010:                 // [OUTPUT] drives DSKY electroluminescent panel
            dskyInterpretation(value)

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ All LATCHES                                                                                      ┆
  ┆                                                                                                  ┆
  ┆          Bit 2: Lights the "COMP ACTY" indicator.                                                ┆
  ┆          Bit 3: Lights the "UPLINK ACTY" indicator.                                              ┆
  ┆          Bit 4: Lights the "TEMP" indicator.                                                     ┆
  ┆          Bit 5: Lights the "KEY REL" indicator.                                                  ┆
  ┆          Bit 6: Flashes the VERB/NOUN display areas.                                             ┆
  ┆                 This means to flash the digits in the NOUN and VERB areas.                       ┆
  ┆          Bit 7: Lights the "OPR ERR" indicator.                                                  ┆
  ┆                                                                                                  ┆
  ┆          Bit2 11 and 15 ..                                                                       ┆
  ┆                                                                                                  ┆
  ┆###       NOTE: don't log command that only cycle the "COMP ACTY" indicator.                      ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
        case 0o011:                 // [OUTPUT] flags for indicator lamps etc
            if value != 0x2000 && value != 0x2002 && value != 0x2200 && value != 0x2202 {
                logger.log("""
                »»»    DSKY 011:    \(zeroPadWord(value)) BITS (15)      \
                :: \(prettyCh011(value))
                """)
            }
            model.comp.1 = value & bit2 > 0                                     // "COMP ACTY"

            model.statusLights[11]?.1 = (value & bit3 > 0) ? .white : .off      // "UPLINK
            model.statusLights[21]?.1 = (value & bit4 > 0) ? .yellow : .off     // "TEMP"
            model.statusLights[24]?.1 = (value & bit5 > 0) ? .yellow : .off     // "KEY REL"
            model.statusLights[14]?.1 = (value & bit7 > 0) ? .white : .off      // "OPR ERR"

        case 0o012:                 // [OUTPUT] CM and LM actions ..
            break

        case 0o013:                 // [OUTPUT] DSKY lamp tests ..
            model.statusLights[13]?.1 = (value & 0x0200 > 0) ? .white : .off    // "STBY"

        case 0o014:                 // CM and LM Gyro selection ..
            break

        case 0o015:                 // [INPUT] Used for inputting keystrokes from the DSKY. ..
            logger.log("""
                »»»    DSKY 015:           \(zeroPadWord(value, to: 8)) BITS (8)       \
                :: \(value) = "\(keyText(value))"
                """)

            if keyDict[value] == "RSET" {
                model.ch15ResetCount += 1
                if model.ch15ResetCount == 5 { exit(EXIT_SUCCESS) }             // 5 and we quit
            }

        case 0o016...0o031:         //
            break

        case 0o032:                 // [INPUT] Bit 14 UNSET indicates that the PRO key is pressed.
            break

        case 0o033...0o035:         // [OUTPUT] CM and LM downlinks (ch 34, 35)
            break

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ This channel provides correct handling of signals which, due to hardware-implementation factors, ┆
  ┆ are not provided to the DSKY precisely according to the values the AGC writes to the associated  ┆
  ┆ output channels (011 and 013).  In other words, it accounts for hardware handling of the signals ┆
  ┆ after leaving the AGC's output registers.  For example, channel 10 has KEY REL and OPER ERR bits ┆
  ┆ that tell whether the KEY REL and OPER ERR signals are logically active or not, but don't        ┆
  ┆ account for the fact that in addition to the logical state of the signals, they are modulated    ┆
  ┆ by a square wave (to induce flashing) before reaching the DSKY.                                  ┆
  ┆                                                                                                  ┆
  ┆ Channel 163 models this flashing.                                                                ┆
  ┆                                                                                                  ┆
  ┆          Bit 1: AGC warning                                                                      ┆
  ┆          Bits 2-3 ..                                                                             ┆
  ┆          Bit 4: TEMP lamp                                                                        ┆
  ┆          Bit 5: KEY REL lamp                                                                     ┆
  ┆          Bit 6: VERB/NOUN flash                                                                  ┆
  ┆          Bit 7: OPER ERR lamp                                                                    ┆
  ┆          Bit 8: RESTART lamp                                                                     ┆
  ┆          Bit 9: STBY lamp                                                                        ┆
  ┆          Bit 10: EL off                                                                          ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
        case 0o163:
            logger.log("""
                »»»    DSKY 163:         \(zeroPadWord(value, to: 10)) BITS (10)      \
                :: \(prettyCh163(value))
                """)

            model.statusLights[21]?.1 = (value & bit4 > 0) ? .yellow : .off     // Bit 4: TEMP lamp
            model.statusLights[14]?.1 = (value & bit5 > 0) ? .white : .off      // Bit 5: KEY REL lamp
            model.verb.1 = value & bit6 == 0                                    // Bit 6: flash V digits
            model.noun.1 = value & bit6 == 0                                    // Bit 6: flash N digits
            model.statusLights[15]?.1 = (value & bit7 > 0) ? .white : .off      // Bit 7: OPER ERR lamp
            model.statusLights[24]?.1 = (value & bit8 > 0) ? .yellow : .off     // Bit 8: RESTART lamp
            model.statusLights[13]?.1 = (value & bit9 > 0) ? .white : .off      // Bit 9: STBY lamp

            model.elPowerOn = value & bit10 == 0                                // Bit 10: panel power

        case 0o165:
            logger.log("»»» DSKY165 \(zeroPadWord(value)) TIME1")

        case 0o164, 0o166...0o177:
            logger.log("»»» fiction \(channel, format: .octal(minDigits: 3)): \(zeroPadWord(value))")

        default:
            logger.log("??? channel \(channel, format: .octal(minDigits: 3)): \(zeroPadWord(value))")

    }
}

@MainActor
func dskyInterpretation(_ code: UInt16) {

    let  rowCode = (code & 0b01111_0_00000_00000) >> 11

    switch rowCode {
        case 12:
/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ STATUS ANNUNCIATORS                                                                              ┆
  ┆                                                                                                  ┆
  ┆          Bit 1 lights the "PRIO DISP" indicator.                                                 ┆
  ┆          Bit 2 lights the "NO DAP" indicator.                                                    ┆
  ┆          Bit 3 lights the "VEL" indicator.                                                       ┆
  ┆          Bit 4 lights the "NO ATT" indicator.                                                    ┆
  ┆          Bit 5 lights the "ALT" indicator.                                                       ┆
  ┆          Bit 6 lights the "GIMBAL LOCK" indicator.                                               ┆
  ┆          Bit 7 . . .                                                                             ┆
  ┆          Bit 8 lights the "TRACKER" indicator.                                                   ┆
  ┆          Bit 9 lights the "PROG" indicator.                                                      ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
            logger.log("""
                ***    DSKY 010: \(zeroPadWord(code).prefix(5)) \
                \(zeroPadWord(code).dropFirst(5)) \
                LIGHTS (10)      :: \(prettyCh010(code & 0b0000000_111111111))
                """)

            model.statusLights[27]?.1 = (code & bit3 > 0) ? .yellow : .off   // 3: VEL
            model.statusLights[12]?.1 = (code & bit4 > 0) ?  .white : .off   // 4: NO ATT
            model.statusLights[26]?.1 = (code & bit5 > 0) ? .yellow : .off   // 5: ALT
            model.statusLights[22]?.1 = (code & bit6 > 0) ? .yellow : .off   // 6: GIMBAL LOCK

            model.statusLights[25]?.1 = (code & bit8 > 0) ? .yellow : .off   // 8: TRACKER
            model.statusLights[23]?.1 = (code & bit9 > 0) ? .yellow : .off   // 9: PROG

        case 0:
            return // logger.log("ooo    DSKY 010: \(ZeroPadWord(code))")

        default:

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ DISPLAY ELECTROLUMINESCENT LIGHTS                                                                ┆
  ┆                                                                                                  ┆
  ┆                               -AAAA B CCCCC DDDDD                                                ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
            let bBit = (code & 0b00000_1_00000_00000) >  0
            let cInt = (code & 0b00000_0_11111_00000) >> 5
            let dInt = (code & 0b00000_0_00000_11111) >> 0

            var aStr = "????"
            if rowCode < symbolArray.count {
                aStr = symbolArray[Int(rowCode)]
            }

            let cStr = digitsDict[Int(cInt)] ?? "?"
            let dStr = digitsDict[Int(dInt)] ?? "?"

            logger.log("""
                »»»    DSKY 010: \(zeroPadWord(code).prefix(4)) \
                \(zeroPadWord(code).prefix(5).suffix(1)) \
                \(zeroPadWord(code).dropFirst(5).dropLast(5)) \
                \(zeroPadWord(code).dropFirst(10)) \
                (\(aStr)) ±\(bBit ? "↑" : "↓") "\(cStr)\(dStr)\"
                """)

            switch rowCode {
                case 9:
                    model.noun = (cStr + dStr, true)
                case 10:
                    model.verb = (cStr + dStr, true)
                case 11:
                    model.prog = (cStr + dStr, true)
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

            var reg1Bytes = model.reg1.0.map { String($0) }
            var reg2Bytes = model.reg2.0.map { String($0) }
            var reg3Bytes = model.reg3.0.map { String($0) }

            precondition(reg1Bytes.count == 6 && [" ", "+", "-"].contains(reg1Bytes[0]))
            precondition(reg2Bytes.count == 6 && [" ", "+", "-"].contains(reg2Bytes[0]))
            precondition(reg3Bytes.count == 6 && [" ", "+", "-"].contains(reg3Bytes[0]))

            switch rowCode {
/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ no sign bit setting ..                                                                           ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
                case 8:         // "..11"
                    reg1Bytes[1] = dStr
                    model.reg1.0 = reg1Bytes.joined()

                case 3:         // "2531"
                    reg2Bytes[5] = cStr
                    model.reg2.0 = reg2Bytes.joined()
                    reg3Bytes[1] = dStr
                    model.reg3.0 = reg3Bytes.joined()

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ sign bit manipulation ..                                                                         ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
                case 7:         // "1213" & "R1+"
                    model.r1Sign.0 = bBit
                    reg1Bytes[0] = plu_min(model.r1Sign)
                    reg1Bytes[2] = cStr
                    reg1Bytes[3] = dStr
                    model.reg1.0 = reg1Bytes.joined()

                case 6:         // "1415" & "R1-"
                    model.r1Sign.1 = bBit
                    reg1Bytes[0] = plu_min(model.r1Sign)
                    reg1Bytes[4] = cStr
                    reg1Bytes[5] = dStr
                    model.reg1.0 = reg1Bytes.joined()

                case 5:         // "2122" & "R2+"
                    model.r2Sign.0 = bBit
                    reg2Bytes[0] = plu_min(model.r2Sign)
                    reg2Bytes[1] = cStr
                    reg2Bytes[2] = dStr
                    model.reg2.0 = reg2Bytes.joined()

                case 4:         // "2324" & "R2-"
                    model.r2Sign.1 = bBit
                    reg2Bytes[0] = plu_min(model.r2Sign)
                    reg2Bytes[3] = cStr
                    reg2Bytes[4] = dStr
                    model.reg2.0 = reg2Bytes.joined()

                case 2:         // "3233" & "R3+"
                    model.r3Sign.0 = bBit
                    reg3Bytes[0] = plu_min(model.r3Sign)
                    reg3Bytes[2] = cStr
                    reg3Bytes[3] = dStr
                    model.reg3.0 = reg3Bytes.joined()

                case 1:         // "3435" & "R3-"
                    model.r3Sign.1 = bBit
                    reg3Bytes[0] = plu_min(model.r3Sign)
                    reg3Bytes[4] = cStr
                    reg3Bytes[5] = dStr
                    model.reg3.0 = reg3Bytes.joined()

                default:
                    break
            }
    }

    return
}

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
  ┆╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┆
  ┆ Special: 00000000 01000000 10000000 11000000                                                     ┆
  ┆          (channel = zero & value = zero) signals lost connection ..                              ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/

/// This function is the reverse of FormIoPacket:
/// A 4-byte packet representing yaAGC channel i/o
/// can be converted to an integer channel-number and value.
func parseIoPacket (_ data: Data) -> (UInt16, UInt16, Bool)? {

    guard data.count == 4 else {
        logger.log("\(#function): not four bytes")
        return nil
    }

    let byte = [UInt8](data)

    if (byte[0] == 0xff) &&
       (byte[1] == 0xff) &&
       (byte[2] == 0xff) &&
       (byte[3] == 0xff) { return nil }

    if (byte[0] / 64) != 0 || (byte[1] / 64) != 1 || (byte[2] / 64) != 2 || (byte[3] / 64) != 3 {
        logger.log("\(#function): prefix bits wrong [\(prettyString(data))]")
        return nil
    }

    let channel: UInt16 = UInt16(byte[0] & UInt8(0b00111111)) << 3 |
    UInt16(byte[1] & UInt8(0b00111000)) >> 3

    let value: UInt16 =   UInt16(byte[1] & UInt8(0b00000111)) << 12 |
    UInt16(byte[2] & UInt8(0b00111111)) << 6 |
    UInt16(byte[3] & UInt8(0b00111111))

    return (channel, value, (byte[0] & 0b00100000) > 0)
}
