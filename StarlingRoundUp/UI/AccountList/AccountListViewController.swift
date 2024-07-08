//
//  AccountListViewController.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import UIKit

protocol AccountListView: AnyObject {

    var delegate: (any AccountListViewControllerDelegate)? { get set }

}

protocol AccountListViewControlling: AccountListView, UIViewController {}

final class AccountListViewController: UITableViewController, AccountListViewControlling {

    weak var delegate: (any AccountListViewControllerDelegate)?

    private let viewModel: any AccountListViewModeling
    private lazy var dataSource = makeDataSource()

    private lazy var tableBackgroundLoadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        return view
    }()

    private enum CellIdentifier {
        static let account = "accountCellIdentifier"
    }

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
        title = String(localized: "ACCOUNTS", comment: "Accounts")

        tableView.accessibilityIdentifier = "accounts-table"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.account)
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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshData()
    }

}

extension AccountListViewController {

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let accountSummary = viewModel.accountSummaries[indexPath.section]
        delegate?.viewController(self, didSelectAccount: accountSummary)
    }

}

extension AccountListViewController {

    @objc
    private func refreshData() {
        Task { [weak self] in
            guard let self else {
                return
            }

            do {
                let shouldAnimateUpdate = !viewModel.accountSummaries.isEmpty
                try await viewModel.fetchAccountSummaries()
                update(with: viewModel.accountSummaries, animate: shouldAnimateUpdate)
            } catch let error {
                self.handleError(error)
            }

            tableBackgroundLoadingIndicator.stopAnimating()
            refreshControl?.endRefreshing()
        }
    }

    private func handleError(_ error: Error) {
        let alertViewController = UIAlertController(
            title: String(localized: "CANNOT_LOAD_ACCOUNTS", comment: "Cannot Load Accounts"),
            error: error
        )
        alertViewController.view.tintColor = view.tintColor

        present(alertViewController, animated: true)
    }

}

extension AccountListViewController {

    private func makeDataSource() -> UITableViewDiffableDataSource<Int, AccountSummary> {
        UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { [weak self] tableView, indexPath, accountSummary in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: CellIdentifier.account,
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

        content.secondaryText = accountSummary.balance.formatted()
        content.secondaryTextProperties.font = .preferredFont(forTextStyle: .body)
        content.secondaryTextProperties.color = .secondaryLabel

        content.image = UIImage(systemName: ImageName.account)

        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        cell.accessibilityIdentifier = "account-cell-\(accountSummary.id)"
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
