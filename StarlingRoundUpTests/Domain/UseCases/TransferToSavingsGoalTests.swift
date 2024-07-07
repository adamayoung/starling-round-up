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
        let input = try TransferToSavingsGoalInput(
            accountID: XCTUnwrap(UUID(uuidString: "E824387A-B85A-4C26-B00F-FD5E104DF697")),
            savingsGoalID: XCTUnwrap(UUID(uuidString: "8A5D4678-A377-4E22-9002-D3A5CB2AE15E")),
            amount: Money(minorUnits: 1000, currency: "GBP")
        )
        savingsGoalRepository.transferResult = .success(())

        try await useCase.execute(input: input)

        XCTAssertEqual(savingsGoalRepository.lastTransferInput, input)
    }

    func testExecuteWhenErrorsThrowsError() async throws {
        let input = try TransferToSavingsGoalInput(
            accountID: XCTUnwrap(UUID(uuidString: "E824387A-B85A-4C26-B00F-FD5E104DF697")),
            savingsGoalID: XCTUnwrap(UUID(uuidString: "8A5D4678-A377-4E22-9002-D3A5CB2AE15E")),
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
