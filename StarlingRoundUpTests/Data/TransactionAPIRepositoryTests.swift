//
//  TransactionAPIRepositoryTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 04/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class TransactionAPIRepositoryTests: XCTestCase {

    var repository: TransactionAPIRepository!
    var apiClient: APIStubClient!

    override func setUp() {
        super.setUp()
        apiClient = APIStubClient()
        repository = TransactionAPIRepository(apiClient: apiClient)
    }

    override func tearDown() {
        repository = nil
        apiClient = nil
        super.tearDown()
    }

    func testSettledTransactionsMakesCorrectAPIRequest() async throws {
        let accountID = "1"
        let fromDate = Date(timeIntervalSince1970: 100_000)
        let toDate = Date(timeIntervalSince1970: 200_000)
        let dateRange = fromDate ..< toDate
        let expectedAPIRequest = SettledTransactionsRequest(accountID: accountID, dateRange: dateRange)

        _ = try? await repository.settledTransactions(forAccount: accountID, in: dateRange)

        XCTAssertEqual(apiClient.lastRequest as? SettledTransactionsRequest, expectedAPIRequest)
    }

    func testSettledTransactionsReturnsTransactions() async throws {
        let accountID = "1"
        let fromDate = Date(timeIntervalSince1970: 100_000)
        let toDate = Date(timeIntervalSince1970: 200_000)
        let dateRange = fromDate ..< toDate
        let transactionDataModels = [
            Self.createTransactionDataModel(feedItemUid: "1"),
            Self.createTransactionDataModel(feedItemUid: "2"),
            Self.createTransactionDataModel(feedItemUid: "3")
        ]
        let responseDataModel = TransactionsResponseDataModel(feedItems: transactionDataModels)
        apiClient.responseResult = .success(responseDataModel)

        let transactions = try await repository.settledTransactions(forAccount: accountID, in: dateRange)

        XCTAssertEqual(transactions.count, 3)
        XCTAssertEqual(transactions[0].id, "1")
        XCTAssertEqual(transactions[1].id, "2")
        XCTAssertEqual(transactions[2].id, "3")
    }

    func testSettledTransactionsWhenAPIClientRequestErrorsThrowsError() async throws {
        let accountID = "1"
        let fromDate = Date(timeIntervalSince1970: 100_000)
        let toDate = Date(timeIntervalSince1970: 200_000)
        let dateRange = fromDate ..< toDate
        apiClient.responseResult = .failure(.unknown)

        var apiClientError: APIClientError?
        do {
            _ = try await repository.settledTransactions(forAccount: accountID, in: dateRange)
        } catch let error {
            apiClientError = error as? APIClientError
        }

        XCTAssertNotNil(apiClientError)
    }

}

extension TransactionAPIRepositoryTests {

    private static func createTransactionDataModel(
        feedItemUid: String = "1",
        categoryUid: String = "a",
        amount: MoneyDataModel = MoneyDataModel(minorUnits: 0, currency: "GBP"),
        direction: TransactionDirectionDataModel = .in,
        transactionTime: Date = Date(timeIntervalSince1970: 0),
        settlementTime: Date = Date(timeIntervalSince1970: 0),
        updatedAt: Date = Date(timeIntervalSince1970: 0)
    ) -> TransactionDataModel {
        TransactionDataModel(
            feedItemUid: feedItemUid,
            categoryUid: categoryUid,
            amount: amount,
            direction: direction,
            transactionTime: transactionTime,
            settlementTime: settlementTime,
            updatedAt: updatedAt
        )
    }

}
