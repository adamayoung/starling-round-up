//
//  AddSavingsGoalViewController.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import UIKit

protocol AddSavingsGoalView: AnyObject {

    var delegate: (any AddSavingsGoalViewControllerDelegate)? { get set }

}

protocol AddSavingsGoalViewControlling: AddSavingsGoalView, UIViewController {}

final class AddSavingsGoalViewController: UITableViewController, AddSavingsGoalViewControlling {

    weak var delegate: (any AddSavingsGoalViewControllerDelegate)?

    private let viewModel: any AddSavingsGoalViewModeling

    private lazy var addButton: UIBarButtonItem = {
        let action = UIAction { [weak self] _ in
            self?.save()
        }

        let button = UIBarButtonItem(title: String(localized: "ADD", comment: "Add"), primaryAction: action)
        button.accessibilityIdentifier = "add-savings-goal-add-button"
        return button
    }()

    private lazy var cancelButton: UIBarButtonItem = {
        let action = UIAction { [weak self] _ in
            self?.dismiss()
        }

        let button = UIBarButtonItem(systemItem: .cancel, primaryAction: action)
        button.accessibilityIdentifier = "add-savings-goal-cancel-button"
        return button
    }()

    private enum CellIdentifier {
        static let name = "nameCellIdentifer"
        static let target = "targetCellIdentifer"
    }

    init(viewModel: some AddSavingsGoalViewModeling) {
        self.viewModel = viewModel
        super.init(style: .insetGrouped)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = String(localized: "ADD_SAVINGS_GOAL", comment: "Add Savings Goal")

        updateSaveButtonState()
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = addButton

        tableView.accessibilityIdentifier = "add-savings-goal-table"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.name)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.target)

        viewModel.onFormValidChanged = { [weak self] _ in
            self?.updateSaveButtonState()
        }
    }

}

extension AddSavingsGoalViewController {

    private func updateSaveButtonState() {
        addButton.isEnabled = viewModel.isFormValid
    }

    private func save(_: AnyObject? = nil) {
        Task { [weak self] in
            guard let self else {
                return
            }

            do {
                try await viewModel.save()
            } catch let error {
                self.handleError(error)
                return
            }

            delegate?.viewControllerDidCreateSavingsGoal(self)
        }
    }

    private func handleError(_ error: Error) {
        let alertViewController = UIAlertController(
            title: String(localized: "CANNOT_ADD_SAVINGS_GOAL", comment: "Cannot Add Savings Goal"),
            error: error
        )
        alertViewController.view.tintColor = view.tintColor

        present(alertViewController, animated: true)
    }

    private func dismiss() {
        delegate?.viewControllerDidCancelCreatingsSavingsGoal(self)
    }

}

extension AddSavingsGoalViewController {

    override func numberOfSections(in _: UITableView) -> Int {
        1
    }

    override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            2

        default:
            0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.name, for: indexPath)
            configureCellForName(cell)
            return cell

        case IndexPath(row: 1, section: 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.target, for: indexPath)
            configureCellForTarget(cell)
            return cell

        default:
            return UITableViewCell()
        }
    }

    private func configureCellForName(_ cell: UITableViewCell) {
        var content = FormTextFieldContentConfiguration()
        content.placeholder = String(localized: "SAVINGS_GOAL_NAME", comment: "Savings Goal Name")
        content.text = viewModel.savingsGoalName
        content.onChange = { [weak self] text in
            self?.viewModel.savingsGoalName = text
        }
        cell.contentConfiguration = content
        cell.selectionStyle = .none
        cell.accessibilityIdentifier = "savings-goal-name-cell"
    }

    private func configureCellForTarget(_ cell: UITableViewCell) {
        var content = FormMoneyFieldContentConfiguration()
        content.label = String(localized: "TARGET", comment: "Target")
        content.placeholder = Money(minorUnits: 0, currency: viewModel.currency).formatted()
        content.amount = viewModel.savingsGoalTarget
        content.onChange = { [weak self] value in
            self?.viewModel.savingsGoalTarget = value
        }
        cell.contentConfiguration = content
        cell.selectionStyle = .none
        cell.accessibilityIdentifier = "savings-goal-target-cell"
    }

}
