//
//  SavingsGoalListViewController.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import UIKit

protocol SavingsGoalListView: AnyObject {}

protocol SavingsGoalListViewControlling: SavingsGoalListView, UIViewController {}

final class SavingsGoalListViewController: UITableViewController, SavingsGoalListViewControlling {

    private let viewModel: any SavingsGoalsListViewModeling
    private lazy var dataSource = makeDataSource()

    private lazy var tableBackgroundLoadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        return view
    }()

    private lazy var emptySavingsGoalsView = EmptySavingsGoalView()

    init(viewModel: some SavingsGoalsListViewModeling) {
        self.viewModel = viewModel
        super.init(style: .insetGrouped)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("SAVINGS_GOALS", comment: "Savings Goals")

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "savingsGoalCellIdentifier")
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

        tableBackgroundView.addSubview(emptySavingsGoalsView)
        emptySavingsGoalsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptySavingsGoalsView.centerXAnchor.constraint(equalTo: tableBackgroundView.centerXAnchor),
            emptySavingsGoalsView.centerYAnchor.constraint(equalTo: tableBackgroundView.centerYAnchor)
        ])
        emptySavingsGoalsView.isHidden = true

        tableView.backgroundView = tableBackgroundView
        tableBackgroundLoadingIndicator.startAnimating()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshData()
    }

}

extension SavingsGoalListViewController {

    @objc
    private func refreshData() {
        Task {
            do {
                let shouldAnimateUpdate = !viewModel.savingsGoals.isEmpty
                try await viewModel.fetchSavingsGoals()
                update(with: viewModel.savingsGoals, animate: shouldAnimateUpdate)
            } catch let error {
                handleError(error)
            }

            tableBackgroundLoadingIndicator.stopAnimating()
            refreshControl?.endRefreshing()
        }
    }

    private func handleError(_: Error) {
        let alertViewController = UIAlertController(
            title: NSLocalizedString("CANNOT_LOAD_SAVINGS_GOALS", comment: "Cannot Load Savings Goals"),
            message: NSLocalizedString(
                "THERE_WAS_AN_ERROR_LOADING_YOUR_SAVINGS_GOALS",
                comment: "There was an error loading your savings goals."
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

extension SavingsGoalListViewController {

    private func makeDataSource() -> UITableViewDiffableDataSource<Int, SavingsGoal> {
        UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { [weak self] tableView, indexPath, accountSummary in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "savingsGoalCellIdentifier",
                    for: indexPath
                )

                self?.configureCell(cell, with: accountSummary)

                return cell
            }
        )
    }

    private func configureCell(_ cell: UITableViewCell, with savingsGoal: SavingsGoal) {
        var content = cell.defaultContentConfiguration()

        content.text = savingsGoal.name
        content.textProperties.font = .preferredFont(forTextStyle: .headline)

        content.secondaryText = savingsGoal.totalSaved.formatted() + "/" + savingsGoal.target.formatted()
        content.secondaryTextProperties.font = .preferredFont(forTextStyle: .body)
        content.secondaryTextProperties.color = .secondaryLabel

        content.image = UIImage(systemName: ImageName.savingsGoal)

        cell.contentConfiguration = content
        cell.selectionStyle = .none
    }

    private func update(with savingsGoals: [SavingsGoal], animate: Bool = true) {
        emptySavingsGoalsView.isHidden = !savingsGoals.isEmpty

        var snapshot = NSDiffableDataSourceSnapshot<Int, SavingsGoal>()
        snapshot.appendSections([0])
        snapshot.appendItems(savingsGoals, toSection: 0)

        dataSource.apply(snapshot, animatingDifferences: animate)
    }

}
