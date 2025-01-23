//
//  ApoDisKeyTests.swift
//  ApoDisKeyTests
//
//  Created by Gavin Eadie on Jul06/24 (copyright 2024-25)
//

import Testing
import OSLog
@testable import ApoDisKey

let logger = Logger(subsystem: "com.ramsaycons.ApoDisKey", category: "TEST")
@MainActor var model = DisKeyModel.shared

// takes about ~20 seconds ..
@Test func testParseIO() throws {
    var triple = (UInt16(0), UInt16(0), false)

    for channel in 0...255 {
        for value in 0...0x7fff {
            triple = parseIoPacket(formIoPacket(UInt16(channel), UInt16(value)))!
            #expect(triple.0 == channel)
            #expect(triple.1 == value)
        }
    }
}

@Test func testT_F() {
    #expect(plu_min((true, true)) == "-", "true, true fail")
    #expect(plu_min((true, false)) == "+", "")
    #expect(plu_min((false, true)) == "-", "")
    #expect(plu_min((false, false)) == " ", "")
}
