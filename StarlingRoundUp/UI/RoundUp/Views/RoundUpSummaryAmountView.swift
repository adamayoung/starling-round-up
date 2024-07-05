//
//  RoundUpSummaryAmountView.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 05/07/2024.
//

import UIKit

final class RoundUpSummaryAmountView: UIView {

    private var currentAmount: Money?

    private lazy var roundUpAmountLabel: UILabel = {
        let label = UILabel()
        if let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle)
            .withSymbolicTraits(.traitBold) {
            label.font = UIFont(descriptor: fontDescriptor, size: 100)
        }
        label.textColor = .white
        label.textAlignment = .center
        label.text = "-"
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()

    init() {
        super.init(frame: .zero)

        addSubview(roundUpAmountLabel)
        roundUpAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roundUpAmountLabel.topAnchor.constraint(equalTo: topAnchor),
            roundUpAmountLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            roundUpAmountLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            roundUpAmountLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(amount: Money) {
        animateAmount(from: currentAmount, to: amount)
        currentAmount = amount
    }

}

extension RoundUpSummaryAmountView {

    private func animateAmount(from fromAmount: Money?, to toAmount: Money) {
        guard let fromAmount else {
            roundUpAmountLabel.text = toAmount.formatted()
            return
        }

        guard fromAmount.minorUnits != toAmount.minorUnits else {
            return
        }

        let duration: TimeInterval = 0.2
        let start = fromAmount.minorUnits
        let end = toAmount.minorUnits
        let steps = abs(end - start)
        let isIncrementing = fromAmount.minorUnits < toAmount.minorUnits
        let rate = duration / Double(steps)

        DispatchQueue.global().async { [weak self] in
            for step in 0 ... steps {
                let minorUnits = {
                    if isIncrementing {
                        return fromAmount.minorUnits + step
                    }

                    return fromAmount.minorUnits - step
                }()
                let amount = Money(minorUnits: minorUnits, currency: toAmount.currency)

                DispatchQueue.main.asyncAfter(deadline: .now() + rate * Double(step)) {
                    self?.roundUpAmountLabel.text = amount.formatted()
                    self?.roundUpAmountLabel.setNeedsDisplay()
                }
            }
        }
    }

}
