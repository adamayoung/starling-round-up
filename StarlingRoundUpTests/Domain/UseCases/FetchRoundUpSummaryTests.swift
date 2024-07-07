//
//  FetchRoundUpSummaryTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 04/07/2024.
//

@testable import StarlingRoundUp
import XCTest

// swiftlint:disable file_length
final class FetchRoundUpSummaryTests: XCTestCase {

    var useCase: FetchRoundUpSummary!
    var accountRepository: AccountStubRepository!
    var transactionRepository: TransactionStubRepository!
    var savingsGoalRepository: SavingsGoalStubRepository!
    var timeZone: TimeZone!
    var accountID: UUID!
    var roundUpDate: Date!

    override func setUpWithError() throws {
        try super.setUpWithError()
        accountRepository = AccountStubRepository()
        transactionRepository = TransactionStubRepository()
        savingsGoalRepository = SavingsGoalStubRepository()
        timeZone = TimeZone.gmt
        accountID = try XCTUnwrap(UUID(uuidString: "0524257F-DD30-4AB9-AB98-B29F8F8010C8"))
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
        accountID = nil
        timeZone = nil
        transactionRepository = nil
        accountRepository = nil
        super.tearDown()
    }

    func testExecuteWhenFetchAccountErrorsThrowsAccountError() async {
        accountRepository.accountResult = .failure(.unknown)

        var useCaseError: FetchRoundUpSummaryError?
        do {
            _ = try await useCase.execute(accountID: accountID, inTimeWindow: .week, withDate: roundUpDate)
        } catch let error {
            useCaseError = error as? FetchRoundUpSummaryError
        }

        XCTAssertEqual(useCaseError, .account)
    }

    func testExecuteWhenAccountNotFoundThrowsError() async {
        accountRepository.accountResult = .success(nil)

        var useCaseError: FetchRoundUpSummaryError?
        do {
            _ = try await useCase.execute(accountID: accountID, inTimeWindow: .week, withDate: roundUpDate)
        } catch let error {
            useCaseError = error as? FetchRoundUpSummaryError
        }

        XCTAssertEqual(useCaseError, .accountNotFound)
    }

    func testExecuteWhenFetchingBalanceErrorsThrowsTransactionsError() async {
        let account = Self.createAccount(id: accountID)
        accountRepository.accountResult = .success(account)
        accountRepository.balanceResult = .failure(.unknown)

        var useCaseError: FetchRoundUpSummaryError?
        do {
            _ = try await useCase.execute(accountID: accountID, inTimeWindow: .week, withDate: roundUpDate)
        } catch let error {
            useCaseError = error as? FetchRoundUpSummaryError
        }

        XCTAssertEqual(useCaseError, .transactions)
    }

    func testExecuteWhenAccountBalanceNotFoundReturnsSummaryWithZeroAccountBalance() async throws {
        let account = Self.createAccount(id: accountID)
        accountRepository.accountResult = .success(account)
        accountRepository.balanceResult = .success([:])
        transactionRepository.transactionsResult = .success([:])
        savingsGoalRepository.savingsGoalsResult = .success([:])

        let summary = try await useCase.execute(accountID: account.id, inTimeWindow: .week, withDate: roundUpDate)
        let accountBalance = summary.accountBalance

        XCTAssertEqual(accountBalance, Money(minorUnits: 0, currency: account.currency))
    }

    func testExecuteReturnsSummaryWithAccountBalance() async throws {
        let account = Self.createAccount(id: accountID)
        let accountBalance = Money(minorUnits: 1000, currency: "GBP")
        accountRepository.accountResult = .success(account)
        accountRepository.balanceResult = .success([account.id: accountBalance])
        transactionRepository.transactionsResult = .success([:])
        savingsGoalRepository.savingsGoalsResult = .success([:])

        let summary = try await useCase.execute(accountID: account.id, inTimeWindow: .week, withDate: roundUpDate)

        XCTAssertEqual(summary.accountBalance, accountBalance)
    }

