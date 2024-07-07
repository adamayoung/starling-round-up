//
//  TransferToSavingsGoalRequestTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 07/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class TransferToSavingsGoalRequestTests: XCTestCase {

    var request: TransferToSavingsGoalRequest!
    var accountID: UUID!
    var transferID: UUID!

    override func setUpWithError() throws {
        try super.setUpWithError()
        accountID = try XCTUnwrap(UUID(uuidString: "8E73BAD3-0898-4149-A639-3EC5BEA6B559"))
        transferID = try XCTUnwrap(UUID(uuidString: "9118EB76-83E4-4171-A374-2FAAF738579F"))
        request = TransferToSavingsGoalRequest(
            transferID: transferID,
            accountID: accountID,
            savingsGoalID: "sg1",
            minorUnits: 1000,
            currency: "GBP"
        )
    }

    override func tearDown() {
        accountID = nil
        transferID = nil
        request = nil
        super.tearDown()
    }

    func testPath() {
        XCTAssertEqual(
            request.path,
            "/account/\(accountID.uuidString)/savings-goals/sg1/add-money/\(transferID.uuidString)"
        )
    }

    func testMethod() {
        XCTAssertEqual(request.method, .put)
    }

    func testBody() {
        let expectedBody = TransferToSavingsGoalRequest.Body(
            amount: MoneyDataModel(
                minorUnits: 1000,
                currency: "GBP"
            )
        )

        XCTAssertEqual(request.body, expectedBody)
    }

}
