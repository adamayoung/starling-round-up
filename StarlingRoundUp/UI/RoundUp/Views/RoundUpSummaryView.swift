//
//  RoundUpSummaryView.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 04/07/2024.
//

import UIKit

protocol RoundUpSummaryViewDelegate: AnyObject {

    func viewWantsPreviousRoundUp(_ view: RoundUpSummaryView)

    func viewWantsNextRoundUp(_ view: RoundUpSummaryView)

    func viewWantsToPerformTransfer(_ view: RoundUpSummaryView)

}

final class RoundUpSummaryView: UIView {

    weak var delegate: (any RoundUpSummaryViewDelegate)?

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var roundUpImageView: UIImageView = {
        let image = UIImage(systemName: ImageName.roundUp)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var roundUpLabel: UILabel = {
        let label = UILabel()
        if let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle)
            .withSymbolicTraits(.traitBold) {
            label.font = UIFont(descriptor: fontDescriptor, size: 0.0)
        }
        label.textColor = .white
        label.textAlignment = .center
        label.text = String(localized: "ROUND_UP", comment: "Round-Up")
        return label
    }()

    private lazy var roundUpAmountLabel: UILabel = {
        let label = UILabel()
        if let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle)
            .withSymbolicTraits(.traitBold) {
            label.font = UIFont(descriptor: fontDescriptor, size: 100)
        }
        label.textColor = .white
        label.textAlignment = .center
        label.text = "£11.11"
        return label
    }()

    private lazy var roundUpSummaryDateView: RoundUpSummaryDateView = {
        let view = RoundUpSummaryDateView()
        view.delegate = self
        return view
    }()

    private lazy var savingsGoalView: RoundUpSummarySavingsGoalView = {
        let view = RoundUpSummarySavingsGoalView()
        return view
    }()

    private lazy var transferButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.buttonSize = .large
        let action = UIAction { [weak self] _ in
            self?.didTapTransfer()
        }

        let button = UIButton(primaryAction: action)
        button.configuration = configuration
        return button
    }()

    private lazy var insufficentFundsForTransferLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .white
        label.textAlignment = .center
        label.text = String(localized: "INSUFFICIENT_FUNDS_FOR_TRANSFER", comment: "Insufficient funds for transfer")
        return label
    }()

    private lazy var accountBalanceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var accountBalanceAmountLabel: UILabel = {
        let label = UILabel()
        if let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .footnote)
            .withSymbolicTraits(.traitBold) {
            label.font = UIFont(descriptor: fontDescriptor, size: 0)
        }
        label.textColor = .white
        label.textAlignment = .center
        label.text = "-"
        return label
    }()

    private lazy var accountBalanceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .white
        label.textAlignment = .center
        label.text = String(localized: "ACCOUNT_BALANCE", comment: "Account Balance")
        return label
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

        let roundUpImageViewContainer = UIView()
        roundUpImageViewContainer.addSubview(roundUpImageView)
        roundUpImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                roundUpImageView.topAnchor.constraint(equalTo: roundUpImageViewContainer.topAnchor),
                roundUpImageView.bottomAnchor.constraint(equalTo: roundUpImageViewContainer.bottomAnchor),
                roundUpImageView.centerXAnchor.constraint(equalTo: roundUpImageViewContainer.centerXAnchor),
                roundUpImageView.heightAnchor.constraint(equalToConstant: 100),
                roundUpImageView.widthAnchor.constraint(equalTo: roundUpImageView.heightAnchor)
            ]
        )

        stackView.addArrangedSubview(roundUpImageViewContainer)
        stackView.addArrangedSubview(roundUpLabel)
        stackView.setCustomSpacing(20, after: roundUpLabel)
        stackView.addArrangedSubview(roundUpAmountLabel)
        stackView.setCustomSpacing(20, after: roundUpAmountLabel)
        stackView.addArrangedSubview(roundUpSummaryDateView)
        stackView.setCustomSpacing(20, after: roundUpSummaryDateView)
        stackView.addArrangedSubview(savingsGoalView)
        stackView.addArrangedSubview(UIView())

        let transferButtonContainerView = UIView()
        transferButtonContainerView.addSubview(transferButton)
        transferButton.translatesAutoresizingMaskIntoConstraints = false
        transferButtonContainerView.addSubview(insufficentFundsForTransferLabel)
        insufficentFundsForTransferLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                transferButton.topAnchor.constraint(equalTo: transferButtonContainerView.topAnchor),
                transferButton.leadingAnchor.constraint(equalTo: transferButtonContainerView.leadingAnchor),
                transferButton.trailingAnchor.constraint(equalTo: transferButtonContainerView.trailingAnchor),
                transferButton.bottomAnchor.constraint(equalTo: transferButtonContainerView.bottomAnchor),
                insufficentFundsForTransferLabel.topAnchor.constraint(equalTo: transferButtonContainerView.topAnchor),
                insufficentFundsForTransferLabel.leadingAnchor.constraint(
                    equalTo: transferButtonContainerView.leadingAnchor
                ),
                insufficentFundsForTransferLabel.trailingAnchor.constraint(
                    equalTo: transferButtonContainerView.trailingAnchor
                ),
                insufficentFundsForTransferLabel.bottomAnchor.constraint(
                    equalTo: transferButtonContainerView.bottomAnchor
                )
            ]
        )
        stackView.addArrangedSubview(transferButtonContainerView)
        transferButton.alpha = 0
        insufficentFundsForTransferLabel.alpha = 0

        stackView.setCustomSpacing(20, after: transferButtonContainerView)
        accountBalanceStackView.addArrangedSubview(accountBalanceAmountLabel)
        accountBalanceStackView.addArrangedSubview(accountBalanceLabel)
        stackView.addArrangedSubview(accountBalanceStackView)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with roundUpSummary: RoundUpSummary?, selectedSavingsGoal: SavingsGoal?) {
        guard let roundUpSummary else {
            return
        }

        roundUpAmountLabel.text = roundUpSummary.amount.formatted()

        transferButton.setTitle(
            String(localized: "TRANSFER_\(roundUpSummary.amount.formatted())", comment: "Transfer <Money>"),
            for: .normal
        )
        updateTransferState(with: roundUpSummary)

        accountBalanceAmountLabel.text = roundUpSummary.accountBalance.formatted()
        roundUpSummaryDateView.configure(
            timeWindow: roundUpSummary.timeWindow,
            fromDate: roundUpSummary.dateRange.lowerBound,
            hasNextRoundUp: !roundUpSummary.isDateRangeEndInFuture
        )
        savingsGoalView.configure(selectedSavingsGoal: selectedSavingsGoal)
    }

    private func updateTransferState(with roundUpSummary: RoundUpSummary) {
        let hasSufficentFundsForTransfer = roundUpSummary.hasSufficentFundsForTransfer
        let canTransfer = hasSufficentFundsForTransfer && roundUpSummary.isRoundUpAvailable
        transferButton.alpha = canTransfer ? 1 : 0
        insufficentFundsForTransferLabel.alpha = hasSufficentFundsForTransfer ? 0 : 1
    }

}

extension RoundUpSummaryView {

    private func didTapTransfer() {
        delegate?.viewWantsToPerformTransfer(self)
    }

}

extension RoundUpSummaryView: RoundUpSummaryDateViewDelegate {

    func viewWantsPreviousRoundUp(_: RoundUpSummaryDateView) {
        delegate?.viewWantsPreviousRoundUp(self)
    }

    func viewWantsNextRoundUp(_: RoundUpSummaryDateView) {
        delegate?.viewWantsNextRoundUp(self)
    }

}
