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
        let button = UIBarButtonItem(title: "Savings Goal")
        button.tintColor = .white
        return button
    }()

    private lazy var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(dismiss)
        )
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
                print("Error: \(error.localizedDescription)")
//                handleError(error)
            }

            do {
                try await viewModel.refreshAvailableSavingsGoals()
            } catch let error {
                print("Error: \(error.localizedDescription)")
//                handleError(error)
                return
            }

            refreshView()
            refreshSavingsGoalsMenu()
            activityIndicator.stopAnimating()
            chooseSavingsGoalButton.isEnabled = true

            if summaryView.isHidden {
                summaryView.alpha = 0
                summaryView.isHidden = false
                UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
                    self.summaryView.alpha = 1
                }, completion: nil)
            }
        }
    }

    private func refreshRoundUpSummary() {
        Task { [weak self] in
            guard let self else {
                return
            }

            do {
                try await viewModel.fetchRoundUpSummary()
            } catch let error {
                print("Error: \(error.localizedDescription)")
//                handleError(error)
            }

            refreshView()
        }
    }

    private func refreshSavingsGoals() {
        Task { [weak self] in
            guard let self else {
                return
            }

            do {
                try await viewModel.refreshAvailableSavingsGoals()
            } catch let error {
                print("Error: \(error.localizedDescription)")
//                handleError(error)
                return
            }

            refreshView()
            refreshSavingsGoalsMenu()
        }
    }

    @objc
    private func dismiss(_: AnyObject? = nil) {
        delegate?.viewControllerDidCancel(self)
    }

    private func performTransfer() {
        Task {
            do {
                try await viewModel.performTransfer()
            } catch let error {
                print("Error: \(error.localizedDescription)")
//                handleError(error)
            }
        }
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
        let actions = viewModel.availableSavingsGoals.map { savingsGoal in
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

        return UIMenu(title: "", children: actions)
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
        refreshRoundUpSummary()
    }

    func viewWantsNextRoundUp(_: RoundUpSummaryView) {
        viewModel.incrementRoundUpTimeWindowDate()
        refreshRoundUpSummary()
    }

    func viewWantsToPerformTransfer(_: RoundUpSummaryView) {
        performTransfer()
    }

}
