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

    override func setUp() {
        super.setUp()
        savingsGoalRepository = SavingsGoalStubRepository()
        useCase = FetchSavingsGoals(savingsGoalRepository: savingsGoalRepository)
    }

    override func tearDown() {
        useCase = nil
        savingsGoalRepository = nil
        super.tearDown()
    }

    func testExecuteWhenNoSavingsGoalsForAccountReturnsEmptyArray() async throws {
        savingsGoalRepository.savingsGoalsResult = .success([:])

        let savingsGoals = try await useCase.execute(accountID: "1")

        XCTAssertTrue(savingsGoals.isEmpty)
    }

    func testExecuteWhenOneActiveSavingsGoalForAccountReturnsOneSavingsGoal() async throws {
        let accountID = "1"
        let savingsGoal = Self.createSavingsGoal(state: .active)
        savingsGoalRepository.savingsGoalsResult = .success([accountID: [savingsGoal]])

        let savingsGoals = try await useCase.execute(accountID: accountID)

        XCTAssertEqual(savingsGoals.count, 1)
        XCTAssertEqual(savingsGoals.first, savingsGoal)
    }

    func testExecuteWhenOneArchivedSavingsGoalForAccountReturnsEmptyArray() async throws {
        let accountID = "1"
        let savingsGoal = Self.createSavingsGoal(state: .archived)
        savingsGoalRepository.savingsGoalsResult = .success([accountID: [savingsGoal]])

        let savingsGoals = try await useCase.execute(accountID: accountID)

        XCTAssertTrue(savingsGoals.isEmpty)
    }

    func testExecuteWhenMultipleSavingsGoalsWithDifferentStatesReturnsActiveSavingsGoals() async throws {
        let accountID = "1"
        let savingsGoals = [
            Self.createSavingsGoal(id: "1", state: .active),
            Self.createSavingsGoal(id: "2", state: .active),
            Self.createSavingsGoal(id: "3", state: .archived),
            Self.createSavingsGoal(id: "4", state: .archived)
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
            _ = try await useCase.execute(accountID: "1")
        } catch let error {
            useCaseError = error as? FetchSavingsGoalsError
        }

        XCTAssertEqual(useCaseError, .unknown)
    }

}

extension FetchSavingsGoalsTests {

    private static func createSavingsGoal(
        id: String = "sg1",
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
