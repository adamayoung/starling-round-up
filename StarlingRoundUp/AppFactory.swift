//
//  AppFactory.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import Foundation

final class AppFactory {

    init() {}

}

extension AppFactory {

    func mainNavigationController() -> some MainNavigationControlling {
        MainNavigationController()
    }

}

extension AppFactory {

    func accountListViewController() -> some AccountListViewControlling {
        let viewModel = accountListViewModel()
        return AccountListViewController(viewModel: viewModel)
    }

    private func accountListViewModel() -> some AccountListViewModeling {
        let useCase = fetchAccountSummariesUseCase()
        return AccountListViewModel(fetchAccountSummariesUseCase: useCase)
    }

}

extension AppFactory {

    func accountDetailsViewController(accountID: Account.ID) -> some AccountDetailsViewControlling {
        let viewModel = accountDetailsViewModel(accountID: accountID)
        return AccountDetailsViewController(viewModel: viewModel)
    }

    func accountDetailsViewController(accountSummary: AccountSummary) -> some AccountDetailsViewControlling {
        let viewModel = accountDetailsViewModel(accountSummary: accountSummary)
        return AccountDetailsViewController(viewModel: viewModel)
    }

    private func accountDetailsViewModel(accountID: Account.ID) -> some AccountDetailsViewModeling {
        let useCase = fetchAccountSummaryUseCase()
        return AccountDetailsViewModel(accountID: accountID, fetchAccountSummaryUseCase: useCase)
    }

    private func accountDetailsViewModel(accountSummary: AccountSummary) -> some AccountDetailsViewModeling {
        let useCase = fetchAccountSummaryUseCase()
        return AccountDetailsViewModel(accountSummary: accountSummary, fetchAccountSummaryUseCase: useCase)
    }

}

extension AppFactory {

    func savingsGoalListViewController(accountID: Account.ID) -> some SavingsGoalListViewControlling {
        let viewModel = savingsGoalListViewModel(accountID: accountID)
        return SavingsGoalListViewController(viewModel: viewModel)
    }

    private func savingsGoalListViewModel(accountID: Account.ID) -> some SavingsGoalsListViewModeling {
        let useCase = fetchSavingsGoalsUseCase()
        return SavingsGoalsListViewModel(accountID: accountID, fetchSavingsGoalsUseCase: useCase)
    }

}

extension AppFactory {

    func addSavingsGoalViewController(accountID: Account.ID) -> some AddSavingsGoalViewControlling {
        let viewModel = addSavingsGoalViewModel(accountID: accountID)
        return AddSavingsGoalViewController(viewModel: viewModel)
    }

    private func addSavingsGoalViewModel(accountID: Account.ID) -> some AddSavingsGoalViewModeling {
        let useCase = createSavingsGoalUseCase()
        return AddSavingsGoalViewModel(accountID: accountID, createSavingsGoalUseCase: useCase)
    }

}

extension AppFactory {

    func roundUpViewController(accountID: Account.ID) -> some RoundUpViewControlling {
        let viewModel = roundUpViewModel(accountID: accountID)
        return RoundUpViewController(viewModel: viewModel)
    }

    private func roundUpViewModel(accountID: Account.ID) -> some RoundUpViewModeling {
        let fetchRoundUpSummaryUseCase = fetchRoundUpSummaryUseCase()
        let transferToSavingsGoalUseCase = transferToSavingsGoalUseCase()
        return RoundUpViewModel(
            accountID: accountID,
            fetchRoundUpSummaryUseCase: fetchRoundUpSummaryUseCase,
            transferToSavingsGoalUseCase: transferToSavingsGoalUseCase
        )
    }

}

extension AppFactory {

    private func fetchAccountSummariesUseCase() -> some FetchAccountSummariesUseCase {
        let accountRepository = accountRepository()
        return FetchAccountSummaries(accountRepository: accountRepository)
    }

    private func fetchAccountSummaryUseCase() -> some FetchAccountSummaryUseCase {
        let accountRepository = accountRepository()
        return FetchAccountSummary(accountRepository: accountRepository)
    }

    private func fetchSavingsGoalsUseCase() -> some FetchSavingsGoalsUseCase {
        let savingsGoalRepository = savingsGoalRepository()
        return FetchSavingsGoals(savingsGoalRepository: savingsGoalRepository)
    }

    private func createSavingsGoalUseCase() -> some CreateSavingsGoalUseCase {
        let savingsGoalRepository = savingsGoalRepository()
        return CreateSavingsGoal(savingsGoalRepository: savingsGoalRepository)
    }

    private func fetchRoundUpSummaryUseCase() -> some FetchRoundUpSummaryUseCase {
        let accountRepository = accountRepository()
        let transactionRepository = transactionRepository()
        let savingsGoalRepository = savingsGoalRepository()
        return FetchRoundUpSummary(
            accountRepository: accountRepository,
            transactionRepository: transactionRepository,
            savingsGoalRepository: savingsGoalRepository
        )
    }

    private func transferToSavingsGoalUseCase() -> some TransferToSavingsGoalUseCase {
        let savingsGoalRepository = savingsGoalRepository()
        return TransferToSavingsGoal(savingsGoalRepository: savingsGoalRepository)
    }

}

extension AppFactory {

    private func accountRepository() -> some AccountRepository {
        let apiClient = apiClient()
        return AccountAPIRepository(apiClient: apiClient)
    }

    private func savingsGoalRepository() -> some SavingsGoalRepository {
        let apiClient = apiClient()
        return SavingsGoalAPIRepository(apiClient: apiClient)
    }

    private func transactionRepository() -> some TransactionRepository {
        let apiClient = apiClient()
        return TransactionAPIRepository(apiClient: apiClient)
    }

}

extension AppFactory {

    private func apiClient() -> some APIClient {
        let urlSession = Self.urlSession
        let authorizationProvider = authorizationProvider()

        return APIHTTPClient(
            baseURL: Environment.baseURL,
            urlSession: urlSession,
            authorizationProvider: authorizationProvider
        )
    }

    private func authorizationProvider() -> some AuthorizationProviding {
        AuthorizationMockProvider(accessToken: Environment.accessToken)
    }

    private static let urlSession: URLSession = {
        let configuration = urlSessionConfiguration()
        return URLSession(configuration: configuration)
    }()

    private static func urlSessionConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        configuration.timeoutIntervalForRequest = 30
        configuration.waitsForConnectivity = true
        return configuration
    }

}
