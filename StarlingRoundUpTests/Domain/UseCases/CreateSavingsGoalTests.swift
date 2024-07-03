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

    override func setUp() {
        super.setUp()
        savingsGoalRepository = SavingsGoalStubRepository()
        useCase = CreateSavingsGoal(savingsGoalRepository: savingsGoalRepository)
    }

    override func tearDown() {
        useCase = nil
        savingsGoalRepository = nil
        super.tearDown()
    }

    func testExecuteWhenValidInputCreatesSavingsGoal() async throws {
        let input = SavingsGoalInput(
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
