//
//  PacketUtil.swift
//  DSKY
//
//  Created by Gavin Eadie on 7/16/24.
//

import Foundation

struct FourByte {
    var byte_0: UInt8
    var byte_1: UInt8
    var byte_2: UInt8
    var byte_3: UInt8

    init(byte_0: UInt8, byte_1: UInt8, 
         byte_2: UInt8, byte_3: UInt8) {
        self.byte_0 = byte_0
        self.byte_1 = byte_1
        self.byte_2 = byte_2
        self.byte_3 = byte_3
    }

    init(_ bytes: Data) {
        self.init(byte_0: bytes[0], byte_1: bytes[2],
                  byte_2: bytes[2], byte_3: bytes[3])
    }

    var packet: Data { Data([byte_0, byte_1, byte_2, byte_3]) }

    var pretty: String { "\(ZeroPadByte(packet[0])) \(ZeroPadByte(packet[1])) " +
                         "\(ZeroPadByte(packet[2])) \(ZeroPadByte(packet[3]))" }
}


func prettyPrint(_ data: Data) {
    logger.log("\(ZeroPadByte(data[0])) \(ZeroPadByte(data[1])) \(ZeroPadByte(data[2])) \(ZeroPadByte(data[3]))")
}

func prettyString(_ data: Data) -> String {
    "\(ZeroPadByte(data[0])) \(ZeroPadByte(data[1])) \(ZeroPadByte(data[2])) \(ZeroPadByte(data[3]))"
}


func ZeroPadByte(_ code: UInt8, _ length: Int = 8) -> String {
    String(("000000000" + String(UInt16(code), radix: 2)).suffix(length))
}

func ZeroPadWord(_ code: UInt16, to length: Int = 15) -> String {
    String(("0000000000000000" + String(UInt16(code), radix: 2)).suffix(length))
}
