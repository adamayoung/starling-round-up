//
//  FetchRoundUpSummaryTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 04/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class FetchRoundUpSummaryTests: XCTestCase {

    var useCase: FetchRoundUpSummary!
    var accountRepository: AccountStubRepository!
    var transactionRepository: TransactionStubRepository!
    var savingsGoalRepository: SavingsGoalStubRepository!
    var timeZone: TimeZone!
    var roundUpDate: Date!

    override func setUpWithError() throws {
        try super.setUpWithError()
        accountRepository = AccountStubRepository()
        transactionRepository = TransactionStubRepository()
        savingsGoalRepository = SavingsGoalStubRepository()
        timeZone = TimeZone.gmt
        let dateFormatter = ISO8601DateFormatter()
        roundUpDate = try XCTUnwrap(dateFormatter.date(from: "2024-07-03T10:00:00Z"))
        useCase = FetchRoundUpSummary(
            accountRepository: accountRepository,
            transactionRepository: transactionRepository,
            savingsGoalRepository: savingsGoalRepository,
            timeZone: timeZone
        )
    }

    override func tearDown() {
        useCase = nil
        roundUpDate = nil
        timeZone = nil
        transactionRepository = nil
        accountRepository = nil
        super.tearDown()
    }

    func testExecuteWhenFetchAccountErrorsThrowsAccountError() async {
        accountRepository.accountResult = .failure(.unknown)

        var useCaseError: FetchRoundUpSummaryError?
        do {
            _ = try await useCase.execute(accountID: "1", inTimeWindow: .week, withDate: roundUpDate)
        } catch let error {
            useCaseError = error as? FetchRoundUpSummaryError
        }

        XCTAssertEqual(useCaseError, .account)
    }

    func testExecuteWhenAccountNotFoundThrowsError() async {
        accountRepository.accountResult = .success(nil)

        var useCaseError: FetchRoundUpSummaryError?
        do {
            _ = try await useCase.execute(accountID: "1", inTimeWindow: .week, withDate: roundUpDate)
        } catch let error {
            useCaseError = error as? FetchRoundUpSummaryError
        }

        XCTAssertEqual(useCaseError, .accountNotFound)
    }

    func testExecuteWhenFetchingBalanceErrorsThrowsTransactionsError() async {
        let account = Self.createAccount()
        accountRepository.accountResult = .success(account)
        accountRepository.balanceResult = .failure(.unknown)

        var useCaseError: FetchRoundUpSummaryError?
        do {
            _ = try await useCase.execute(accountID: "1", inTimeWindow: .week, withDate: roundUpDate)
        } catch let error {
            useCaseError = error as? FetchRoundUpSummaryError
        }

        XCTAssertEqual(useCaseError, .transactions)
    }

    func testExecuteWhenAccountBalanceNotFoundReturnsSummaryWithZeroAccountBalance() async throws {
        let account = Self.createAccount()
        accountRepository.accountResult = .success(account)
        accountRepository.balanceResult = .success([:])
        transactionRepository.transactionsResult = .success([:])
        savingsGoalRepository.savingsGoalsResult = .success([:])

        let summary = try await useCase.execute(accountID: account.id, inTimeWindow: .week, withDate: roundUpDate)
        let accountBalance = summary.accountBalance

        XCTAssertEqual(accountBalance, Money(minorUnits: 0, currency: account.currency))
    }

    func testExecuteReturnsSummaryWithAccountBalance() async throws {
        let account = Self.createAccount()
        let accountBalance = Money(minorUnits: 1000, currency: "GBP")
        accountRepository.accountResult = .success(account)
        accountRepository.balanceResult = .success([account.id: accountBalance])
        transactionRepository.transactionsResult = .success([:])
        savingsGoalRepository.savingsGoalsResult = .success([:])

        let summary = try await useCase.execute(accountID: account.id, inTimeWindow: .week, withDate: roundUpDate)

        XCTAssertEqual(summary.accountBalance, accountBalance)
    }

    func testExecuteFetchesTransactionsForAccountInDateRange() async throws {
        let account = Self.createAccount()
        let timeWindow = RoundUpTimeWindow.week
        let dateRange = timeWindow.dateRange(containing: roundUpDate, in: TimeZone.gmt)
        accountRepository.accountResult = .success(account)
        accountRepository.balanceResult = .success([:])
        transactionRepository.transactionsResult = .success([:])
        savingsGoalRepository.savingsGoalsResult = .success([:])

        _ = try await useCase.execute(accountID: account.id, inTimeWindow: .week, withDate: roundUpDate)

        XCTAssertEqual(transactionRepository.lastSettledTransactionsAccountID, account.id)
        XCTAssertEqual(transactionRepository.lastSettledTransactionsFromDate, dateRange.lowerBound)
        XCTAssertEqual(transactionRepository.lastSettledTransactionsToDate, dateRange.upperBound)
    }

    func testExecuteReturnsRoundUpSummaryWithAccountID() async throws {
        let account = Self.createAccount()
        accountRepository.accountResult = .success(account)
        accountRepository.balanceResult = .success([:])
        transactionRepository.transactionsResult = .success([:])
        savingsGoalRepository.savingsGoalsResult = .success([:])

        let summary = try await useCase.execute(accountID: account.id, inTimeWindow: .week, withDate: roundUpDate)

        XCTAssertEqual(summary.accountID, account.id)
    }

    func testExecuteReturnsRoundUpSummaryWithDateRange() async throws {
        let account = Self.createAccount()
        let timeWindow = RoundUpTimeWindow.week
        let expectedDateRange = timeWindow.dateRange(containing: roundUpDate, in: TimeZone.gmt)
        accountRepository.accountResult = .success(account)
        accountRepository.balanceResult = .success([:])
        transactionRepository.transactionsResult = .success([:])
        savingsGoalRepository.savingsGoalsResult = .success([:])

        let summary = try await useCase.execute(accountID: account.id, inTimeWindow: .week, withDate: roundUpDate)

        XCTAssertEqual(summary.dateRange, expectedDateRange)
    }

}

