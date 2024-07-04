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

    override func setUp() {
        super.setUp()
        accountID = "1"
        createSavingsGoalUseCase = CreateSavingsGoalStubUseCase()
        viewModel = AddSavingsGoalViewModel(accountID: accountID, createSavingsGoalUseCase: createSavingsGoalUseCase)
    }

    override func tearDown() {
        viewModel = nil
        createSavingsGoalUseCase = nil
        accountID = nil
        super.tearDown()
    }

}
