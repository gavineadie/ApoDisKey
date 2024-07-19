//
//  PacketSend.swift
//  DSKY
//
//  Created by Gavin Eadie on 7/16/24.
//

import Foundation

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

//    logger.log("0000000ccccccccc  0vvvvvvvvvvvvvvv \(#function)")
//    logger.log("       \(ZeroPadWord(channel, to: 9))   \(ZeroPadWord(value, to: 15))")
//    logger.log("                \(ZeroPadWord(channel, to: 9).dropFirst(6))")
//    logger.log("""
//                 __\(ZeroPadWord((0b000000111111111 & channel), to: 9).dropLast(3))
//                          __\(ZeroPadWord((0b000000111111111 & channel), to: 9).dropFirst(6))---
//                          __---\(ZeroPadWord((0b011111111111111 & value)).dropLast(12))
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
