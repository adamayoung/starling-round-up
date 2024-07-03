//
//  AccountTypeMapperTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 02/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class AccountTypeMapperTests: XCTestCase {

    func testMapPrimary() {
        let dataModel = AccountTypeDataModel.primary

        let accountType = AccountTypeMapper.map(dataModel)

        XCTAssertEqual(accountType, .primary)
    }

    func testMapAdditional() {
        let dataModel = AccountTypeDataModel.additional

        let accountType = AccountTypeMapper.map(dataModel)

        XCTAssertEqual(accountType, .additional)
    }

    func testMapLoan() {
        let dataModel = AccountTypeDataModel.loan

        let accountType = AccountTypeMapper.map(dataModel)

        XCTAssertEqual(accountType, .loan)
    }

    func testMapFixTermDeposit() {
        let dataModel = AccountTypeDataModel.fixTermDeposit

        let accountType = AccountTypeMapper.map(dataModel)

        XCTAssertEqual(accountType, .fixTermDeposit)
    }

    func testMapUnknown() {
        let dataModel = AccountTypeDataModel.unknown

        let accountType = AccountTypeMapper.map(dataModel)

        XCTAssertEqual(accountType, .unknown)
    }

}
