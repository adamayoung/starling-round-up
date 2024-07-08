//
//  RoundUpSummarySavingsGoalView.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 04/07/2024.
//

import UIKit

protocol RoundUpSummarySavingsGoalViewDelegate: AnyObject {

    func viewWantsToAddSavingsGoal(_ view: RoundUpSummarySavingsGoalView)

}

final class RoundUpSummarySavingsGoalView: UIView {

    weak var delegate: (any RoundUpSummarySavingsGoalViewDelegate)?

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var toLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .white
        label.textAlignment = .center
        label.text = String(localized: "TO", comment: "to")
        return label
    }()

    private lazy var savingsGoalNameLabel: UILabel = {
        let label = UILabel()
        if let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title1)
            .withSymbolicTraits(.traitBold) {
            label.font = UIFont(descriptor: fontDescriptor, size: 0.0)
        }
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()

    private lazy var savingsGoalLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .white
        label.textAlignment = .center
        label.text = String(localized: "SAVINGS_GOAL", comment: "Savings Goal")
        return label
    }()

    private lazy var createSavingsGoalButtonContainer = UIView()

    private lazy var createSavingsGoalButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.buttonSize = .large
        configuration.title = String(localized: "CREATE_A_SAVINGS_GOAL", comment: "Create a Savings Goal")
        let action = UIAction { [weak self] _ in
            self?.addSavingsButtonTapped()
        }

        let button = UIButton(primaryAction: action)
        button.configuration = configuration
        return button
    }()

    init() {
        super.init(frame: .zero)

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        stackView.addArrangedSubview(toLabel)
        stackView.addArrangedSubview(savingsGoalNameLabel)
        stackView.addArrangedSubview(savingsGoalLabel)
        stackView.alpha = 0

        addSubview(createSavingsGoalButtonContainer)
        createSavingsGoalButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        createSavingsGoalButtonContainer.addSubview(createSavingsGoalButton)
        createSavingsGoalButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            createSavingsGoalButtonContainer.topAnchor.constraint(equalTo: topAnchor),
            createSavingsGoalButtonContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            createSavingsGoalButtonContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            createSavingsGoalButtonContainer.bottomAnchor.constraint(equalTo: bottomAnchor),

            createSavingsGoalButton.leadingAnchor.constraint(equalTo: createSavingsGoalButtonContainer.leadingAnchor),
            createSavingsGoalButton.trailingAnchor.constraint(equalTo: createSavingsGoalButtonContainer.trailingAnchor),
            createSavingsGoalButton.centerYAnchor.constraint(equalTo: createSavingsGoalButtonContainer.centerYAnchor)
        ])
        createSavingsGoalButtonContainer.isHidden = true
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(selectedSavingsGoal: SavingsGoal?) {
        let hasSavingsGoalSelected = selectedSavingsGoal != nil
        showSavingsGoalView(hasSavingsGoalSelected)
        createSavingsGoalButtonContainer.isHidden = hasSavingsGoalSelected

        UIView.transition(
            with: savingsGoalNameLabel,
            duration: 0.25,
            options: .transitionCrossDissolve
        ) { [weak self] in
            self?.savingsGoalNameLabel.text = selectedSavingsGoal?.name
        }
    }

}

extension RoundUpSummarySavingsGoalView {

    private func showSavingsGoalView(_ show: Bool) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.stackView.alpha = show ? 1 : 0
        }
    }

}

extension RoundUpSummarySavingsGoalView {

    private func addSavingsButtonTapped() {
        delegate?.viewWantsToAddSavingsGoal(self)
    }

}
