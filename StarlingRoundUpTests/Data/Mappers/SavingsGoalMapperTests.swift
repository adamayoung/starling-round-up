//
//  SavingsGoalMapperTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 03/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class SavingsGoalMapperTests: XCTestCase {

    func testMapID() throws {
        let savingsGoalID = try XCTUnwrap(UUID(uuidString: "4909F995-64CA-4C9B-AFCE-DDCBCA8DA806"))
        let dataModel = Self.createSavingsGoalDataModel(savingsGoalUid: savingsGoalID)

        let savingsGoal = SavingsGoalMapper.map(dataModel)

        XCTAssertEqual(savingsGoal.id, savingsGoalID)
    }

    func testMapName() throws {
        let savingsGoalID = try XCTUnwrap(UUID(uuidString: "4909F995-64CA-4C9B-AFCE-DDCBCA8DA806"))
        let dataModel = Self.createSavingsGoalDataModel(savingsGoalUid: savingsGoalID, name: "SG")

        let savingsGoal = SavingsGoalMapper.map(dataModel)

        XCTAssertEqual(savingsGoal.name, "SG")
    }

    func testMapTarget() throws {
        let savingsGoalID = try XCTUnwrap(UUID(uuidString: "4909F995-64CA-4C9B-AFCE-DDCBCA8DA806"))
        let dataModel = Self.createSavingsGoalDataModel(
            savingsGoalUid: savingsGoalID,
            target: MoneyDataModel(minorUnits: 123, currency: "GBP")
        )

        let savingsGoal = SavingsGoalMapper.map(dataModel)

        XCTAssertEqual(savingsGoal.target, Money(minorUnits: 123, currency: "GBP"))
    }

    func testMapTotalSaved() throws {
        let savingsGoalID = try XCTUnwrap(UUID(uuidString: "4909F995-64CA-4C9B-AFCE-DDCBCA8DA806"))
        let dataModel = Self.createSavingsGoalDataModel(
            savingsGoalUid: savingsGoalID,
            totalSaved: MoneyDataModel(minorUnits: 456, currency: "GBP")
        )

        let savingsGoal = SavingsGoalMapper.map(dataModel)

        XCTAssertEqual(savingsGoal.totalSaved, Money(minorUnits: 456, currency: "GBP"))
    }

    func testMapSavedPercentage() throws {
        let savingsGoalID = try XCTUnwrap(UUID(uuidString: "4909F995-64CA-4C9B-AFCE-DDCBCA8DA806"))
        let dataModel = Self.createSavingsGoalDataModel(savingsGoalUid: savingsGoalID, savedPercentage: 12)

        let savingsGoal = SavingsGoalMapper.map(dataModel)

        XCTAssertEqual(savingsGoal.savedPercentage, 12)
    }

    func testMapState() throws {
        let savingsGoalID = try XCTUnwrap(UUID(uuidString: "4909F995-64CA-4C9B-AFCE-DDCBCA8DA806"))
        let dataModel = Self.createSavingsGoalDataModel(savingsGoalUid: savingsGoalID, state: .active)

        let savingsGoal = SavingsGoalMapper.map(dataModel)

        XCTAssertEqual(savingsGoal.state, .active)
    }

}

extension SavingsGoalMapperTests {

    private static func createSavingsGoalDataModel(
        savingsGoalUid: UUID,
        name: String = "Test 1",
        target: MoneyDataModel = MoneyDataModel(minorUnits: 0, currency: "GBP"),
        totalSaved: MoneyDataModel = MoneyDataModel(minorUnits: 0, currency: "GBP"),
        savedPercentage: Int = 0,
        state: SavingsGoalStateDataModel = .active
    ) -> SavingsGoalDataModel {
        SavingsGoalDataModel(
            savingsGoalUid: savingsGoalUid,
            name: name,
            target: target,
            totalSaved: totalSaved,
            savedPercentage: savedPercentage,
            state: state
        )
    }

}