extension FetchRoundUpSummaryTests {

    func testExecuteWhenFetchingTransactionsErrorsThrowsError() async {
        let account = Self.createAccount()
        accountRepository.accountResult = .success(account)
        accountRepository.balanceResult = .success([:])
        transactionRepository.transactionsResult = .failure(.unknown)
        savingsGoalRepository.savingsGoalsResult = .success([:])

        var useCaseError: FetchRoundUpSummaryError?
        do {
            _ = try await useCase.execute(accountID: "1", inTimeWindow: .week, withDate: roundUpDate)
        } catch let error {
            useCaseError = error as? FetchRoundUpSummaryError
        }

        XCTAssertEqual(useCaseError, .transactions)
    }

    func testExecuteWhenZeroTransactionsReturnsAccountSummaryWithZeroAmount() async throws {
        let account = Self.createAccount()
        let expectedRoundUpAmount = Money(minorUnits: 0, currency: account.currency)
        accountRepository.accountResult = .success(account)
        accountRepository.balanceResult = .success([:])
        transactionRepository.transactionsResult = .success([account.id: []])
        savingsGoalRepository.savingsGoalsResult = .success([:])

        let summary = try await useCase.execute(accountID: account.id, inTimeWindow: .week, withDate: roundUpDate)

        XCTAssertEqual(summary.amount, expectedRoundUpAmount)
    }

    func testExecuteWhenMultipleIncomingTransactionsReturnsAccountSummaryWithZeroAmount() async throws {
        let account = Self.createAccount()
        let transactions = [
            Self.createTransaction(id: "1", direction: .incoming),
            Self.createTransaction(id: "2", direction: .incoming),
            Self.createTransaction(id: "3", direction: .incoming)
        ]
        let expectedRoundUpAmount = Money(minorUnits: 0, currency: account.currency)
        accountRepository.accountResult = .success(account)
        accountRepository.balanceResult = .success([:])
        transactionRepository.transactionsResult = .success([account.id: transactions])
        savingsGoalRepository.savingsGoalsResult = .success([:])

        let summary = try await useCase.execute(accountID: account.id, inTimeWindow: .week, withDate: roundUpDate)

        XCTAssertEqual(summary.amount, expectedRoundUpAmount)
    }

    func testExecuteWhenOneOutgoingTransactionWhichRoundsUpToZeroReturnsAccountSummaryWithZeroAmount() async throws {
        let account = Self.createAccount()
        let transactions = [
            Self.createTransaction(id: "1", amount: Money(minorUnits: 1000, currency: "GBP"), direction: .outgoing)
        ]
        let expectedRoundUpAmount = Money(minorUnits: 0, currency: account.currency)
        accountRepository.accountResult = .success(account)
        accountRepository.balanceResult = .success([:])
        transactionRepository.transactionsResult = .success([account.id: transactions])
        savingsGoalRepository.savingsGoalsResult = .success([:])

        let summary = try await useCase.execute(accountID: account.id, inTimeWindow: .week, withDate: roundUpDate)

        XCTAssertEqual(summary.amount, expectedRoundUpAmount)
    }

    func testExecuteWhenOneOutgoingTransactionLessThanMajorUnitReturnsAccountSummaryWithAmount() async throws {
        let account = Self.createAccount()
        let transactions = [
            Self.createTransaction(id: "1", amount: Money(minorUnits: 87, currency: "GBP"), direction: .outgoing)
        ]
        let expectedRoundUpAmount = Money(minorUnits: 13, currency: account.currency)
        accountRepository.accountResult = .success(account)
        accountRepository.balanceResult = .success([:])
        transactionRepository.transactionsResult = .success([account.id: transactions])
        savingsGoalRepository.savingsGoalsResult = .success([:])

        let summary = try await useCase.execute(accountID: account.id, inTimeWindow: .week, withDate: roundUpDate)

        XCTAssertEqual(summary.amount, expectedRoundUpAmount)
    }

