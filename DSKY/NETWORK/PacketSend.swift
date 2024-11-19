//
//  PacketSend.swift
//  ApoDisKey
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
