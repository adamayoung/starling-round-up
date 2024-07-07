//
//  AddSavingsGoalViewModelTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 04/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class AddSavingsGoalViewModelTests: XCTestCase {

    var viewModel: AddSavingsGoalViewModel!
    var accountID: Account.ID!
    var createSavingsGoalUseCase: CreateSavingsGoalStubUseCase!

    override func setUpWithError() throws {
        try super.setUpWithError()
        accountID = try XCTUnwrap(UUID(uuidString: "C74A112D-4997-4F67-B958-8A80E1A0F8BB"))
        createSavingsGoalUseCase = CreateSavingsGoalStubUseCase()
        viewModel = AddSavingsGoalViewModel(accountID: accountID, createSavingsGoalUseCase: createSavingsGoalUseCase)
    }

    override func tearDown() {
        viewModel = nil
        createSavingsGoalUseCase = nil
        accountID = nil
        super.tearDown()
    }

    func testSaveCreatesSavingsGoal() async throws {
        let savingsGoalName = "SG 1"
        let savingsGoalTarget = 1000
        viewModel.savingsGoalName = savingsGoalName
        viewModel.savingsGoalTarget = savingsGoalTarget
        let expectedInput = SavingsGoalInput(
            accountID: accountID,
            name: savingsGoalName,
            currency: viewModel.currency,
            targetMinorUnits: savingsGoalTarget
        )
        createSavingsGoalUseCase.result = .success(())

        try await viewModel.save()

        XCTAssertEqual(createSavingsGoalUseCase.lastInput, expectedInput)
    }

    func testSaveWhenErrorsThrowsError() async throws {
        let savingsGoalName = "SG 1"
        let savingsGoalTarget = 1000
        viewModel.savingsGoalName = savingsGoalName
        viewModel.savingsGoalTarget = savingsGoalTarget
        createSavingsGoalUseCase.result = .failure(.unknown)

        var createSavingsGoalError: CreateSavingsGoalError?
        do {
            try await viewModel.save()
        } catch let error {
            createSavingsGoalError = error as? CreateSavingsGoalError
        }

        XCTAssertEqual(createSavingsGoalError, .unknown)
    }

    func testIsFormValidWhenSavingsGoalIsNilAndSavingsGoalTargetIsNilReturnsFalse() {
        viewModel.savingsGoalName = nil
        viewModel.savingsGoalTarget = nil

        let isFormValid = viewModel.isFormValid

        XCTAssertFalse(isFormValid)
    }

    func testIsFormValidWhenSavingsGoalHasValueAndSavingsGoalTargetIsNilReturnsFalse() {
        viewModel.savingsGoalName = "SG 1"
        viewModel.savingsGoalTarget = nil

        let isFormValid = viewModel.isFormValid

        XCTAssertFalse(isFormValid)
    }

    func testIsFormValidWhenSavingsGoalIsNilAndSavingsGoalTargetHasValueReturnsFalse() {
        viewModel.savingsGoalName = nil
        viewModel.savingsGoalTarget = 1000

        let isFormValid = viewModel.isFormValid

        XCTAssertFalse(isFormValid)
    }

    func testIsFormValidWhenSavingsGoalHasValueAndSavingsGoalTargetHasValueReturnsTrue() {
        viewModel.savingsGoalName = "SG 1"
        viewModel.savingsGoalTarget = 1000

        let isFormValid = viewModel.isFormValid

        XCTAssertTrue(isFormValid)
    }

    func testOnFormValidChangedWhenSavingsGoalHasValueSetAndSavingsGoalTargetIsNilClosureIsCalledWithFalse() throws {
        let expectation = expectation(description: "onFormValidChanged")
        var isFormValid: Bool?
        viewModel.onFormValidChanged = { isValid in
            isFormValid = isValid
            expectation.fulfill()
        }

        viewModel.savingsGoalName = "SG 1"
        waitForExpectations(timeout: 1)

        let result = try XCTUnwrap(isFormValid)
        XCTAssertFalse(result)
    }

    func testOnFormValidChangedWhenSavingsGoalIsNilAndSavingsGoalTargetHasValueSetClosureIsCalledWithFalse() throws {
        let expectation = expectation(description: "onFormValidChanged")
        var isFormValid: Bool?
        viewModel.onFormValidChanged = { isValid in
            isFormValid = isValid
            expectation.fulfill()
        }

        viewModel.savingsGoalTarget = 1000
        waitForExpectations(timeout: 1)

        let result = try XCTUnwrap(isFormValid)
        XCTAssertFalse(result)
    }

    func testOnFormValidChangedWhenSavingsGoalAndSavingsGoalTargetHaveValuesSetClosureIsCalledWithTrue() throws {
        let expectation = expectation(description: "onFormValidChanged")
        var isFormValid: Bool?
        viewModel.onFormValidChanged = { isValid in
            isFormValid = isValid

            if isValid {
                expectation.fulfill()
            }
        }

        viewModel.savingsGoalName = "SG 1"
        viewModel.savingsGoalTarget = 1000
        waitForExpectations(timeout: 1)

        let result = try XCTUnwrap(isFormValid)
        XCTAssertTrue(result)
    }

}
