//
//  ChannelAction.swift
//  ApoDisKey
//
//  Created by Gavin Eadie on Jul16/24 (copyright 2024-25)
//

import Foundation

private func logDSKY(_ channelOctal: String, bitsLabel: String? = nil, value: UInt16, pretty: String? = nil, note: String? = nil) {
    let word = (bitsLabel == "10") ? zeroPadWord(value, to: 10) : (bitsLabel == "8") ? zeroPadWord(value, to: 8) : zeroPadWord(value)
    var line = "»»» DSKY \(channelOctal): \(word)"
    if let bitsLabel = bitsLabel { line += " BITS (\(bitsLabel))" }
    if let pretty = pretty { line += " :: \(pretty)" }
    if let note = note { line += " :: \(note)" }
    logger.log("\(line)")
}

// Centralized mapping for DSKY status lamp indices
private enum StatusLamp: CustomStringConvertible {
    case uplinkActivity    // index 11
    case noAttitude        // index 12
    case standby           // index 13
    case operatorError     // index 14
    case operError         // alias if needed (kept separate for clarity)
    case keyRelease        // index 24 (011 semantics) / restart (163 semantics), see mapping
    case tempWarning       // index 21
    case velocity          // index 27
    case altitude          // index 26
    case gimbalLock        // index 22
    case tracker           // index 25
    case program           // index 23
    case restart           // index 24

    var description: String {
        switch self {
            case .uplinkActivity: return "Uplink Activity"
            case .noAttitude:     return "No Attitude"
            case .standby:        return "Standby"
            case .operatorError:  return "Operator Error"
            case .operError:      return "Oper Error"
            case .keyRelease:     return "Key Release"
            case .tempWarning:    return "Temp Warning"
            case .altitude:       return "Altitude"
            case .velocity:       return "Velocity"
            case .gimbalLock:     return "Gimbal Lock"
            case .tracker:        return "Tracker"
            case .program:        return "Program"
            case .restart:        return "Restart"
        }
    }
}

private extension Dictionary where Key == Int, Value == (String, BackColor) {
    subscript(_ lamp: StatusLamp) -> (String, BackColor)? {
        get {
            self[StatusLamp.index(for: lamp)]
        }
        set {
            if let newValue = newValue {
                self[StatusLamp.index(for: lamp)] = newValue
            }
        }
    }
}

private extension StatusLamp {
    static func index(for lamp: StatusLamp) -> Int {
        switch lamp {
        case .uplinkActivity: return 11
        case .noAttitude:     return 12
        case .standby:        return 13
        case .operatorError:  return 14
        case .operError:      return 15 // used in channel 163 mapping in existing code
        case .tempWarning:    return 21
        case .altitude:       return 26
        case .velocity:       return 27
        case .gimbalLock:     return 22
        case .tracker:        return 25
        case .program:        return 23
        case .keyRelease:     return 24
        case .restart:        return 24
        }
    }
}

func channelAction(_ channel: UInt16, _ value: UInt16, _ boolean: Bool = true) {

    switch channel {
        case 0o005...0o006:
            break

        case 0o010:                 // [OUTPUT] drives DSKY electroluminescent panel
            dskyInterpretation(value)

        case 0o011:                 // [OUTPUT] flags for indicator lamps etc
            if !DSKY.shouldFilterChannel011Log(value: value) {
                logDSKY("011", bitsLabel: "15", value: value, pretty: prettyCh011(value))
            }

            model.comp.1 = value & DSKY.Ch011.compActivity > 0

            setLamp(.uplinkActivity, to: (value & DSKY.Ch011.uplinkActivity > 0) ? .white : .off, reason: "CH011")
            setLamp(.tempWarning,    to: (value & DSKY.Ch011.tempWarning    > 0) ? .yellow : .off, reason: "CH011")
            setLamp(.keyRelease,     to: (value & DSKY.Ch011.keyRelease     > 0) ? .yellow : .off, reason: "CH011")
            setLamp(.operatorError,  to: (value & DSKY.Ch011.operatorError  > 0) ? .white  : .off, reason: "CH011")

        case 0o013:                 // [OUTPUT] DSKY lamp tests ..
            setLamp(.standby, to: (value & DSKY.Ch013.standby > 0) ? .white : .off, reason: "CH013")

        case 0o015:                 // [INPUT] Used for inputting keystrokes from the DSKY. ..
            let keyString = keyText(value).replacingOccurrences(of: "\n", with: " ")
            logDSKY("015", bitsLabel: "8",
                    value: value, note: "\(value) = \"\(keyString)\"")

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

        case 0o163:
            logDSKY("163", bitsLabel: "10",
                    value: value, pretty: prettyCh163(value))

            setLamp(.tempWarning, to: (value & DSKY.Ch163.tempLamp      > 0) ? .yellow : .off, reason: "CH163")
            setLamp(.keyRelease,  to: (value & DSKY.Ch163.keyRelLamp    > 0) ? .white  : .off, reason: "CH163")
            setLamp(.operError,   to: (value & DSKY.Ch163.operErrorLamp > 0) ? .white  : .off, reason: "CH163")
            setLamp(.restart,     to: (value & DSKY.Ch163.restartLamp   > 0) ? .yellow : .off, reason: "CH163")
            setLamp(.standby,     to: (value & DSKY.Ch163.standbyLamp   > 0) ? .white  : .off, reason: "CH163")

            model.verb.1 = value & DSKY.Ch163.verbNounFlash == 0
            model.noun.1 = value & DSKY.Ch163.verbNounFlash == 0

            let newELPowerOn = value & DSKY.Ch163.elPowerOff == 0
            if model.elPowerOn != newELPowerOn {
                logger.log("EL Power: \(newELPowerOn ? "ON" : "OFF") via CH163")
            }
            model.elPowerOn = newELPowerOn

        case 0o165:
            logDSKY("165", value: value, note: "TIME1")

        case 0o164, 0o166...0o177:
            let chOct = String(format: "%03o", channel)
            logDSKY(chOct, value: value, note: "fiction")

        default:
            let chOct = String(format: "%03o", channel)
            logDSKY(chOct, value: value, note: "unhandled channel")

    }
}

