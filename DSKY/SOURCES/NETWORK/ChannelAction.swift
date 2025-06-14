//
//  ChannelAction.swift
//  ApoDisKey
//
//  Created by Gavin Eadie on Jul16/24 (copyright 2024-25)
//

import Foundation

@MainActor
func channelAction(_ channel: UInt16, _ value: UInt16, _ boolean: Bool = true) {

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
  ┆### NOTE: don't log the commands that only cycle the "COMP ACTY" indicator.                       ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
        case 0o011:                 // [OUTPUT] flags for indicator lamps etc
            if !DSKYBits.shouldFilterChannel011Log(value: value) {
                logger.log("""
                »»»    DSKY 011:    \(zeroPadWord(value)) BITS (15)      \
                :: \(prettyCh011(value))
                """)
            }

            model.comp.1 = value & DSKYBits.Channel011.compActivity > 0

            model.statusLights[11]?.1 = (value & DSKYBits.Channel011.uplinkActivity > 0) ? .white : .off
            model.statusLights[21]?.1 = (value & DSKYBits.Channel011.tempWarning > 0) ? .yellow : .off
            model.statusLights[24]?.1 = (value & DSKYBits.Channel011.keyRelease > 0) ? .yellow : .off
            model.statusLights[14]?.1 = (value & DSKYBits.Channel011.operatorError > 0) ? .white : .off

//        case 0o011:                 // [OUTPUT] flags for indicator lamps etc
//
//            if ![0x2000, 0x2002, 0x2200, 0x2202].contains(value) {
//                logger.log("""
//                »»»    DSKY 011:    \(zeroPadWord(value)) BITS (15)      \
//                :: \(prettyCh011(value))
//                """)
//            }
//            model.comp.1 = value & bit2 > 0                                     // "COMP ACTY"
//
//            model.statusLights[11]?.1 = (value & bit3 > 0) ? .white : .off      // "UPLINK
//            model.statusLights[21]?.1 = (value & bit4 > 0) ? .yellow : .off     // "TEMP"
//            model.statusLights[24]?.1 = (value & bit5 > 0) ? .yellow : .off     // "KEY REL"
//            model.statusLights[14]?.1 = (value & bit7 > 0) ? .white : .off      // "OPR ERR"

        case 0o013:                 // [OUTPUT] DSKY lamp tests ..
            model.statusLights[13]?.1 = (value & DSKYBits.Channel013.standby > 0) ? .white : .off

        case 0o015:                 // [INPUT] Used for inputting keystrokes from the DSKY. ..
            logger.log("""
                »»»    DSKY 015:           \(zeroPadWord(value, to: 8)) BITS (8)       \
                :: \(value) = "\(keyText(value).replacingOccurrences(of: "\n", with: " "))"
                """)

            if keyDict[value] == "RSET" {
                model.ch15ResetCount += 1
                if model.ch15ResetCount == 5 { exit(EXIT_SUCCESS) }             // 5 and we quit
            }

        case 0o012,                 // [OUTPUT] CM and LM actions ..
            0o014,                 // CM and LM Gyro selection ..
            0o016...0o031,
            0o032,                 // [INPUT] Bit 14 UNSET indicates that the PRO key is pressed.
            0o033...0o035:         // [OUTPUT] CM and LM downlinks (ch 34, 35)

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

            model.statusLights[21]?.1 = (value & DSKYBits.Channel163.tempLamp > 0) ? .yellow : .off
            model.statusLights[14]?.1 = (value & DSKYBits.Channel163.keyRelLamp > 0) ? .white : .off
            model.verb.1 = value & DSKYBits.Channel163.verbNounFlash == 0
            model.noun.1 = value & DSKYBits.Channel163.verbNounFlash == 0
            model.statusLights[15]?.1 = (value & DSKYBits.Channel163.operErrorLamp > 0) ? .white : .off
            model.statusLights[24]?.1 = (value & DSKYBits.Channel163.restartLamp > 0) ? .yellow : .off
            model.statusLights[13]?.1 = (value & DSKYBits.Channel163.standbyLamp > 0) ? .white : .off

            model.elPowerOn = value & DSKYBits.Channel163.elPowerOff == 0  

        case 0o165:
            logger.log("»»» DSKY165 \(zeroPadWord(value)) TIME1")

        case 0o164, 0o166...0o177:
            logger.log("»»» fiction    \(zeroPadChannel(channel)): \(zeroPadWord(value))")

        default:
            logger.log("??? channel    \(zeroPadChannel(channel)): \(zeroPadWord(value))")

    }
}

