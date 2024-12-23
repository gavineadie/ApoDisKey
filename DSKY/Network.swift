//
//  Network.swift
//  DSKY
//
//  Created by Gavin Eadie on 7/15/24.
//

// swiftlint:disable blanket_disable_command
// swiftlint:disable identifier_name
// swiftlint:disable switch_case_alignment
// swiftlint:disable vertical_whitespace
// swiftlint:disable large_tuple
// swiftlint:disable unused_optional_binding
// swiftlint:disable line_length
// swiftlint:disable comma

import Foundation
import Network
import TCPLib

struct Network {

    let client: Client

    init() {
        client = Client("127.0.0.1", 19697)
        client.connection.start()

        setupReceive()
    }

    func setupReceive() {
        client.nwConnection.receive(minimumIncompleteLength: 1,
                                    maximumLength: 4) { (content, _, isComplete, error) in

            if let data = content, !data.isEmpty {
//              prettyPrint(data)
                if let _ = parseIoPacket(data) {
//                  logger.log("    channel \(triple.0, format: .octal(minDigits: 15) ): \(ZeroPadWord(triple.1, to: 15))")
                }
            }
            if isComplete {
                client.connection.connectionDidEnd()
            } else if let error = error {
                client.connection.connectionDidFail(error: error)
            } else {
                setupReceive()
            }
        }
    }
}

func ZeroPadByte(_ code: UInt8, _ length: Int = 8) -> String {
    String(("000000000" + String(UInt16(code), radix: 2)).suffix(length))
}

func ZeroPadWord(_ code: UInt16, to length: Int = 15) -> String {
    String(("0000000000000000" + String(UInt16(code), radix: 2)).suffix(length))
}

func prettyPrint(_ data: Data) {
    logger.log("\(ZeroPadByte(data[0])) \(ZeroPadByte(data[1])) \(ZeroPadByte(data[2])) \(ZeroPadByte(data[3]))")
}

func prettyString(_ data: Data) -> String {
    "\(ZeroPadByte(data[0])) \(ZeroPadByte(data[1])) \(ZeroPadByte(data[2])) \(ZeroPadByte(data[3]))"
}


/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ Converts a yaAGC integer channel-number and value to a 4-byte channel i/o packet ..              ┆
  ┆╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┆
  ┆ bytes: 00pppppp 01pppddd 10dddddd 11dddddd                                                       ┆
  ┆        ^^       ^^       ^^       ^^            packet validation bits                           ┆
  ┆╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┆
  ┆    0000000ppppppppp is the 9-bit channel              0ddddddddddddddd is the 15-bit value.      ┆
  ┆                                                                                                  ┆
  ┆    0000000ppppppppp                                                                              ┆
  ┆           >> 3                                                                                   ┆
  ┆            00pppppp (byte[0])                                                                    ┆
  ┆                                                                                                  ┆
  ┆    0000000ppppppppp                                   0ddddddddddddddd                           ┆
  ┆                 << 3                                   >> 12                                     ┆
  ┆            01ppp--- (byte[1])                                 01---ddd (byte[1])                 ┆
  ┆                                                                                                  ┆
  ┆                                                       0ddddddddddddddd                           ┆
  ┆                                                           >> 6                                   ┆
  ┆                                                               10dddddd (byte[2])                 ┆
  ┆                                                                                                  ┆
  ┆                                                       0ddddddddddddddd                           ┆
  ┆                                                                                                  ┆
  ┆                                                               11dddddd (byte[3])                 ┆
  ┆                                                                                                  ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/

/// This function is the reverse of FormIoPacket:
/// A 4-byte packet representing yaAGC channel i/o can be converted to an integer channel-number and value.
func formIoPacket(_ channel: UInt16, _ value: UInt16) -> Data {

//    logger.log("0000000ccccccccc  0vvvvvvvvvvvvvv")
//    logger.log("       \(ZeroPadWord(channel, to: 9))   \(ZeroPadWord(value, to: 15))")
//    logger.log("                \(ZeroPadWord(channel, to: 9).dropFirst(6))")
//    logger.log("""
//                 __\(ZeroPadWord((0b000000111111111 & channel), to: 9).dropLast(3))
//                          __\(ZeroPadWord((0b000000111111111 & channel), to: 9).dropFirst(6))---
//                          __---\(ZeroPadWord((0b011111111111111 & value)).dropFirst(12))
//                                   __\(ZeroPadWord(value, to: 15).dropFirst(3).dropLast(6))
//                                            __\(ZeroPadWord(value, to: 15).dropFirst(9))
//            """)

    guard (0...0x1ff).contains(channel) else { fatalError("\(#function) channel (\(channel) out of range") }
    guard (0...0x7fff).contains(value) else { fatalError("\(#function) value (\(value) out of range") }

    let byte0: UInt8 = 0x00 | UInt8((0b000000111111000 & channel) >> 3)
    let byte1: UInt8 = 0x40 | UInt8((0b000000000000111 & channel) << 3) |
                              UInt8((0b111000000000000 & value) >> 12)
    let byte2: UInt8 = 0x80 | UInt8((0b000111111000000 & value) >> 6)
    let byte3: UInt8 = 0xC0 | UInt8((0b000000000111111 & value))

//    logger.log("""
//                 __\(ZeroPadByte(byte0).dropFirst(2)) \
//            __\(ZeroPadByte(byte1).dropFirst(2)) \
//            __\(ZeroPadByte(byte2).dropFirst(2)) \
//            __\(ZeroPadByte(byte3).dropFirst(2))
//            """)

//    logger.log("     \(ZeroPadByte(byte0)) \(ZeroPadByte(byte1)) \(ZeroPadByte(byte2)) \(ZeroPadByte(byte3))")

    return Data([byte0, byte1, byte2, byte3])
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

            // hex: 6100
            // bin: 0110_0001_0000_0000
            //       AAA ABCC CCCD DDDD
            //       100 0000 0000 0011

            let     B = code & 0b0000_0100_0000_0000 // >> 10
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
                (\(aStr) ±\(B == 0 ? "↓" : "↑") "\(cStr)\(dStr)\"
                """)
    }

    return
}
