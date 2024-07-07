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
    var accountID: UUID!

    override func setUpWithError() throws {
        super.setUp()
        apiClient = APIStubClient()
        repository = TransactionAPIRepository(apiClient: apiClient)
        accountID = try XCTUnwrap(UUID(uuidString: "706B0769-ABAD-42BF-8045-70DAAAB5ACB9"))
    }

    override func tearDown() {
        accountID = nil
        repository = nil
        apiClient = nil
        super.tearDown()
    }

    func testSettledTransactionsMakesCorrectAPIRequest() async throws {
        let fromDate = Date(timeIntervalSince1970: 100_000)
        let toDate = Date(timeIntervalSince1970: 200_000)
        let dateRange = fromDate ..< toDate
        let expectedAPIRequest = SettledTransactionsRequest(accountID: accountID, dateRange: dateRange)

        _ = try? await repository.settledTransactions(forAccount: accountID, in: dateRange)

        XCTAssertEqual(apiClient.lastRequest as? SettledTransactionsRequest, expectedAPIRequest)
    }

    func testSettledTransactionsReturnsTransactions() async throws {
        let transaction1ID = try XCTUnwrap(UUID(uuidString: "DDFE6E41-7B74-435B-969D-40C2CE39FF61"))
        let transaction2ID = try XCTUnwrap(UUID(uuidString: "847BCE1B-EFDD-4972-914D-9C7DD2A49341"))
        let transaction3ID = try XCTUnwrap(UUID(uuidString: "ABCF0099-2E82-45C3-9CC6-67F32D26FAB8"))
        let fromDate = Date(timeIntervalSince1970: 100_000)
        let toDate = Date(timeIntervalSince1970: 200_000)
        let dateRange = fromDate ..< toDate
        let transactionDataModels = [
            Self.createTransactionDataModel(feedItemUid: transaction1ID),
            Self.createTransactionDataModel(feedItemUid: transaction2ID),
            Self.createTransactionDataModel(feedItemUid: transaction3ID)
        ]
        let responseDataModel = TransactionsResponseDataModel(feedItems: transactionDataModels)
        apiClient.responseResult = .success(responseDataModel)

        let transactions = try await repository.settledTransactions(forAccount: accountID, in: dateRange)

        XCTAssertEqual(transactions.count, 3)
        XCTAssertEqual(transactions.map(\.id), [transaction1ID, transaction2ID, transaction3ID])
    }

    func testSettledTransactionsWhenAPIClientRequestErrorsThrowsError() async throws {
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
        feedItemUid: UUID,
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
