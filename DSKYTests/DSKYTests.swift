//
//  ApoDisKeyTests.swift
//  ApoDisKeyTests
//
//  Created by Gavin Eadie on Jul06/24 (copyright 2024-25)
//

import Testing
@testable import ApoDisKey

var model = DisKeyModel.shared

@Suite(.serialized)
class ApoDisKeyTests {

    @Test func testT_F() {
        #expect(plu_min((true, true)) == "-", "true, true fail")
        #expect(plu_min((true, false)) == "+", "")
        #expect(plu_min((false, true)) == "-", "")
        #expect(plu_min((false, false)) == " ", "")
    }

}
