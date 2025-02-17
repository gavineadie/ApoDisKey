//
//  PacketIO.swift
//  ApoDisKey
//
//  Created by Gavin Eadie on Jul16/24 (copyright 2024-25)
//

import Foundation

/*╭╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╮
  ┆ Converts a yaAGC integer channel-number and value to a 4-byte channel i/o packet ..              ┆
  ┆╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┆
  ┆ bytes: 00tupppp 01pppddd 10dddddd 11dddddd                                                       ┆
  ┆        ^^       ^^       ^^       ^^            packet validation bits                           ┆
  ┆╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┆
  ┆    0000000tuppppppp is the 9-bit channel              0ddddddddddddddd is the 15-bit value.      ┆
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

/// This function is the reverse of parseIoPacket:
/// Converts a yaAGC integer channel-number and value to a 4-byte channel i/o packet ..
func formIoPacket(_ channel: UInt16, _ value: UInt16) -> Data {

    guard (0...0x01ff).contains(channel) else { fatalError("\(#function) channel (\(channel) out of range") }
    guard (0...0x7fff).contains(value) else { fatalError("\(#function) value (\(value) out of range") }

    let byte0: UInt8 = 0x00 | UInt8((0b000000111111000 & channel) >> 3)
    let byte1: UInt8 = 0x40 | UInt8((0b000000000000111 & channel) << 3) |
                              UInt8((0b111000000000000 & value) >> 12)
    let byte2: UInt8 = 0x80 | UInt8((0b000111111000000 & value) >> 6)
    let byte3: UInt8 = 0xC0 | UInt8((0b000000000111111 & value))

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
  ┆╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┆
  ┆ Special: 00000000 01000000 10000000 11000000                                                     ┆
  ┆          (channel = zero & value = zero) signals lost connection ..                              ┆
  ╰╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╯*/

/// This function is the reverse of FormIoPacket. A 4-byte packet representing yaAGC channel i/o
/// can be converted to an integer channel-number, value and 'u-bit'.
func parseIoPacket (_ data: Data) -> (UInt16, UInt16, Bool)? {

    guard data.count == 4 else {
        logger.log("\(#function): not four bytes")
        return nil
    }

    let bytes = [UInt8](data)

    if (bytes[0] == 0xff) && (bytes[1] == 0xff) &&
       (bytes[2] == 0xff) && (bytes[3] == 0xff) { return nil }

    if (bytes[0] / 64) != 0 || (bytes[1] / 64) != 1 || (bytes[2] / 64) != 2 || (bytes[3] / 64) != 3 {
        logger.log("\(#function): prefix bits wrong [\(prettyString(data))]")
        return nil
    }

    let channel: UInt16 = UInt16(bytes[0] & UInt8(0b00111111)) << 3 |
    UInt16(bytes[1] & UInt8(0b00111000)) >> 3

    let value: UInt16 =   UInt16(bytes[1] & UInt8(0b00000111)) << 12 |
    UInt16(bytes[2] & UInt8(0b00111111)) << 6 |
    UInt16(bytes[3] & UInt8(0b00111111))

    return (channel, value, (bytes[0] & 0b00100000) > 0)
}
