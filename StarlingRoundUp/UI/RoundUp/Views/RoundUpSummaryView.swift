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

    private lazy var headerView = RoundUpSummaryHeaderView()
    private lazy var amountView = RoundUpSummaryAmountView()
    private lazy var dateView = RoundUpSummaryDateView()
    private lazy var savingsGoalView = RoundUpSummarySavingsGoalView()
    private lazy var transferView = RoundUpSummaryTransferView()
    private lazy var accountBalanceView = RoundUpSummaryAccountBalanceView()

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

        stackView.addArrangedSubview(headerView)
        stackView.setCustomSpacing(20, after: headerView)
        stackView.addArrangedSubview(amountView)
        stackView.setCustomSpacing(20, after: amountView)
        stackView.addArrangedSubview(dateView)
        stackView.setCustomSpacing(20, after: dateView)
        stackView.addArrangedSubview(savingsGoalView)
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(transferView)
        stackView.setCustomSpacing(20, after: transferView)
        stackView.addArrangedSubview(accountBalanceView)

        dateView.delegate = self
        transferView.delegate = self
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with roundUpSummary: RoundUpSummary?, selectedSavingsGoal: SavingsGoal?) {
        guard let roundUpSummary else {
            return
        }

        amountView.configure(amount: roundUpSummary.amount)
        dateView.configure(
            timeWindow: roundUpSummary.timeWindow,
            fromDate: roundUpSummary.dateRange.lowerBound,
            hasNextRoundUp: !roundUpSummary.isDateRangeEndInFuture
        )
        savingsGoalView.configure(selectedSavingsGoal: selectedSavingsGoal)
        transferView.configure(with: roundUpSummary)
        accountBalanceView.configure(accountBalance: roundUpSummary.accountBalance)
    }

    func isTransferring(_ transferring: Bool) {
        transferView.isTransferring(transferring)
        dateView.isEnabled(!transferring)
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

extension RoundUpSummaryView: RoundUpSummaryTransferViewDelegate {

    func viewWantsToPerformTransfer(_: RoundUpSummaryTransferView) {
        delegate?.viewWantsToPerformTransfer(self)
    }

}
