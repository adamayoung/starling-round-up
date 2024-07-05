//
//  RoundUpSummaryAmountView.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 05/07/2024.
//

import UIKit

final class RoundUpSummaryAmountView: UIView {

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
        roundUpAmountLabel.text = amount.formatted()
    }

}
