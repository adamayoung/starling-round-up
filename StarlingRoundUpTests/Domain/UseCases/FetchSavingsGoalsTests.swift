//
//  FetchSavingsGoalsTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 03/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class FetchSavingsGoalsTests: XCTestCase {

    var useCase: FetchSavingsGoals!
    var savingsGoalRepository: SavingsGoalStubRepository!
    var accountID: UUID!

    override func setUpWithError() throws {
        try super.setUpWithError()
        savingsGoalRepository = SavingsGoalStubRepository()
        useCase = FetchSavingsGoals(savingsGoalRepository: savingsGoalRepository)
        accountID = try XCTUnwrap(UUID(uuidString: "CE2322FF-D843-4816-AADA-F81EA28FD6DF"))
    }

    override func tearDown() {
        accountID = nil
        useCase = nil
        savingsGoalRepository = nil
        super.tearDown()
    }

    func testExecuteWhenNoSavingsGoalsForAccountReturnsEmptyArray() async throws {
        savingsGoalRepository.savingsGoalsResult = .success([:])

        let savingsGoals = try await useCase.execute(accountID: accountID)

        XCTAssertTrue(savingsGoals.isEmpty)
    }

    func testExecuteWhenOneActiveSavingsGoalForAccountReturnsOneSavingsGoal() async throws {
        let savingsGoalID = try XCTUnwrap(UUID(uuidString: "B9170EEA-0996-4320-B465-CA6A88657632"))
        let savingsGoal = Self.createSavingsGoal(id: savingsGoalID, state: .active)
        savingsGoalRepository.savingsGoalsResult = .success([accountID: [savingsGoal]])

        let savingsGoals = try await useCase.execute(accountID: accountID)

        XCTAssertEqual(savingsGoals.count, 1)
        XCTAssertEqual(savingsGoals.first, savingsGoal)
    }

    func testExecuteWhenOneArchivedSavingsGoalForAccountReturnsEmptyArray() async throws {
        let savingsGoalID = try XCTUnwrap(UUID(uuidString: "B9170EEA-0996-4320-B465-CA6A88657632"))
        let savingsGoal = Self.createSavingsGoal(id: savingsGoalID, state: .archived)
        savingsGoalRepository.savingsGoalsResult = .success([accountID: [savingsGoal]])

        let savingsGoals = try await useCase.execute(accountID: accountID)

        XCTAssertTrue(savingsGoals.isEmpty)
    }

    func testExecuteWhenMultipleSavingsGoalsWithDifferentStatesReturnsActiveSavingsGoals() async throws {
        let savingsGoals = try [
            Self.createSavingsGoal(
                id: XCTUnwrap(UUID(uuidString: "B9170EEA-0996-4320-B465-CA6A88657632")),
                state: .active
            ),
            Self.createSavingsGoal(
                id: XCTUnwrap(UUID(uuidString: "D446C6E5-DD17-48FB-85A5-8F2005166F14")),
                state: .active
            ),
            Self.createSavingsGoal(
                id: XCTUnwrap(UUID(uuidString: "5DB13E1E-89BB-49D7-A27B-8A8C58487ADA")),
                state: .archived
            ),
            Self.createSavingsGoal(
                id: XCTUnwrap(UUID(uuidString: "08C03F6B-F147-4782-9296-0E64EEBAB592")),
                state: .archived
            )
        ]
        savingsGoalRepository.savingsGoalsResult = .success([accountID: savingsGoals])

        let savingsGoalsResult = try await useCase.execute(accountID: accountID)

        XCTAssertEqual(savingsGoalsResult.count, 2)
        XCTAssertTrue(savingsGoalsResult.allSatisfy { $0.state == .active })
    }

    func testExecuteWhenFetchSavingsGoalsErrorsThrowsError() async {
        savingsGoalRepository.savingsGoalsResult = .failure(.unknown)

        var useCaseError: FetchSavingsGoalsError?
        do {
            _ = try await useCase.execute(accountID: accountID)
        } catch let error {
            useCaseError = error as? FetchSavingsGoalsError
        }

        XCTAssertEqual(useCaseError, .unknown)
    }

}

extension FetchSavingsGoalsTests {

    private static func createSavingsGoal(
        id: UUID,
        name: String = "Test 1",
        target: Money = Money(minorUnits: 0, currency: "GBP"),
        totalSaved: Money = Money(minorUnits: 0, currency: "GBP"),
        savedPercentage: Int = 0,
        state: SavingsGoalState = .active
    ) -> SavingsGoal {
        SavingsGoal(
            id: id,
            name: name,
            target: target,
            totalSaved: totalSaved,
            savedPercentage: savedPercentage,
            state: state
        )
    }

}