@MainActor
func dskyInterpretation(_ code: UInt16) {

    let  rowCode = (code & 0b01111_0_00000_00000) >> 11

    if rowCode == 0 { return }      // logger.log("ooo    DSKY 010: \(ZeroPadWord(code))")

    if rowCode == 12 {
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
            »»»    DSKY 010: \(zeroPadWord(code).prefix(5)) \
            \(zeroPadWord(code).dropFirst(5)) \
            LIGHTS (10)      :: \(prettyCh010(code & 0b0000000_111111111))
            """)

        model.statusLights[27]?.1 = (code & DSKYBits.Channel010_Lights.velocity > 0) ? .yellow : .off
        model.statusLights[12]?.1 = (code & DSKYBits.Channel010_Lights.noAttitude > 0) ?  .white : .off
        model.statusLights[26]?.1 = (code & DSKYBits.Channel010_Lights.altitude > 0) ? .yellow : .off  
        model.statusLights[22]?.1 = (code & DSKYBits.Channel010_Lights.gimbalLock > 0) ? .yellow : .off

        model.statusLights[25]?.1 = (code & DSKYBits.Channel010_Lights.tracker > 0) ? .yellow : .off   
        model.statusLights[23]?.1 = (code & DSKYBits.Channel010_Lights.program > 0) ? .yellow : .off   
    }

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ DISPLAY ELECTROLUMINESCENT LIGHTS                                                                ┆
  ┆                                                                                                  ┆
  ┆                               -AAAA B CCCCC DDDDD                                                ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/
    else {
        let bBit: Bool =   (code & 0b00000_1_00000_00000) >  0
        let cInt: UInt16 = (code & 0b00000_0_11111_00000) >> 5
        let dInt: UInt16 = (code & 0b00000_0_00000_11111) >> 0

        let aStr = rowCode < symbolArray.count ? symbolArray[Int(rowCode)] : "????"
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
            case 9:  model.noun = (cStr + dStr, true)
            case 10: model.verb = (cStr + dStr, true)
            case 11: model.prog = (cStr + dStr, true)
            default: break
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

        var reg1Bytes: [String] = model.reg1.0.map { String($0) }
        var reg2Bytes: [String] = model.reg2.0.map { String($0) }
        var reg3Bytes: [String] = model.reg3.0.map { String($0) }

        guard reg1Bytes.count == 6, [" ", "+", "-"].contains(reg1Bytes[0]) else {
            logger.error("ERROR: Invalid register format for reg1: \(model.reg1.0)")
            return
        }
//        precondition(reg1Bytes.count == 6 && [" ", "+", "-"].contains(reg1Bytes[0]))
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

            default: break
        }
    }

    return
}

private func updateRegister(_ register: inout String,
                            signState: inout (Bool, Bool),
                            positions: [Int],
                            values: [String],
                            signBit: Bool?) {
    var bytes = register.map { String($0) }

    if let signBit = signBit {
        signState.0 = signBit  // or signState.1 based on context
        bytes[0] = plu_min(signState)
    }

    for (position, value) in zip(positions, values) {
        bytes[position] = value
    }

    register = bytes.joined()
}

// Claude.AI suggests:
//
// 4. Switch Statement Optimization
//    The large switch in dskyInterpretation could benefit from a lookup table for the register cases:

/*
private struct RegisterConfig {
    let signIndex: Int          // 0 for positive, 1 for negative
    let positions: [Int]
    let registerKeyPath: WritableKeyPath<Model, String>
    let signKeyPath: WritableKeyPath<Model, (Bool, Bool)>
}

private let registerConfigs: [Int: RegisterConfig] = [
    7: RegisterConfig(signIndex: 0, positions: [2, 3],
                      registerKeyPath: \.reg1.0, signKeyPath: \.r1Sign),
    // ... other configs
]
*/
