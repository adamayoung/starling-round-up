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
    var timeZone: TimeZone!
    var roundUpDate: Date!

    override func setUpWithError() throws {
        try super.setUpWithError()
        accountRepository = AccountStubRepository()
        transactionRepository = TransactionStubRepository()
        timeZone = TimeZone.gmt
        let dateFormatter = ISO8601DateFormatter()
        // Wednesday, 3rd July 2024 10:00:00 UTC
        roundUpDate = try XCTUnwrap(dateFormatter.date(from: "2024-07-03T10:00:00Z"))
        useCase = FetchRoundUpSummary(
            accountRepository: accountRepository,
            transactionRepository: transactionRepository,
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

    func testExecuteWhenFetchAccountErrorsThrowsError() async {
        accountRepository.accountResult = .failure(.unknown)

        var useCaseError: FetchRoundUpSummaryError?
        do {
            _ = try await useCase.execute(accountID: "1", inTimeWindow: .week, withDate: roundUpDate)
        } catch let error {
            useCaseError = error as? FetchRoundUpSummaryError
        }

        XCTAssertEqual(useCaseError, .unknown)
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

    func testExecuteWhenFetchingBalanceErrorsThrowsError() async {
        let account = Self.createAccount()
        accountRepository.accountResult = .success(account)
        accountRepository.balanceResult = .failure(.unknown)

        var useCaseError: FetchRoundUpSummaryError?
        do {
            _ = try await useCase.execute(accountID: "1", inTimeWindow: .week, withDate: roundUpDate)
        } catch let error {
            useCaseError = error as? FetchRoundUpSummaryError
        }

        XCTAssertEqual(useCaseError, .unknown)
    }

    func testExecuteWhenAccountBalanceNotFoundReturnsSummaryWithZeroAccountBalance() async throws {
        let account = Self.createAccount()
        accountRepository.accountResult = .success(account)
        accountRepository.balanceResult = .success([:])
        transactionRepository.transactionsResult = .success([:])

        let roundUpSummary = try await useCase.execute(
            accountID: account.id,
            inTimeWindow: .week,
            withDate: roundUpDate
        )
        let accountBalance = roundUpSummary.accountBalance

        XCTAssertEqual(accountBalance, Money(minorUnits: 0, currency: account.currency))
    }

    func testExecuteReturnsSummaryWithAccountBalance() async throws {
        let account = Self.createAccount()
        let accountBalance = Money(minorUnits: 1000, currency: "GBP")
        accountRepository.accountResult = .success(account)
        accountRepository.balanceResult = .success([account.id: accountBalance])
        transactionRepository.transactionsResult = .success([:])

        let roundUpSummary = try await useCase.execute(
            accountID: account.id,
            inTimeWindow: .week,
            withDate: roundUpDate
        )

        XCTAssertEqual(roundUpSummary.accountBalance, accountBalance)
    }

    func testExecuteFetchesTransactionsForAccountInDateRange() async throws {
        let account = Self.createAccount()
        let timeWindow = RoundUpTimeWindow.week
        let dateRange = timeWindow.dateRange(containing: roundUpDate, in: TimeZone.gmt)
        accountRepository.accountResult = .success(account)
        accountRepository.balanceResult = .success([:])
        transactionRepository.transactionsResult = .success([:])

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

        let roundUpSummary = try await useCase.execute(
            accountID: account.id,
            inTimeWindow: .week,
            withDate: roundUpDate
        )

        XCTAssertEqual(roundUpSummary.accountID, account.id)
    }

    func testExecuteReturnsRoundUpSummaryWithDateRange() async throws {
        let account = Self.createAccount()
        let timeWindow = RoundUpTimeWindow.week
        let expectedDateRange = timeWindow.dateRange(containing: roundUpDate, in: TimeZone.gmt)
        accountRepository.accountResult = .success(account)
        accountRepository.balanceResult = .success([:])
        transactionRepository.transactionsResult = .success([:])

        let roundUpSummary = try await useCase.execute(
            accountID: account.id,
            inTimeWindow: .week,
            withDate: roundUpDate
        )

        XCTAssertEqual(roundUpSummary.dateRange, expectedDateRange)
    }

}

extension FetchRoundUpSummaryTests {

    func testExecuteWhenFetchingTransactionsErrorsThrowsError() async {
        let account = Self.createAccount()
        accountRepository.accountResult = .success(account)
        accountRepository.balanceResult = .success([:])
        transactionRepository.transactionsResult = .failure(.unknown)

        var useCaseError: FetchRoundUpSummaryError?
        do {
            _ = try await useCase.execute(accountID: "1", inTimeWindow: .week, withDate: roundUpDate)
        } catch let error {
            useCaseError = error as? FetchRoundUpSummaryError
        }

        XCTAssertEqual(useCaseError, .unknown)
    }

    func testExecuteWhenZeroTransactionsReturnsAccountSummaryWithZeroAmount() async throws {
        let account = Self.createAccount()
        let expectedRoundUpAmount = Money(minorUnits: 0, currency: account.currency)
        accountRepository.accountResult = .success(account)
        accountRepository.balanceResult = .success([:])
        transactionRepository.transactionsResult = .success([account.id: []])

        let roundUpSummary = try await useCase.execute(
            accountID: account.id,
            inTimeWindow: .week,
            withDate: roundUpDate
        )

        XCTAssertEqual(roundUpSummary.amount, expectedRoundUpAmount)
        XCTAssertEqual(roundUpSummary.transactionsCount, 0)
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

        let roundUpSummary = try await useCase.execute(
            accountID: account.id,
            inTimeWindow: .week,
            withDate: roundUpDate
        )

        XCTAssertEqual(roundUpSummary.amount, expectedRoundUpAmount)
        XCTAssertEqual(roundUpSummary.transactionsCount, 0)
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

        let roundUpSummary = try await useCase.execute(
            accountID: account.id,
            inTimeWindow: .week,
            withDate: roundUpDate
        )

        XCTAssertEqual(roundUpSummary.amount, expectedRoundUpAmount)
        XCTAssertEqual(roundUpSummary.transactionsCount, 1)
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

        let roundUpSummary = try await useCase.execute(
            accountID: account.id,
            inTimeWindow: .week,
            withDate: roundUpDate
        )

        XCTAssertEqual(roundUpSummary.amount, expectedRoundUpAmount)
        XCTAssertEqual(roundUpSummary.transactionsCount, 1)
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

        let roundUpSummary = try await useCase.execute(
            accountID: account.id,
            inTimeWindow: .week,
            withDate: roundUpDate
        )

        XCTAssertEqual(roundUpSummary.amount, expectedRoundUpAmount)
        XCTAssertEqual(roundUpSummary.transactionsCount, 1)
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

        let roundUpSummary = try await useCase.execute(
            accountID: account.id,
            inTimeWindow: .week,
            withDate: roundUpDate
        )

        XCTAssertEqual(roundUpSummary.amount, expectedRoundUpAmount)
        XCTAssertEqual(roundUpSummary.transactionsCount, 3)
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

        let roundUpSummary = try await useCase.execute(
            accountID: account.id,
            inTimeWindow: .week,
            withDate: roundUpDate
        )

        XCTAssertEqual(roundUpSummary.amount, expectedRoundUpAmount)
        XCTAssertEqual(roundUpSummary.transactionsCount, 3)
    }

}

extension FetchRoundUpSummaryTests {

    private static func createAccount(
        id: String = "1",
        name: String = "Test 1",
        type: AccountType = .primary,
        currency: String = "GBP"
    ) -> Account {
        Account(
            id: id,
            name: name,
            type: type,
            currency: currency
        )
    }

    private static func createTransaction(
        id: String = "1",
        amount: Money = Money(minorUnits: 0, currency: "GBP"),
        direction: Transaction.Direction
    ) -> Transaction {
        Transaction(
            id: id,
            amount: amount,
            direction: direction
        )
    }

}
