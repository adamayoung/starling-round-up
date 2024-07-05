//
//  RoundUpSummaryTransferView.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 05/07/2024.
//

import UIKit

protocol RoundUpSummaryTransferViewDelegate: AnyObject {

    func viewWantsToPerformTransfer(_ view: RoundUpSummaryTransferView)

}

final class RoundUpSummaryTransferView: UIView {

    weak var delegate: (any RoundUpSummaryTransferViewDelegate)?

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

    init() {
        super.init(frame: .zero)

        addSubview(transferButton)
        transferButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(insufficentFundsForTransferLabel)
        insufficentFundsForTransferLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                transferButton.topAnchor.constraint(equalTo: topAnchor),
                transferButton.leadingAnchor.constraint(equalTo: leadingAnchor),
                transferButton.trailingAnchor.constraint(equalTo: trailingAnchor),
                transferButton.bottomAnchor.constraint(equalTo: bottomAnchor),
                insufficentFundsForTransferLabel.topAnchor.constraint(equalTo: topAnchor),
                insufficentFundsForTransferLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                insufficentFundsForTransferLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
                insufficentFundsForTransferLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
            ]
        )

        transferButton.alpha = 0
        insufficentFundsForTransferLabel.alpha = 0
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with roundUpSummary: RoundUpSummary?) {
        guard let roundUpSummary else {
            return
        }

        transferButton.setTitle(
            String(localized: "TRANSFER_\(roundUpSummary.amount.formatted())", comment: "Transfer <Money>"),
            for: .normal
        )

        let hasSufficentFundsForTransfer = roundUpSummary.hasSufficentFundsForTransfer
        let canTransfer = hasSufficentFundsForTransfer && roundUpSummary.isRoundUpAvailable

        showTransferButton(canTransfer)
        showInsufficentFundsLabel(!hasSufficentFundsForTransfer)
    }

}

extension RoundUpSummaryTransferView {

    private func showTransferButton(_ show: Bool) {
        transferButton.alpha = show ? 1 : 0
    }

    private func showInsufficentFundsLabel(_ show: Bool) {
        insufficentFundsForTransferLabel.alpha = show ? 1 : 0
    }

}

extension RoundUpSummaryTransferView {

    private func didTapTransfer() {
        delegate?.viewWantsToPerformTransfer(self)
    }

}
