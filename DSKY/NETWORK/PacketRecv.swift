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

    if ((byte[0] == 0xff) &&
        (byte[1] == 0xff) &&
        (byte[2] == 0xff) &&
        (byte[3] == 0xff)) { return nil }

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

    return (channel, value, (byte[0] & 0b00100000) > 0)
}
