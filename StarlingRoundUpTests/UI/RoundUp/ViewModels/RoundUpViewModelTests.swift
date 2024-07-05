//
//  RoundUpViewModelTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 05/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class RoundUpViewModelTests: XCTestCase {

    var viewModel: RoundUpViewModel!
    var accountID: Account.ID!
    var fetchRoundUpSummaryUseCase: FetchRoundUpSummaryStubUseCase!
    var fetchSavingsGoalsUseCase: FetchSavingsGoalsStubUseCase!

    override func setUp() {
        super.setUp()
        accountID = "1"
        fetchRoundUpSummaryUseCase = FetchRoundUpSummaryStubUseCase()
        fetchSavingsGoalsUseCase = FetchSavingsGoalsStubUseCase()
        viewModel = RoundUpViewModel(
            accountID: accountID,
            fetchRoundUpSummaryUseCase: fetchRoundUpSummaryUseCase,
            fetchSavingsGoalsUseCase: fetchSavingsGoalsUseCase
        )
    }

    override func tearDown() {
        viewModel = nil
        fetchSavingsGoalsUseCase = nil
        fetchRoundUpSummaryUseCase = nil
        accountID = nil
        super.tearDown()
    }

}
