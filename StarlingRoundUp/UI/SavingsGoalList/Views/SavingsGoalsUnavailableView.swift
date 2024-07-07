//
//  SavingsGoalsUnavailableView.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import UIKit

final class SavingsGoalsUnavailableView: UIView {

    var onAction: (() -> Void)?

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    private lazy var imageView: UIImageView = {
        let image = UIImage(systemName: ImageName.savingsGoal)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .secondaryLabel
        return imageView
    }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        label.text = String(localized: "NO_SAVINGS_GOALS", comment: "No Savings Goals")
        return label
    }()

    private lazy var actionButton: UIButton = {
        var configuration = UIButton.Configuration.borderless()
        configuration.title = String(localized: "CREATE_A_SAVINGS_GOAL", comment: "Create a Savings Goal")
        let action = UIAction { [weak self] _ in
            self?.actionButtonTapped()
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
            stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(messageLabel)
        stackView.addArrangedSubview(actionButton)

        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SavingsGoalsUnavailableView {

    private func actionButtonTapped() {
        onAction?()
    }

}
