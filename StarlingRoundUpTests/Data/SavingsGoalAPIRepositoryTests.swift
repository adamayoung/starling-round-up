//
//  SavingsGoalAPIRepositoryTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 03/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class SavingsGoalAPIRepositoryTests: XCTestCase {

    var repository: SavingsGoalAPIRepository!
    var apiClient: APIStubClient!

    override func setUp() {
        super.setUp()
        apiClient = APIStubClient()
        repository = SavingsGoalAPIRepository(apiClient: apiClient)
    }

    override func tearDown() {
        repository = nil
        apiClient = nil
        super.tearDown()
    }

    

}
