//
//  RoundUpViewController.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 04/07/2024.
//

import UIKit

protocol RoundUpView: AnyObject {

    var delegate: (any RoundUpViewControllerDelegate)? { get set }

}

protocol RoundUpViewControlling: RoundUpView, UIViewController {}

final class RoundUpViewController: UIViewController, RoundUpViewControlling {

    weak var delegate: (any RoundUpViewControllerDelegate)?

    private let viewModel: any RoundUpViewModeling

    private lazy var chooseSavingsGoalButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: String(localized: "SAVINGS_GOALS", comment: "Savings Goals"))
        button.tintColor = .white
        return button
    }()

    private lazy var cancelButton: UIBarButtonItem = {
        let action = UIAction { [weak self] _ in
            self?.dismiss()
        }

        let button = UIBarButtonItem(systemItem: .cancel, primaryAction: action)
        button.tintColor = .white
        return button
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.color = .white
        view.stopAnimating()
        return view
    }()

    private lazy var summaryView: RoundUpSummaryView = {
        let view = RoundUpSummaryView()
        view.tintColor = .white
        view.delegate = self
        return view
    }()

    init(viewModel: some RoundUpViewModeling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.tintColor.cgColor, UIColor.tintColor.withAlphaComponent(0.8).cgColor]
        view.layer.insertSublayer(gradient, at: 0)

        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = chooseSavingsGoalButton

        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        view.addSubview(summaryView)
        summaryView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            summaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            summaryView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            summaryView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            summaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        summaryView.isHidden = true
        activityIndicator.startAnimating()
        chooseSavingsGoalButton.isEnabled = false
        refreshData()
    }

}

extension RoundUpViewController {

    private func refreshData() {
        Task { [weak self] in
            guard let self else {
                return
            }

            do {
                try await viewModel.fetchRoundUpSummary()
            } catch let error {
                self.handleFetchRoundUpError(error) {
                    self.dismiss()
                }

                return
            }

            refreshView()
            refreshSavingsGoalsMenu()
            activityIndicator.stopAnimating()
            chooseSavingsGoalButton.isEnabled = true

            if summaryView.isHidden {
                summaryView.alpha = 0
                summaryView.isHidden = false
                UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut) {
                    self.summaryView.alpha = 1
                }
            }
        }
    }

    @objc
    private func dismiss(_: AnyObject? = nil) {
        delegate?.viewControllerDidCancel(self)
    }

    private func startTransfer() {
        guard
            let roundUpSummary = viewModel.roundUpSummary,
            let savingsGoalName = viewModel.selectedSavingsGoal?.name
        else {
            return
        }

        let alertTitle = String(localized: "TRANSFER_TO_SAVINGS_GOAL", comment: "Transfer to Savings Goal?")
        let formattedAmount = roundUpSummary.amount.formatted()
        let alertMessage = String(
            localized: "ARE_YOU_SURE_YOU_WANT_TO_TRANSFER_\(formattedAmount)_TO_\(savingsGoalName)_SAVINGS_GOAL",
            comment: "Are you sure you want to transfer <amount> to <savings goal name> savings goal?"
        )

        let alertViewController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)

        let transferActionTitle = String(localized: "TRANSFER", comment: "Transfer")
        let cancelActionTitle = String(localized: "CANCEL", comment: "Cancel")

        let transferAction = UIAlertAction(title: transferActionTitle, style: .default) { [weak self] _ in
            self?.performTransfer(of: roundUpSummary)
        }
        let cancelAction = UIAlertAction(title: cancelActionTitle, style: .cancel)
        alertViewController.addAction(transferAction)
        alertViewController.addAction(cancelAction)
        alertViewController.view.tintColor = view.tintColor

        present(alertViewController, animated: true)
    }

    private func performTransfer(of roundUpSummary: RoundUpSummary) {
        Task { [weak self] in
            guard let self else {
                return
            }

            summaryView.isTransferring(true)
            do {
                try await viewModel.performTransfer()
                delegate?.viewController(self, didPerformTransferOfRoundUp: roundUpSummary)
            } catch let error {
                self.handleTransferError(error) {
                    self.summaryView.isTransferring(false)
                }
            }
        }
    }

    private func handleFetchRoundUpError(_: Error, completion: (() -> Void)? = nil) {
        let title = String(localized: "CANNOT_CALCULATE_ROUND_UP", comment: "Cannot Calculate Round-Up")
        let message = String(
            localized: "THERE_WAS_AN_ERROR_CALCULATE_THIS_ROUND_UP",
            comment: "There was an error calculating this Round-Up."
        )

        showErrorAlert(title: title, message: message, completion: completion)
    }

    private func handleFetchSavingsGoalsError(_: Error, completion: (() -> Void)? = nil) {
        let title = String(localized: "CANNOT_LOAD_SAVINGS_GOALS", comment: "Cannot Load Savings Goals")
        let message = String(
            localized: "THERE_WAS_AN_ERROR_LOADING_YOUR_SAVINGS_GOALS",
            comment: "There was an error loading your savings goals."
        )

        showErrorAlert(title: title, message: message, completion: completion)
    }

    private func handleTransferError(_: Error, completion: (() -> Void)? = nil) {
        let title = String(localized: "CANNOT_MAKE_TRANSFER", comment: "Cannot Make Transfer")
        let message = String(
            localized: "THERE_WAS_AN_ERROR_MAKING_THE_TRANSFER",
            comment: "There was an error making the transfer."
        )

        showErrorAlert(title: title, message: message, completion: completion)
    }

    private func showErrorAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertViewController.view.tintColor = view.tintColor

        let dismissAction = UIAlertAction(
            title: String(localized: "OK", comment: "OK"),
            style: .default
        ) { _ in
            completion?()
        }
        alertViewController.addAction(dismissAction)

        present(alertViewController, animated: true)
    }

}

extension RoundUpViewController {

    private func refreshView() {
        summaryView.configure(with: viewModel.roundUpSummary, selectedSavingsGoal: viewModel.selectedSavingsGoal)
    }

    private func refreshSavingsGoalsMenu() {
        chooseSavingsGoalButton.menu = buildSavingsGoalsMenu()
    }

    private func buildSavingsGoalsMenu() -> UIMenu {
        guard let availableSavingsGoals = viewModel.roundUpSummary?.availableSavingsGoals else {
            return UIMenu(children: [])
        }

        let actions = availableSavingsGoals.map { savingsGoal in
            let action = UIAction(
                title: savingsGoal.name,
                identifier: UIAction.Identifier(savingsGoal.id),
                handler: didSelectSavingsGoal
            )

            if viewModel.selectedSavingsGoal == savingsGoal {
                action.image = UIImage(systemName: "checkmark")
            }

            return action
        }

        return UIMenu(children: actions)
    }

    private func didSelectSavingsGoal(_ action: UIAction) {
        let savingsGoalID = action.identifier.rawValue
        viewModel.setSelectedSavingsGoal(id: savingsGoalID)
        refreshSavingsGoalsMenu()
        refreshView()
    }

}

extension RoundUpViewController: RoundUpSummaryViewDelegate {

    func viewWantsPreviousRoundUp(_: RoundUpSummaryView) {
        viewModel.decrementRoundUpTimeWindowDate()
        refreshData()
    }

    func viewWantsNextRoundUp(_: RoundUpSummaryView) {
        viewModel.incrementRoundUpTimeWindowDate()
        refreshData()
    }

    func viewWantsToPerformTransfer(_: RoundUpSummaryView) {
        startTransfer()
    }

}
