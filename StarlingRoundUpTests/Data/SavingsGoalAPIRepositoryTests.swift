//
//  SavingsGoalAPIRepositoryTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 03/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class SavingsGoalAPIRepositoryTests: XCTestCase {

    var repository: SavingsGoalAPIRepository!
    var apiClient: APIStubClient!

    override func setUp() {
        super.setUp()
        apiClient = APIStubClient()
        repository = SavingsGoalAPIRepository(apiClient: apiClient)
    }

    override func tearDown() {
        repository = nil
        apiClient = nil
        super.tearDown()
    }

    func testSavingsGoalsMakesCorrectAPIRequest() async throws {
        let accountID = "1"
        let expectedAPIRequest = SavingsGoalsRequest(accountID: accountID)

        _ = try? await repository.savingsGoals(for: accountID)

        XCTAssertEqual(apiClient.lastRequest as? SavingsGoalsRequest, expectedAPIRequest)
    }

    func testSavingsGoalsReturnsSavingsGoals() async throws {
        let savingsGoalDataModels = [
            SavingsGoalDataModel(
                savingsGoalUid: "1",
                name: "Test 1",
                target: MoneyDataModel(minorUnits: 123, currency: "GBP"),
                totalSaved: MoneyDataModel(minorUnits: 12, currency: "GBP"),
                savedPercentage: 10,
                state: .active
            ),
            SavingsGoalDataModel(
                savingsGoalUid: "2",
                name: "Test 2",
                target: MoneyDataModel(minorUnits: 456, currency: "GBP"),
                totalSaved: MoneyDataModel(minorUnits: 56, currency: "GBP"),
                savedPercentage: 12,
                state: .active
            )
        ]
        let responseDataModel = SavingsGoalsResponseDataModel(savingsGoalList: savingsGoalDataModels)
        apiClient.responseResult = .success(responseDataModel)

        let savingsGoals = try await repository.savingsGoals(for: "1")

        XCTAssertEqual(savingsGoals.count, 2)
        XCTAssertEqual(savingsGoals[0].id, "1")
        XCTAssertEqual(savingsGoals[1].id, "2")
    }

}
