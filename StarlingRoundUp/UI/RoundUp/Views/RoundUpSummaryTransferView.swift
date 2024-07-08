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

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.color = .white
        view.hidesWhenStopped = true
        return view
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

        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
            ]
        )
        activityIndicator.stopAnimating()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with roundUpSummary: RoundUpSummary?, selectedSavingsGoal: SavingsGoal?) {
        guard let roundUpSummary else {
            return
        }

        if roundUpSummary.amount.minorUnits > 0 {
            updateTransferButtonTitle(with: roundUpSummary.amount)
        }

        let hasSufficentFundsForTransfer = roundUpSummary.hasSufficentFundsForTransfer
        let canTransfer = hasSufficentFundsForTransfer
            && roundUpSummary.isRoundUpAvailable
            && selectedSavingsGoal != nil

        activityIndicator.stopAnimating()
        showTransferButton(canTransfer)
        showInsufficentFundsLabel(!hasSufficentFundsForTransfer)
    }

    func isTransferring(_ transferring: Bool) {
        if !transferring {
            activityIndicator.stopAnimating()
        }

        showTransferButton(!transferring) { [weak self] in
            if transferring {
                self?.activityIndicator.startAnimating()
            }
        }
    }

}

extension RoundUpSummaryTransferView {

    private func updateTransferButtonTitle(with amount: Money) {
        let formattedAmount = amount.formatted()
        let title = String(
            localized: "TRANSFER_\(formattedAmount)",
            comment: "Transfer <Money>"
        )

        let font = UIFont.preferredFont(forTextStyle: .body)
        let boldFont = UIFont.preferredFont(forTextStyle: .headline)

        let titleAttributedString = NSMutableAttributedString(string: title, attributes: [.font: font])
        if let amountRange = title.range(of: formattedAmount) {
            let nsRange = NSRange(amountRange, in: title)
            titleAttributedString.addAttribute(.font, value: boldFont, range: nsRange)
        }

        transferButton.setAttributedTitle(titleAttributedString, for: .normal)
    }

    private func showTransferButton(_ show: Bool, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.transferButton.alpha = show ? 1 : 0
        } completion: { _ in
            completion?()
        }
    }

    private func showInsufficentFundsLabel(_ show: Bool) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut) { [weak self] in
            self?.insufficentFundsForTransferLabel.alpha = show ? 1 : 0
        }
    }

}

extension RoundUpSummaryTransferView {

    private func didTapTransfer() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        delegate?.viewWantsToPerformTransfer(self)
    }

}