    func testExecuteFetchesTransactionsForAccountInDateRange() async throws {
        let account = Self.createAccount(id: accountID)
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
        let account = Self.createAccount(id: accountID)
        accountRepository.accountResult = .success(account)
        accountRepository.balanceResult = .success([:])
        transactionRepository.transactionsResult = .success([:])
        savingsGoalRepository.savingsGoalsResult = .success([:])

        let summary = try await useCase.execute(accountID: account.id, inTimeWindow: .week, withDate: roundUpDate)

        XCTAssertEqual(summary.accountID, account.id)
    }

    func testExecuteReturnsRoundUpSummaryWithDateRange() async throws {
        let account = Self.createAccount(id: accountID)
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
        let account = Self.createAccount(id: accountID)
        accountRepository.accountResult = .success(account)
        accountRepository.balanceResult = .success([:])
        transactionRepository.transactionsResult = .failure(.unknown)
        savingsGoalRepository.savingsGoalsResult = .success([:])

        var useCaseError: FetchRoundUpSummaryError?
        do {
            _ = try await useCase.execute(accountID: accountID, inTimeWindow: .week, withDate: roundUpDate)
        } catch let error {
            useCaseError = error as? FetchRoundUpSummaryError
        }

        XCTAssertEqual(useCaseError, .transactions)
    }

    func testExecuteWhenZeroTransactionsReturnsAccountSummaryWithZeroAmount() async throws {
        let account = Self.createAccount(id: accountID)
        let expectedRoundUpAmount = Money(minorUnits: 0, currency: account.currency)
        accountRepository.accountResult = .success(account)
        accountRepository.balanceResult = .success([:])
        transactionRepository.transactionsResult = .success([account.id: []])
        savingsGoalRepository.savingsGoalsResult = .success([:])

        let summary = try await useCase.execute(accountID: account.id, inTimeWindow: .week, withDate: roundUpDate)

        XCTAssertEqual(summary.amount, expectedRoundUpAmount)
    }

