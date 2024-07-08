//
//  AccountDetailsSummaryView.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import UIKit

protocol AccountDetailsSummaryViewDelegate: AnyObject {

    func viewWantsToShowRoundUp(_ view: AccountDetailsSummaryView)

}

final class AccountDetailsSummaryView: UIView {

    weak var delegate: (any AccountDetailsSummaryViewDelegate)?

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()

    private lazy var accountBalanceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var balanceLabel: UILabel = {
        let label = UILabel()
        if let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle)
            .withSymbolicTraits(.traitBold) {
            label.font = UIFont(descriptor: fontDescriptor, size: 0.0)
        }
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()

    private lazy var balanceTextLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.text = String(localized: "BALANCE", comment: "Balance")
        return label
    }()

    private lazy var roundUpButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.buttonSize = .medium
        configuration.title = String(localized: "ROUND_UP", comment: "Round-Up")
        configuration.image = UIImage(systemName: ImageName.roundUp)
        configuration.imagePadding = 5
        let action = UIAction { [weak self] _ in
            self?.didTapRoundUp()
        }

        let button = UIButton(primaryAction: action)
        button.configuration = configuration
        button.accessibilityIdentifier = "round-up-button"
        return button
    }()

    init() {
        super.init(frame: .zero)

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])

        stackView.addArrangedSubview(accountBalanceStackView)
        accountBalanceStackView.addArrangedSubview(balanceLabel)
        accountBalanceStackView.addArrangedSubview(balanceTextLabel)

        let actionsView = UIView()
        stackView.addArrangedSubview(actionsView)
        actionsView.addSubview(roundUpButton)
        roundUpButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roundUpButton.trailingAnchor.constraint(equalTo: actionsView.trailingAnchor),
            roundUpButton.centerYAnchor.constraint(equalTo: actionsView.centerYAnchor)
        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with accountSummary: AccountSummary?) {
        balanceLabel.text = accountSummary?.balance.formatted() ?? "-"
    }

}

extension AccountDetailsSummaryView {

    private func didTapRoundUp() {
        delegate?.viewWantsToShowRoundUp(self)
    }

}
