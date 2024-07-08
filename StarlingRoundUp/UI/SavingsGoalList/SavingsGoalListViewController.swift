//
//  SavingsGoalListViewController.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import UIKit

protocol SavingsGoalListView: AnyObject {

    var delegate: (any SavingsGoalListViewControllerDelegate)? { get set }

    func refreshData()

}

protocol SavingsGoalListViewControlling: SavingsGoalListView, UIViewController {}

final class SavingsGoalListViewController: UITableViewController, SavingsGoalListViewControlling {

    weak var delegate: (any SavingsGoalListViewControllerDelegate)?

    private let viewModel: any SavingsGoalsListViewModeling
    private lazy var dataSource = makeDataSource()

    private lazy var tableBackgroundLoadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        return view
    }()

    private lazy var addSavingsGoalButton: UIBarButtonItem = {
        let action = UIAction { [weak self] _ in
            self?.addSavingsGoal()
        }

        return UIBarButtonItem(systemItem: .add, primaryAction: action)
    }()

    private lazy var savingsGoalsUnavailableView: SavingsGoalsUnavailableView = {
        let view = SavingsGoalsUnavailableView()
        view.onAction = { [weak self] in
            self?.addSavingsGoal()
        }
        return view
    }()

    private enum CellIdentifier {
        static let savingsGoal = "savingsGoalCellIdentifier"
    }

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
        title = String(localized: "SAVINGS_GOALS", comment: "Savings Goals")
        navigationItem.rightBarButtonItem = addSavingsGoalButton

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.savingsGoal)
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

        tableBackgroundView.addSubview(savingsGoalsUnavailableView)
        savingsGoalsUnavailableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            savingsGoalsUnavailableView.centerXAnchor.constraint(equalTo: tableBackgroundView.centerXAnchor),
            savingsGoalsUnavailableView.centerYAnchor.constraint(equalTo: tableBackgroundView.centerYAnchor)
        ])
        savingsGoalsUnavailableView.isHidden = true

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
    func refreshData() {
        Task { [weak self] in
            guard let self else {
                return
            }

            do {
                let shouldAnimateUpdate = !viewModel.savingsGoals.isEmpty
                try await viewModel.fetchSavingsGoals()
                update(with: viewModel.savingsGoals, animate: shouldAnimateUpdate)
            } catch let error {
                self.handleError(error)
            }

            tableBackgroundLoadingIndicator.stopAnimating()
            refreshControl?.endRefreshing()
        }
    }

    private func handleError(_ error: Error) {
        let alertViewController = UIAlertController(
            title: String(localized: "CANNOT_LOAD_SAVINGS_GOALS", comment: "Cannot Load Savings Goals"),
            error: error
        )
        alertViewController.view.tintColor = view.tintColor

        present(alertViewController, animated: true)
    }

}

extension SavingsGoalListViewController {

    private func addSavingsGoal(_: AnyObject? = nil) {
        delegate?.viewController(self, wantsToCreateSavingsGoalForAccount: viewModel.accountID)
    }

}

extension SavingsGoalListViewController {

    private func makeDataSource() -> UITableViewDiffableDataSource<Int, SavingsGoal> {
        UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { [weak self] tableView, indexPath, accountSummary in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: CellIdentifier.savingsGoal,
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
        savingsGoalsUnavailableView.isHidden = !savingsGoals.isEmpty

        var snapshot = NSDiffableDataSourceSnapshot<Int, SavingsGoal>()
        snapshot.appendSections([0])
        snapshot.appendItems(savingsGoals, toSection: 0)

        dataSource.apply(snapshot, animatingDifferences: animate)
    }

}
