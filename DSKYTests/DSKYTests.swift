//
//  ApoDisKeyTests.swift
//  ApoDisKeyTests
//
//  Created by Gavin Eadie on Jul06/24 (copyright 2024-25)
//

import XCTest
import OSLog

let logger = Logger(subsystem: "com.ramsaycons.ApoDisKey", category: "TEST")

final class DSKYTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

// takes about 3½ minutes ..
    func testParseIO() throws {

        var triple = (UInt16(0), UInt16(0), false)

        for channel in 0...255 {
            for value in 0...0x7fff {
                let packet = formIoPacket(UInt16(channel), UInt16(value))
                triple = parseIoPacket(packet)!
                if triple.1 != value {
                    print("stop")
                }
            }
            if triple.0 != channel {
                print("stop")
            }
        }

        for value in 0...0x7fff {
            let packet = formIoPacket(UInt16(8), UInt16(value))
            triple = parseIoPacket(packet)!
            if triple.1 != value {
                print("stop")
            }
        }

    }

    func testT_F() {
        XCTAssertTrue(plu_min((true, true)) == "-", "true, true fail")
        XCTAssertTrue(plu_min((true, false)) == "+", "")
        XCTAssertTrue(plu_min((false, true)) == "-", "")
        XCTAssertTrue(plu_min((false, false)) == " ", "")
    }

}
