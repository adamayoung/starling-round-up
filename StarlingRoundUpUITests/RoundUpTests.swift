//
//  RoundUpTests.swift
//  StarlingRoundUpUITests
//
//  Created by Adam Young on 08/07/2024.
//

import XCTest

final class RoundUpTests: UITestCaseBase {

    var roundUpScreen: RoundUpScreen!

    override func setUp() {
        super.setUp()
        roundUpScreen = initialScreen
            .tapFirstAccountCell()
            .tapRoundUpButton()
            .verifyRoundUpViewVisible()
    }

    override func tearDown() {
        roundUpScreen = nil
        super.tearDown()
    }

    func testCancelRoundUp() {
        roundUpScreen
            .tapCancelButton()
            .verifyAccountViewVisible()
    }

}