    func testExecuteWhenMultipleIncomingTransactionsReturnsAccountSummaryWithZeroAmount() async throws {
        let account = Self.createAccount(id: accountID)
        let transaction1ID = try XCTUnwrap(UUID(uuidString: "7830DC7B-2177-4BF1-A563-8A1765E904BA"))
        let transaction2ID = try XCTUnwrap(UUID(uuidString: "CF1B8321-B210-4509-B869-05112A8577AB"))
        let transaction3ID = try XCTUnwrap(UUID(uuidString: "312710BC-1070-41D8-96EA-96D6C616BAA8"))
        let transactions = [
            Self.createTransaction(id: transaction1ID, direction: .incoming),
            Self.createTransaction(id: transaction2ID, direction: .incoming),
            Self.createTransaction(id: transaction3ID, direction: .incoming)
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
        let account = Self.createAccount(id: accountID)
        let transactionID = try XCTUnwrap(UUID(uuidString: "7830DC7B-2177-4BF1-A563-8A1765E904BA"))
        let transactions = [
            Self.createTransaction(
                id: transactionID,
                amount: Money(minorUnits: 1000, currency: "GBP"),
                direction: .outgoing
            )
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
        let account = Self.createAccount(id: accountID)
        let transactionID = try XCTUnwrap(UUID(uuidString: "7830DC7B-2177-4BF1-A563-8A1765E904BA"))
        let transactions = [
            Self.createTransaction(
                id: transactionID,
                amount: Money(minorUnits: 87, currency: "GBP"),
                direction: .outgoing
            )
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
        let account = Self.createAccount(id: accountID)
        let transactionID = try XCTUnwrap(UUID(uuidString: "7830DC7B-2177-4BF1-A563-8A1765E904BA"))
        let transactions = [
            Self.createTransaction(
                id: transactionID,
                amount: Money(minorUnits: 1049, currency: "GBP"),
                direction: .outgoing
            )
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
        let account = Self.createAccount(id: accountID)
        let transaction1ID = try XCTUnwrap(UUID(uuidString: "7830DC7B-2177-4BF1-A563-8A1765E904BA"))
        let transaction2ID = try XCTUnwrap(UUID(uuidString: "CF1B8321-B210-4509-B869-05112A8577AB"))
        let transaction3ID = try XCTUnwrap(UUID(uuidString: "312710BC-1070-41D8-96EA-96D6C616BAA8"))
        let transactions = [
            Self.createTransaction(
                id: transaction1ID,
                amount: Money(minorUnits: 435, currency: "GBP"),
                direction: .outgoing
            ),
            Self.createTransaction(
                id: transaction2ID,
                amount: Money(minorUnits: 520, currency: "GBP"),
                direction: .outgoing
            ),
            Self.createTransaction(
                id: transaction3ID,
                amount: Money(minorUnits: 87, currency: "GBP"),
                direction: .outgoing
            )
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
        let account = Self.createAccount(id: accountID)
        let transaction1ID = try XCTUnwrap(UUID(uuidString: "7830DC7B-2177-4BF1-A563-8A1765E904BA"))
        let transaction2ID = try XCTUnwrap(UUID(uuidString: "CF1B8321-B210-4509-B869-05112A8577AB"))
        let transaction3ID = try XCTUnwrap(UUID(uuidString: "312710BC-1070-41D8-96EA-96D6C616BAA8"))
        let transaction4ID = try XCTUnwrap(UUID(uuidString: "F0440D5B-497E-47BA-ADBC-EB8B25E66A0F"))
        let transaction5ID = try XCTUnwrap(UUID(uuidString: "A3418E05-37F6-4156-AB28-FD42A2F3A0BB"))
        let transaction6ID = try XCTUnwrap(UUID(uuidString: "4F2D069E-EC8D-430C-9CE4-0F945494F0E9"))
        let transactions = [
            Self.createTransaction(
                id: transaction1ID,
                amount: Money(minorUnits: 435, currency: "GBP"),
                direction: .outgoing
            ),
            Self.createTransaction(
                id: transaction2ID,
                amount: Money(minorUnits: 123, currency: "GBP"),
                direction: .incoming
            ),
            Self.createTransaction(
                id: transaction3ID,
                amount: Money(minorUnits: 2353, currency: "GBP"),
                direction: .incoming
            ),
            Self.createTransaction(
                id: transaction4ID,
                amount: Money(minorUnits: 520, currency: "GBP"),
                direction: .outgoing
            ),
            Self.createTransaction(
                id: transaction5ID,
                amount: Money(minorUnits: 87, currency: "GBP"),
                direction: .outgoing
            ),
            Self.createTransaction(
                id: transaction6ID,
                amount: Money(minorUnits: 1011, currency: "GBP"),
                direction: .incoming
            )
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
        let account = Self.createAccount(id: accountID)
        let savingsGoal1ID = try XCTUnwrap(UUID(uuidString: "0524257F-DD30-4AB9-AB98-B29F8F8010C8"))
        let savingsGoal2ID = try XCTUnwrap(UUID(uuidString: "A18696A2-2436-468A-A791-432ECEDCC69B"))
        let savingsGoals = [Self.createSavingsGoal(id: savingsGoal1ID), Self.createSavingsGoal(id: savingsGoal2ID)]
        accountRepository.accountResult = .success(account)
        accountRepository.balanceResult = .success([:])
        transactionRepository.transactionsResult = .success([:])
        savingsGoalRepository.savingsGoalsResult = .success([account.id: savingsGoals])

        let summary = try await useCase.execute(accountID: account.id, inTimeWindow: .week, withDate: roundUpDate)

        XCTAssertEqual(summary.availableSavingsGoals, savingsGoals)
    }

    func testExecuteWhenSavingsGoalsErrorsThrowsSavingsGoalError() async throws {
        let account = Self.createAccount(id: accountID)
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
        id: Account.ID,
        name: String = "Test 1",
        type: AccountType = .primary,
        currency: String = "GBP"
    ) -> Account {
        Account(id: id, name: name, type: type, currency: currency)
    }

    private static func createTransaction(
        id: UUID,
        amount: Money = Money(minorUnits: 0, currency: "GBP"),
        direction: Transaction.Direction
    ) -> Transaction {
        Transaction(id: id, amount: amount, direction: direction)
    }

    private static func createSavingsGoal(
        id: UUID,
        name: String = "Test 1",
        target: Money = Money(minorUnits: 0, currency: "GBP"),
        totalSaved: Money = Money(minorUnits: 0, currency: "GBP"),
        savedPercentage: Int = 0,
        state: SavingsGoal.State = .active
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
