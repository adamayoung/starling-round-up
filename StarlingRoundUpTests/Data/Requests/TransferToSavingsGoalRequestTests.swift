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
    var transferID: UUID!

    override func setUpWithError() throws {
        try super.setUpWithError()
        transferID = try XCTUnwrap(UUID(uuidString: "9118EB76-83E4-4171-A374-2FAAF738579F"))
        request = TransferToSavingsGoalRequest(
            transferID: transferID,
            accountID: "1",
            savingsGoalID: "sg1",
            minorUnits: 1000,
            currency: "GBP"
        )
    }

    override func tearDown() {
        request = nil
        super.tearDown()
    }

    func testPath() {
        XCTAssertEqual(
            request.path,
            "/account/1/savings-goals/sg1/add-money/\(transferID.uuidString)"
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
