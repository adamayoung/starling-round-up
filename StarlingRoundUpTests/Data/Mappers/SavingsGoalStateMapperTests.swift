//
//  SavingsGoalStateMapperTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 03/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class SavingsGoalStateMapperTests: XCTestCase {

    func testMapCreating() {
        let dataModel = SavingsGoalStateDataModel.creating

        let state = SavingsGoalStateMapper.map(dataModel)

        XCTAssertEqual(state, .creating)
    }

    func testMapActive() {
        let dataModel = SavingsGoalStateDataModel.active

        let state = SavingsGoalStateMapper.map(dataModel)

        XCTAssertEqual(state, .active)
    }

    func testMapArchiving() {
        let dataModel = SavingsGoalStateDataModel.archiving

        let state = SavingsGoalStateMapper.map(dataModel)

        XCTAssertEqual(state, .archiving)
    }

    func testMapArchived() {
        let dataModel = SavingsGoalStateDataModel.archived

        let state = SavingsGoalStateMapper.map(dataModel)

        XCTAssertEqual(state, .archived)
    }

    func testMapRestoring() {
        let dataModel = SavingsGoalStateDataModel.restoring

        let state = SavingsGoalStateMapper.map(dataModel)

        XCTAssertEqual(state, .restoring)
    }

    func testMapPending() {
        let dataModel = SavingsGoalStateDataModel.pending

        let state = SavingsGoalStateMapper.map(dataModel)

        XCTAssertEqual(state, .pending)
    }

    func testMapUnknown() {
        let dataModel = SavingsGoalStateDataModel.unknown

        let state = SavingsGoalStateMapper.map(dataModel)

        XCTAssertEqual(state, .unknown)
    }

}