func dskyInterpretation(_ code: UInt16) {

    let rowCode = DSKY.extractRowCode(from: code)

    if rowCode == 0 { return }      // logger.log("ooo    DSKY 010: \(ZeroPadWord(code))")

    if rowCode == 12 {
        logDSKY("010", bitsLabel: "10",
                value: code & 0b00000001_11111111,
                pretty: prettyCh010(code & 0b00000001_11111111))

        setLamp(.velocity,    to: (code & DSKY.Ch010_Lights.velocity    > 0) ? .yellow : .off, reason: "CH010")
        setLamp(.noAttitude,  to: (code & DSKY.Ch010_Lights.noAttitude  > 0) ? .white  : .off, reason: "CH010")
        setLamp(.altitude,    to: (code & DSKY.Ch010_Lights.altitude    > 0) ? .yellow : .off, reason: "CH010")
        setLamp(.gimbalLock,  to: (code & DSKY.Ch010_Lights.gimbalLock  > 0) ? .yellow : .off, reason: "CH010")
        setLamp(.tracker,     to: (code & DSKY.Ch010_Lights.tracker     > 0) ? .yellow : .off, reason: "CH010")
        setLamp(.program,     to: (code & DSKY.Ch010_Lights.program     > 0) ? .yellow : .off, reason: "CH010")
    } else {
        let bBit: Bool =   (code & 0b00000_1_00000_00000) >  0
        let cInt: UInt16 = (code & 0b00000_0_11111_00000) >> 5
        let dInt: UInt16 = (code & 0b00000_0_00000_11111) >> 0

        let aStr = rowCode < symbolArray.count ? symbolArray[Int(rowCode)] : "????"
        let cStr = digitsDict[Int(cInt)] ?? "?"
        let dStr = digitsDict[Int(dInt)] ?? "?"

        let seg = "(\(aStr)) ±\(bBit ? "↑" : "↓") \"\(cStr)\(dStr)\""
        logDSKY("010", value: code, note: seg)

        switch rowCode {
            case 9:  model.noun = (cStr + dStr, true)
            case 10: model.verb = (cStr + dStr, true)
            case 11: model.prog = (cStr + dStr, true)
            default: break
        }

        var reg1Bytes: [String] = model.reg1.0.map { String($0) }
        var reg2Bytes: [String] = model.reg2.0.map { String($0) }
        var reg3Bytes: [String] = model.reg3.0.map { String($0) }

        guard reg1Bytes.count == 6, [" ", "+", "-"].contains(reg1Bytes[0]) else {
            logger.error("ERROR: Invalid register format for reg1: \(model.reg1.0)")
            return
        }
        guard reg2Bytes.count == 6, [" ", "+", "-"].contains(reg2Bytes[0]) else {
            logger.error("ERROR: Invalid register format for reg2: \(model.reg2.0)")
            return
        }
        guard reg3Bytes.count == 6, [" ", "+", "-"].contains(reg3Bytes[0]) else {
            logger.error("ERROR: Invalid register format for reg3: \(model.reg3.0)")
            return
        }

        switch rowCode {
            case 8:         // "..11"
                reg1Bytes[1] = dStr
                model.reg1.0 = reg1Bytes.joined()

            case 3:         // "2531"
                reg2Bytes[5] = cStr
                model.reg2.0 = reg2Bytes.joined()
                reg3Bytes[1] = dStr
                model.reg3.0 = reg3Bytes.joined()

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

private func setLamp(_ lamp: StatusLamp, to color: BackColor, reason: String) {
    let index = StatusLamp.index(for: lamp)
    if let current = model.lights[index]?.1, current != color {
        logger.log("Lamp[\(index)] \(lamp) \(String(describing: current)) → \(String(describing: color)) via \(reason)")
    }
    model.lights[lamp]?.1 = color
}
