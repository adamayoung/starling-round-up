//
//  SavingsGoalMapperTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 03/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class SavingsGoalMapperTests: XCTestCase {

    func testMapID() {
        let dataModel = Self.createSavingsGoalDataModel(savingsGoalUid: "1")

        let savingsGoal = SavingsGoalMapper.map(dataModel)

        XCTAssertEqual(savingsGoal.id, "1")
    }

    func testMapName() {
        let dataModel = Self.createSavingsGoalDataModel(name: "SG 1")

        let savingsGoal = SavingsGoalMapper.map(dataModel)

        XCTAssertEqual(savingsGoal.name, "SG 1")
    }

    func testMapTarget() {
        let dataModel = Self.createSavingsGoalDataModel(target: MoneyDataModel(minorUnits: 123, currency: "GBP"))

        let savingsGoal = SavingsGoalMapper.map(dataModel)

        XCTAssertEqual(savingsGoal.target, Money(minorUnits: 123, currency: "GBP"))
    }

    func testMapTotalSaved() {
        let dataModel = Self.createSavingsGoalDataModel(totalSaved: MoneyDataModel(minorUnits: 456, currency: "GBP"))

        let savingsGoal = SavingsGoalMapper.map(dataModel)

        XCTAssertEqual(savingsGoal.totalSaved, Money(minorUnits: 456, currency: "GBP"))
    }

    func testMapSavedPercentage() {
        let dataModel = Self.createSavingsGoalDataModel(savedPercentage: 12)

        let savingsGoal = SavingsGoalMapper.map(dataModel)

        XCTAssertEqual(savingsGoal.savedPercentage, 12)
    }

    func testMapState() {
        let dataModel = Self.createSavingsGoalDataModel(state: .active)

        let savingsGoal = SavingsGoalMapper.map(dataModel)

        XCTAssertEqual(savingsGoal.state, .active)
    }

}

extension SavingsGoalMapperTests {

    private static func createSavingsGoalDataModel(
        savingsGoalUid: String = "1",
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
