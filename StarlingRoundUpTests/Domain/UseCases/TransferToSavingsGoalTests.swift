//
//  TransferToSavingsGoalTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 07/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class TransferToSavingsGoalTests: XCTestCase {

    var useCase: TransferToSavingsGoal!
    var savingsGoalRepository: SavingsGoalStubRepository!

    override func setUp() {
        super.setUp()
        savingsGoalRepository = SavingsGoalStubRepository()
        useCase = TransferToSavingsGoal(savingsGoalRepository: savingsGoalRepository)
    }

    override func tearDown() {
        useCase = nil
        savingsGoalRepository = nil
        super.tearDown()
    }

    func testExecuteTransferAmount() async throws {
        let input = TransferToSavingsGoalInput(
            accountID: "1",
            savingsGoalID: "sg1",
            amount: Money(minorUnits: 1000, currency: "GBP")
        )
        savingsGoalRepository.transferResult = .success(())

        try await useCase.execute(input: input)

        XCTAssertEqual(savingsGoalRepository.lastTransferAmount, Money(minorUnits: 1000, currency: "GBP"))
        XCTAssertEqual(savingsGoalRepository.lastTransferAccountID, "1")
        XCTAssertEqual(savingsGoalRepository.lastTransferSavingsGoalID, "sg1")
    }

    func testExecuteWhenErrorsThrowsError() async throws {
        let input = TransferToSavingsGoalInput(
            accountID: "1",
            savingsGoalID: "sg1",
            amount: Money(minorUnits: 1000, currency: "GBP")
        )
        savingsGoalRepository.transferResult = .failure(.unknown)

        var useCaseError: TransferToSavingsGoalError?
        do {
            try await useCase.execute(input: input)
        } catch let error {
            useCaseError = error as? TransferToSavingsGoalError
        }

        XCTAssertEqual(useCaseError, .unknown)
    }

}