    func testExecuteWhenOneOutgoingTransactionGreatherThanMajorUnitReturnsAccountSummaryWithAmount() async throws {
        let account = Self.createAccount()
        let transactions = [
            Self.createTransaction(id: "1", amount: Money(minorUnits: 1049, currency: "GBP"), direction: .outgoing)
        ]
        let expectedRoundUpAmount = Money(minorUnits: 51, currency: account.currency)
        accountRepository.accountResult = .success(account)
        accountRepository.balanceResult = .success([:])
        transactionRepository.transactionsResult = .success([account.id: transactions])
        savingsGoalRepository.savingsGoalsResult = .success([:])

        let summary = try await useCase.execute(accountID: account.id, inTimeWindow: .week, withDate: roundUpDate)

        XCTAssertEqual(summary.amount, expectedRoundUpAmount)
    }

    func testExecuteWhenMultipleOutgoingTransactionWithRoundsUpsReturnsAccountSummaryWithAmount() async throws {
        let account = Self.createAccount()
        let transactions = [
            Self.createTransaction(id: "1", amount: Money(minorUnits: 435, currency: "GBP"), direction: .outgoing),
            Self.createTransaction(id: "2", amount: Money(minorUnits: 520, currency: "GBP"), direction: .outgoing),
            Self.createTransaction(id: "3", amount: Money(minorUnits: 87, currency: "GBP"), direction: .outgoing)
        ]
        let expectedRoundUpAmount = Money(minorUnits: 158, currency: account.currency)
        accountRepository.accountResult = .success(account)
        accountRepository.balanceResult = .success([:])
        transactionRepository.transactionsResult = .success([account.id: transactions])
        savingsGoalRepository.savingsGoalsResult = .success([:])

        let summary = try await useCase.execute(accountID: account.id, inTimeWindow: .week, withDate: roundUpDate)

        XCTAssertEqual(summary.amount, expectedRoundUpAmount)
    }

    func testExecuteWhenMultipleIncomingOutgoingTransactionsReturnsAccountSummaryWithAmount() async throws {
        let account = Self.createAccount()
        let transactions = [
            Self.createTransaction(id: "1", amount: Money(minorUnits: 435, currency: "GBP"), direction: .outgoing),
            Self.createTransaction(id: "2", amount: Money(minorUnits: 123, currency: "GBP"), direction: .incoming),
            Self.createTransaction(id: "3", amount: Money(minorUnits: 2353, currency: "GBP"), direction: .incoming),
            Self.createTransaction(id: "4", amount: Money(minorUnits: 520, currency: "GBP"), direction: .outgoing),
            Self.createTransaction(id: "5", amount: Money(minorUnits: 87, currency: "GBP"), direction: .outgoing),
            Self.createTransaction(id: "6", amount: Money(minorUnits: 1011, currency: "GBP"), direction: .incoming)
        ]
        let expectedRoundUpAmount = Money(minorUnits: 158, currency: account.currency)
        accountRepository.accountResult = .success(account)
        accountRepository.balanceResult = .success([:])
        transactionRepository.transactionsResult = .success([account.id: transactions])
        savingsGoalRepository.savingsGoalsResult = .success([:])

        let summary = try await useCase.execute(accountID: account.id, inTimeWindow: .week, withDate: roundUpDate)

        XCTAssertEqual(summary.amount, expectedRoundUpAmount)
    }

    func testExecuteReturnsRoundUpSummaryWithAvailableSavingsGoals() async throws {
        let account = Self.createAccount()
        let savingsGoals = [Self.createSavingsGoal(id: "sg1"), Self.createSavingsGoal(id: "sg2")]
        accountRepository.accountResult = .success(account)
        accountRepository.balanceResult = .success([:])
        transactionRepository.transactionsResult = .success([:])
        savingsGoalRepository.savingsGoalsResult = .success([account.id: savingsGoals])

        let summary = try await useCase.execute(accountID: account.id, inTimeWindow: .week, withDate: roundUpDate)

        XCTAssertEqual(summary.availableSavingsGoals, savingsGoals)
    }

    func testExecuteWhenSavingsGoalsErrorsThrowsSavingsGoalError() async throws {
        let account = Self.createAccount()
        accountRepository.accountResult = .success(account)
        accountRepository.balanceResult = .success([:])
        transactionRepository.transactionsResult = .success([:])
        savingsGoalRepository.savingsGoalsResult = .failure(.unknown)

        var useCaseError: FetchRoundUpSummaryError?
        do {
            _ = try await useCase.execute(accountID: account.id, inTimeWindow: .week, withDate: roundUpDate)
        } catch let error {
            useCaseError = error as? FetchRoundUpSummaryError
        }

        XCTAssertEqual(useCaseError, .savingsGoals)
    }

}

extension FetchRoundUpSummaryTests {

    private static func createAccount(
        id: String = "1",
        name: String = "Test 1",
        type: AccountType = .primary,
        currency: String = "GBP"
    ) -> Account {
        Account(id: id, name: name, type: type, currency: currency)
    }

    private static func createTransaction(
        id: String = "1",
        amount: Money = Money(minorUnits: 0, currency: "GBP"),
        direction: Transaction.Direction
    ) -> Transaction {
        Transaction(id: id, amount: amount, direction: direction)
    }

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
