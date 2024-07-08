//
//  AccountDetailsViewController.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import UIKit

protocol AccountDetailsView: AnyObject {

    var delegate: (any AccountDetailsViewControllerDelegate)? { get set }

    func refreshData()

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

    private lazy var accountSummaryView: AccountDetailsSummaryView = {
        let view = AccountDetailsSummaryView()
        view.delegate = self
        return view
    }()

    private enum CellIdentifier {
        static let savingsGoals = "savingsGoalsCellIdentifier"
    }

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

        tableView.accessibilityIdentifier = "account-table"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.savingsGoals)

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
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.savingsGoals, for: indexPath)

        var content = cell.defaultContentConfiguration()
        content.text = String(localized: "SAVINGS_GOALS", comment: "Savings Goals")
        content.image = UIImage(systemName: ImageName.savingsGoal)
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        cell.accessibilityIdentifier = "savings-goal-cell"

        return cell
    }

    override func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            accountSummaryView

        default:
            nil
        }
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
    func refreshData() {
        if viewModel.accountSummary == nil {
            tableBackgroundLoadingIndicator.startAnimating()
        }

        Task { [weak self] in
            guard let self else {
                return
            }

            do {
                try await viewModel.fetchAccountSummary()
                accountSummaryView.configure(with: viewModel.accountSummary)
                tableView.reloadData()
            } catch let error {
                self.tableView.reloadData()
                self.handleError(error)
            }

            tableBackgroundLoadingIndicator.stopAnimating()
            refreshControl?.endRefreshing()
        }
    }

    private func handleError(_ error: Error) {
        let alertViewController = UIAlertController(
            title: String(localized: "CANNOT_LOAD_ACCOUNT_DETAILS", comment: "Cannot Load Account Details"),
            error: error
        )
        alertViewController.view.tintColor = view.tintColor

        present(alertViewController, animated: true)
    }

}

extension AccountDetailsViewController: AccountDetailsSummaryViewDelegate {

    func viewWantsToShowRoundUp(_: AccountDetailsSummaryView) {
        delegate?.viewController(self, wantsToRoundUpForAccount: viewModel.accountID)
    }

}
