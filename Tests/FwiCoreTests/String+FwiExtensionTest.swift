//  Project name: FwiCore
//  File name   : String+FwiExtension.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 11/27/14
//  Version     : 2.0.0
//  --------------------------------------------------------------
//  Copyright © 2012, 2019 Fiision Studio. All Rights Reserved.
//  --------------------------------------------------------------
//
//  Permission is hereby granted, free of charge, to any person obtaining  a  copy
//  of this software and associated documentation files (the "Software"), to  deal
//  in the Software without restriction, including without limitation  the  rights
//  to use, copy, modify, merge,  publish,  distribute,  sublicense,  and/or  sell
//  copies of the Software,  and  to  permit  persons  to  whom  the  Software  is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF  ANY  KIND,  EXPRESS  OR
//  IMPLIED, INCLUDING BUT NOT  LIMITED  TO  THE  WARRANTIES  OF  MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO  EVENT  SHALL  THE
//  AUTHORS OR COPYRIGHT HOLDERS  BE  LIABLE  FOR  ANY  CLAIM,  DAMAGES  OR  OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING  FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN  THE
//  SOFTWARE.
//
//
//  Disclaimer
//  __________
//  Although reasonable care has been taken to  ensure  the  correctness  of  this
//  software, this software should never be used in any application without proper
//  testing. Fiision Studio disclaim  all  liability  and  responsibility  to  any
//  person or entity with respect to any loss or damage caused, or alleged  to  be
//  caused, directly or indirectly, by the use of this software.

import XCTest
@testable import FwiCore

class StringFwiExtensionTest: XCTestCase {

    // MARK: Test Cases
    func testRandomIdentifier() {
        let identifier = String.randomIdentifier
        XCTAssertTrue(identifier.matchPattern("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$"), "\(identifier) should be in form of UUID.")
    }
    
    func testDecodeHTML() {
        let text = "Functional%20Fwicore"
        XCTAssertEqual(text.decodeHTML(), "Functional Fwicore", "\(text) should become Functional Fwicore after decoded.")
    }
    func testEncodeHTML() {
        let text = "Functional Fwicore"
        XCTAssertEqual(text.encodeHTML(), "Functional%20Fwicore", "\(text) should become Functional%20Fwicore after encoded.")
    }
    
    func testIsEqualToStringIgnoreCase() {
        let text1 = "FWICORE"
        let text2 = "fwicore"
        XCTAssertTrue(text1.isEqualTo(text2, ignoreCase: true), "FWICORE compares with fwicore should return true.")
    }
    func testMatchPattern() {
        let text1 = " 12345 "
        let text2 = "12345"
        XCTAssertFalse(text1.matchPattern("^\\d+$"), "\(text1) is invalid input.")
        XCTAssertTrue(text2.matchPattern("^\\d+$"), "\(text2) is invalid input.")
    }
    func testSplit() {
        let text = "FwiCore/FWICORE"
        XCTAssertEqual(text.split("/"), ["FwiCore", "FWICORE"], "\(text) should become array after split.")

        let text2 = "FwiCore//FWICORE"
        XCTAssertEqual(text2.split("/"), ["FwiCore", "FWICORE"], "\(text) should become array after split.")
    }

    func testSubstringFromIndex() {
        let text = "FwiCore"
        XCTAssertEqual(text.substring(fromIndex: 1), "wiCore", "\(text) should become 'wiCore' after sub string.")
    }
    func testSubstringToIndex() {
        let text = "FwiCore"
        XCTAssertEqual(text.substring(toIndex: 5), "FwiCo", "\(text) should become 'FwiCo' after sub string.")
    }
    func testSubstring() {
        let text = "FwiCore"
        XCTAssertEqual(text.substring(fromIndex: 1, length: 3), "", "\(text) should become '' after sub string.")
    }
    func testTrim() {
        let text = " FwiCore "
        XCTAssertEqual(text.trim(), "FwiCore", "\(text) should become FwiCore after trim.")
    }
    func testToData() {
        let text = "FwiCore"
        XCTAssertNotNil(text.toData(), "\(text) should be able to convert to data.")
    }
}
