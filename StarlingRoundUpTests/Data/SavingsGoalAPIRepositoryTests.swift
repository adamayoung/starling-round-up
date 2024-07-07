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
    var accountID: UUID!

    override func setUpWithError() throws {
        try super.setUpWithError()
        apiClient = APIStubClient()
        repository = SavingsGoalAPIRepository(apiClient: apiClient)
        accountID = try XCTUnwrap(UUID(uuidString: "9B26167E-73CD-4347-B69A-1C53B3BE3DD2"))
    }

    override func tearDown() {
        accountID = nil
        repository = nil
        apiClient = nil
        super.tearDown()
    }

    func testSavingsGoalsMakesCorrectAPIRequest() async throws {
        let expectedAPIRequest = SavingsGoalsRequest(accountID: accountID)

        _ = try? await repository.savingsGoals(for: accountID)

        XCTAssertEqual(apiClient.lastRequest as? SavingsGoalsRequest, expectedAPIRequest)
    }

    func testSavingsGoalsReturnsSavingsGoals() async throws {
        let savingsGoal1ID = try XCTUnwrap(UUID(uuidString: "324A3226-3E82-4812-BEFE-CF063EC1978E"))
        let savingsGoal2ID = try XCTUnwrap(UUID(uuidString: "D53666CB-275B-49CE-AFF8-096F52D56025"))
        let savingsGoalDataModels = [
            SavingsGoalDataModel(
                savingsGoalUid: savingsGoal1ID,
                name: "Test 1",
                target: MoneyDataModel(minorUnits: 123, currency: "GBP"),
                totalSaved: MoneyDataModel(minorUnits: 12, currency: "GBP"),
                savedPercentage: 10,
                state: .active
            ),
            SavingsGoalDataModel(
                savingsGoalUid: savingsGoal2ID,
                name: "Test 2",
                target: MoneyDataModel(minorUnits: 456, currency: "GBP"),
                totalSaved: MoneyDataModel(minorUnits: 56, currency: "GBP"),
                savedPercentage: 12,
                state: .active
            )
        ]
        let responseDataModel = SavingsGoalsResponseDataModel(savingsGoalList: savingsGoalDataModels)
        apiClient.responseResult = .success(responseDataModel)

        let savingsGoals = try await repository.savingsGoals(for: accountID)

        XCTAssertEqual(savingsGoals.count, 2)
        XCTAssertEqual(savingsGoals.map(\.id), [savingsGoal1ID, savingsGoal2ID])
    }

    func testCreateSavingsGoalMakesCorrectAPIRequest() async throws {
        let input = SavingsGoalInput(
            accountID: accountID,
            name: "SG 1",
            currency: "GBP",
            targetMinorUnits: 123
        )
        let expectedAPIRequest = CreateSavingsGoalsRequest(
            accountID: accountID,
            name: "SG 1",
            currency: "GBP",
            targetMinorUnits: 123
        )

        _ = try? await repository.create(savingsGoal: input)

        XCTAssertEqual(apiClient.lastRequest as? CreateSavingsGoalsRequest, expectedAPIRequest)
    }

    func testCreateSavingsGoalWhenSuccessfulDoesNotThrowError() async throws {
        let input = SavingsGoalInput(
            accountID: accountID,
            name: "SG 1",
            currency: "GBP",
            targetMinorUnits: 123
        )
        let response = CreateSavingsGoalResponseDataModel(success: true, savingsGoalUid: nil)
        apiClient.responseResult = .success(response)

        var createError: Error?
        do {
            try await repository.create(savingsGoal: input)
        } catch let error {
            createError = error
        }

        XCTAssertNil(createError)
    }

    func testCreateSavingsGoalWhenNotSuccessfulThrowsError() async throws {
        let input = SavingsGoalInput(
            accountID: accountID,
            name: "SG 1",
            currency: "GBP",
            targetMinorUnits: 123
        )
        let response = CreateSavingsGoalResponseDataModel(success: false, savingsGoalUid: nil)
        apiClient.responseResult = .success(response)

        var createError: SavingsGoalRepositoryError?
        do {
            try await repository.create(savingsGoal: input)
        } catch let error {
            createError = error as? SavingsGoalRepositoryError
        }

        XCTAssertEqual(createError, .unknown)
    }

    func testTransferMakesCorrectAPIRequest() async throws {
        let savingsGoalID = try XCTUnwrap(UUID(uuidString: "1E1FDE7F-FAB8-4845-AB76-343FB6093A44"))
        let transferID = try XCTUnwrap(UUID(uuidString: "48F855EC-FAEE-4470-B75E-A591F95E353B"))
        let input = TransferToSavingsGoalInput(
            accountID: accountID,
            savingsGoalID: savingsGoalID,
            amount: Money(minorUnits: 1000, currency: "GBP")
        )
        let expectedAPIRequest = TransferToSavingsGoalRequest(
            transferID: transferID,
            accountID: input.accountID,
            savingsGoalID: input.savingsGoalID,
            minorUnits: input.amount.minorUnits,
            currency: input.amount.currency
        )

        try? await repository.transfer(transferID: transferID, input: input)

        XCTAssertEqual(apiClient.lastRequest as? TransferToSavingsGoalRequest, expectedAPIRequest)
    }

    func testTransferWhenSuccessfulDoesNotThrowError() async throws {
        let savingsGoalID = try XCTUnwrap(UUID(uuidString: "1E1FDE7F-FAB8-4845-AB76-343FB6093A44"))
        let transferID = try XCTUnwrap(UUID(uuidString: "48F855EC-FAEE-4470-B75E-A591F95E353B"))
        let input = TransferToSavingsGoalInput(
            accountID: accountID,
            savingsGoalID: savingsGoalID,
            amount: Money(minorUnits: 1000, currency: "GBP")
        )
        let response = TransferToSavingsGoalResponseDataModel(
            success: true,
            transferUid: transferID.uuidString
        )
        apiClient.responseResult = .success(response)

        var transferError: Error?
        do {
            try await repository.transfer(transferID: transferID, input: input)
        } catch let error {
            transferError = error
        }

        XCTAssertNil(transferError)
    }

}
