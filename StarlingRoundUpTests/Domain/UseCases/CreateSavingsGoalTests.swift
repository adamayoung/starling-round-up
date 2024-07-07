//
//  CreateSavingsGoalTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 03/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class CreateSavingsGoalTests: XCTestCase {

    var useCase: CreateSavingsGoal!
    var savingsGoalRepository: SavingsGoalStubRepository!
    var accountID: UUID!

    override func setUpWithError() throws {
        try super.setUpWithError()
        savingsGoalRepository = SavingsGoalStubRepository()
        useCase = CreateSavingsGoal(savingsGoalRepository: savingsGoalRepository)
        accountID = try XCTUnwrap(UUID(uuidString: "7AEA4E58-6137-4F92-B2A2-37A2C631F731"))
    }

    override func tearDown() {
        accountID = nil
        useCase = nil
        savingsGoalRepository = nil
        super.tearDown()
    }

    func testExecuteWhenValidInputCreatesSavingsGoal() async throws {
        let input = SavingsGoalInput(
            accountID: accountID,
            name: "SG 1",
            currency: "GBP",
            targetMinorUnits: 100
        )
        savingsGoalRepository.createResult = .success(())

        try await useCase.execute(input: input)

        XCTAssertEqual(savingsGoalRepository.lastCreateSavingsGoalInput, input)
    }

    func testExecuteWhenInvalidInputThrowsError() async {
        let input = SavingsGoalInput(
            accountID: accountID,
            name: "",
            currency: "GBP",
            targetMinorUnits: 1
        )

        var useCaseError: CreateSavingsGoalError?
        do {
            try await useCase.execute(input: input)
        } catch let error {
            useCaseError = error as? CreateSavingsGoalError
        }

        XCTAssertEqual(useCaseError, .invalidName)
        XCTAssertNil(savingsGoalRepository.lastCreateSavingsGoalInput)
    }

    func testExecuteWhenCreateErrorsThrowsError() async {
        let input = SavingsGoalInput(
            accountID: accountID,
            name: "SG 1",
            currency: "GBP",
            targetMinorUnits: 1
        )
        savingsGoalRepository.createResult = .failure(.unknown)

        var useCaseError: CreateSavingsGoalError?
        do {
            try await useCase.execute(input: input)
        } catch let error {
            useCaseError = error as? CreateSavingsGoalError
        }

        XCTAssertEqual(useCaseError, .unknown)
    }

}
