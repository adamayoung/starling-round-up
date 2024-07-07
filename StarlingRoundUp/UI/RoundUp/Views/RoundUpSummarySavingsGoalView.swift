//
//  RoundUpSummarySavingsGoalView.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 04/07/2024.
//

import UIKit

final class RoundUpSummarySavingsGoalView: UIView {

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
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(selectedSavingsGoal: SavingsGoal?) {
        UIView.transition(
            with: savingsGoalNameLabel,
            duration: 0.25,
            options: .transitionCrossDissolve
        ) { [weak self] in
            self?.savingsGoalNameLabel.text = selectedSavingsGoal?.name
        }
    }

}
