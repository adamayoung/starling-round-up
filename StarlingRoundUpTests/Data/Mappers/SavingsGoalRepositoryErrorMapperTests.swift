//
//  SavingsGoalRepositoryErrorMapperTests.swift
//  StarlingRoundUpTests
//
//  Created by Adam Young on 08/07/2024.
//

@testable import StarlingRoundUp
import XCTest

final class SavingsGoalRepositoryErrorMapperTests: XCTestCase {

    func testMapSavingsGoalsErrorToUnauthorized() {
        let error = SavingsGoalRepositoryErrorMapper.mapSavingsGoalsError(APIClientError.unauthorized)

        XCTAssertEqual(error, .unauthorized)
    }

    func testMapSavingsGoalsErrorToForbidden() {
        let error = SavingsGoalRepositoryErrorMapper.mapSavingsGoalsError(APIClientError.forbidden)

        XCTAssertEqual(error, .forbidden)
    }

    func testMapSavingsGoalsErrorToUnknown() {
        let error = SavingsGoalRepositoryErrorMapper.mapSavingsGoalsError(APIClientError.badURL)

        XCTAssertEqual(error, .unknown)
    }

    func testMapCreateErrorToUnauthorized() {
        let error = SavingsGoalRepositoryErrorMapper.mapCreateError(APIClientError.unauthorized)

        XCTAssertEqual(error, .unauthorized)
    }

    func testMapCreateErrorToForbidden() {
        let error = SavingsGoalRepositoryErrorMapper.mapCreateError(APIClientError.forbidden)

        XCTAssertEqual(error, .forbidden)
    }

    func testMapCreateErrorToUnknown() {
        let error = SavingsGoalRepositoryErrorMapper.mapCreateError(APIClientError.badURL)

        XCTAssertEqual(error, .unknown)
    }

    func testMapTransferErrorToUnauthorized() {
        let error = SavingsGoalRepositoryErrorMapper.mapTransferError(APIClientError.unauthorized)

        XCTAssertEqual(error, .unauthorized)
    }

    func testMapTransferErrorToForbidden() {
        let error = SavingsGoalRepositoryErrorMapper.mapTransferError(APIClientError.forbidden)

        XCTAssertEqual(error, .forbidden)
    }

    func testMapTransferBadRequestNoneErrorToUnknown() {
        let errorResponse = ErrorResponseDataModel<TransferToSavingsErrorDetailDataModel>(
            errors: [],
            success: false
        )

        let error = SavingsGoalRepositoryErrorMapper.mapTransferError(APIClientError.badRequest(errorResponse))

        XCTAssertEqual(error, .unknown)
    }

    func testMapTransferBadRequestErrorToUnknown() {
        let errorResponse = ErrorResponseDataModel<TransferToSavingsErrorDetailDataModel>(
            errors: [TransferToSavingsErrorDetailDataModel(message: .unknown)],
            success: false
        )

        let error = SavingsGoalRepositoryErrorMapper.mapTransferError(APIClientError.badRequest(errorResponse))

        XCTAssertEqual(error, .unknown)
    }

    func testMapTransferBadRequestErrorToAmountMustBePositive() {
        let errorResponse = ErrorResponseDataModel<TransferToSavingsErrorDetailDataModel>(
            errors: [TransferToSavingsErrorDetailDataModel(message: .amountMustBePositive)],
            success: false
        )

        let error = SavingsGoalRepositoryErrorMapper.mapTransferError(APIClientError.badRequest(errorResponse))

        XCTAssertEqual(error, .amountMustBePositive)
    }

    func testMapTransferBadRequestErrorToInsufficientFunds() {
        let errorResponse = ErrorResponseDataModel<TransferToSavingsErrorDetailDataModel>(
            errors: [TransferToSavingsErrorDetailDataModel(message: .insufficientFunds)],
            success: false
        )

        let error = SavingsGoalRepositoryErrorMapper.mapTransferError(APIClientError.badRequest(errorResponse))

        XCTAssertEqual(error, .insufficientFunds)
    }

    func testMapTransferErrorToUnknown() {
        let error = SavingsGoalRepositoryErrorMapper.mapTransferError(APIClientError.badURL)

        XCTAssertEqual(error, .unknown)
    }

}
