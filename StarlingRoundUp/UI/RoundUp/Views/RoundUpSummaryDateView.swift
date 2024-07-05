//
//  RoundUpSummaryDateView.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 04/07/2024.
//

import UIKit

protocol RoundUpSummaryDateViewDelegate: AnyObject {

    func viewWantsPreviousRoundUp(_ view: RoundUpSummaryDateView)

    func viewWantsNextRoundUp(_ view: RoundUpSummaryDateView)

}

final class RoundUpSummaryDateView: UIView {

    weak var delegate: (any RoundUpSummaryDateViewDelegate)?

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        return stackView
    }()

    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var timePeriodLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .white
        label.textAlignment = .center
        label.text = String(localized: "FOR_\("-")_BEGINNING", comment: "for %@ beginning")
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "-"
        return label
    }()

    private lazy var previousRoundUpButton: UIButton = {
        let symbolConfig = UIImage.SymbolConfiguration(weight: .heavy)
        var configuration = UIButton.Configuration.borderless()
        configuration.buttonSize = .large
        configuration.image = UIImage(systemName: "chevron.left", withConfiguration: symbolConfig)
        configuration.imagePlacement = .all
        let action = UIAction { [weak self] _ in
            self?.previousRoundUp()
        }

        let button = UIButton(primaryAction: action)
        button.configuration = configuration
        return button
    }()

    private lazy var nextRoundUpButton: UIButton = {
        let symbolConfig = UIImage.SymbolConfiguration(weight: .heavy)
        var configuration = UIButton.Configuration.borderless()
        configuration.buttonSize = .large
        configuration.imagePlacement = .all
        configuration.image = UIImage(systemName: "chevron.right", withConfiguration: symbolConfig)
        let action = UIAction { [weak self] _ in
            self?.nextRoundUp()
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

        stackView.addArrangedSubview(previousRoundUpButton)
        stackView.addArrangedSubview(labelStackView)
        labelStackView.addArrangedSubview(timePeriodLabel)
        labelStackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(nextRoundUpButton)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(timeWindow: RoundUpTimeWindow, fromDate: Date, hasNextRoundUp: Bool) {
        let timeWindowName = Self.localizedString(for: timeWindow)
        timePeriodLabel.text = String(localized: "FOR_\(timeWindowName)_BEGINNING", comment: "for %@ beginning")
        dateLabel.text = fromDate.formatted(date: .abbreviated, time: .omitted)
        nextRoundUpButton.alpha = hasNextRoundUp ? 1 : 0
    }

}

extension RoundUpSummaryDateView {

    private func previousRoundUp() {
        delegate?.viewWantsPreviousRoundUp(self)
    }

    private func nextRoundUp() {
        delegate?.viewWantsNextRoundUp(self)
    }

}

extension RoundUpSummaryDateView {

    private static func localizedString(for timeWindow: RoundUpTimeWindow) -> String {
        switch timeWindow {
        case .week:
            String(localized: "WEEK", comment: "week")
        }
    }

}
