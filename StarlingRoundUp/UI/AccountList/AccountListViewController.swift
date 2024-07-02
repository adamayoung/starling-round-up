//
//  AccountListViewController.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import UIKit

protocol AccountListView: AnyObject {}

protocol AccountListViewControlling: AccountListView, UIViewController {}

final class AccountListViewController: UITableViewController, AccountListViewControlling {

    private let viewModel: any AccountListViewModeling
    private lazy var dataSource = makeDataSource()

    private lazy var tableBackgroundLoadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        return view
    }()

    init(viewModel: some AccountListViewModeling) {
        self.viewModel = viewModel
        super.init(style: .insetGrouped)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("ACCOUNTS", comment: "Accounts")

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = dataSource

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl

        let tableBackgroundView = UIView()
        tableBackgroundView.addSubview(tableBackgroundLoadingIndicator)
        tableBackgroundLoadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableBackgroundLoadingIndicator.centerXAnchor.constraint(equalTo: tableBackgroundView.centerXAnchor),
            tableBackgroundLoadingIndicator.centerYAnchor.constraint(equalTo: tableBackgroundView.centerYAnchor)
        ])

        tableView.backgroundView = tableBackgroundView
        tableBackgroundLoadingIndicator.startAnimating()

        refreshData()
    }

}

extension AccountListViewController {

    @objc
    private func refreshData() {
        Task {
            do {
                let shouldAnimateUpdate = !viewModel.accountSummaries.isEmpty
                try await viewModel.fetchAccountSummaries()
                update(with: viewModel.accountSummaries, animate: shouldAnimateUpdate)
            } catch let error {
                handleError(error)
            }

            tableBackgroundLoadingIndicator.stopAnimating()
            refreshControl?.endRefreshing()
        }
    }

    private func handleError(_: Error) {
        let alertViewController = UIAlertController(
            title: NSLocalizedString("CANNOT_GET_ACCOUNTS", comment: "Cannot Load Accounts"),
            message: NSLocalizedString(
                "THERE_WAS_AN_ERROR_LOADING_YOUR_ACCOUNTS",
                comment: "There was an error loading your accounts."
            ),
            preferredStyle: .alert
        )
        alertViewController.view.tintColor = view.tintColor

        let dismissAction = UIAlertAction(
            title: NSLocalizedString("OK", comment: "OK"),
            style: .default
        )
        alertViewController.addAction(dismissAction)

        present(alertViewController, animated: true)
    }

}

extension AccountListViewController {

    private func makeDataSource() -> UITableViewDiffableDataSource<Int, AccountSummary> {
        UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { [weak self] tableView, indexPath, accountSummary in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "cell",
                    for: indexPath
                )

                self?.configureCell(cell, with: accountSummary)

                return cell
            }
        )
    }

    private func configureCell(_ cell: UITableViewCell, with accountSummary: AccountSummary) {
        var content = cell.defaultContentConfiguration()

        content.text = accountSummary.name
        content.textProperties.font = .preferredFont(forTextStyle: .headline)

        content.secondaryText = accountSummary.balance.formattedValue
        content.secondaryTextProperties.font = .preferredFont(forTextStyle: .body)
        content.secondaryTextProperties.color = .secondaryLabel

        content.image = UIImage(systemName: "creditcard.fill")

        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
    }

    private func update(with accountSummaries: [AccountSummary], animate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, AccountSummary>()
        for (index, accountSummary) in accountSummaries.enumerated() {
            snapshot.appendSections([index])
            snapshot.appendItems([accountSummary], toSection: index)
        }

        dataSource.apply(snapshot, animatingDifferences: animate)
    }

}
