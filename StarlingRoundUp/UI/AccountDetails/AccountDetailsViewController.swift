//
//  AccountDetailsViewController.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import UIKit

protocol AccountDetailsView: AnyObject {

    var delegate: (any AccountDetailsViewControllerDelegate)? { get set }

}

protocol AccountDetailsViewControlling: AccountDetailsView, UIViewController {}

final class AccountDetailsViewController: UITableViewController, AccountDetailsViewControlling {

    weak var delegate: (any AccountDetailsViewControllerDelegate)?

    private let viewModel: any AccountDetailsViewModeling

    private lazy var tableBackgroundLoadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        return view
    }()

    private lazy var accountSummaryView = AccountDetailsSummaryView()

    init(viewModel: some AccountDetailsViewModeling) {
        self.viewModel = viewModel
        super.init(style: .insetGrouped)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.accountSummary?.name

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "savingsGoalCellIdentifier")

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

        accountSummaryView.configure(with: viewModel.accountSummary)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshData()
    }

}

extension AccountDetailsViewController {

    override func numberOfSections(in _: UITableView) -> Int {
        1
    }

    override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            1

        default:
            0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savingsGoalCellIdentifier", for: indexPath)

        var content = cell.defaultContentConfiguration()
        content.text = NSLocalizedString("SAVINGS_GOALS", comment: "Savings Goals")
        content.image = UIImage(systemName: ImageName.savingsGoal)
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    override func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else {
            return nil
        }

        let tableHeaderView = UIView()
        tableHeaderView.translatesAutoresizingMaskIntoConstraints = false
        tableHeaderView.addSubview(accountSummaryView)
        accountSummaryView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            accountSummaryView.topAnchor.constraint(equalTo: tableHeaderView.layoutMarginsGuide.topAnchor),
            accountSummaryView.leadingAnchor.constraint(equalTo: tableHeaderView.layoutMarginsGuide.leadingAnchor),
            accountSummaryView.trailingAnchor.constraint(equalTo: tableHeaderView.layoutMarginsGuide.trailingAnchor),
            accountSummaryView.bottomAnchor.constraint(equalTo: tableHeaderView.layoutMarginsGuide.bottomAnchor)
        ])

        return tableHeaderView
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            delegate?.viewController(self, didSelectSavingsGoalsForAccount: viewModel.accountID)

        default:
            break
        }
    }

}

extension AccountDetailsViewController {

    @objc
    private func refreshData() {
        if viewModel.accountSummary == nil {
            tableBackgroundLoadingIndicator.startAnimating()
        }

        Task {
            do {
                try await viewModel.fetchAccountSummary()
                accountSummaryView.configure(with: viewModel.accountSummary)
                tableView.reloadData()
            } catch let error {
                tableView.reloadData()
                handleError(error)
            }

            tableBackgroundLoadingIndicator.stopAnimating()
            refreshControl?.endRefreshing()
        }
    }

    private func handleError(_: Error) {
        let alertViewController = UIAlertController(
            title: NSLocalizedString("CANNOT_LOAD_ACCOUNT_DETAILS", comment: "Cannot Load Account Details"),
            message: NSLocalizedString(
                "THERE_WAS_AN_ERROR_LOADING_YOUR_ACCOUNT_DETAILS",
                comment: "There was an error loading your account details."
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
