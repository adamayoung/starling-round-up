//
//  RoundUpSummaryHeaderView.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 05/07/2024.
//

import UIKit

final class RoundUpSummaryHeaderView: UIView {

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var roundUpImageView: UIImageView = {
        let imageView = UIImageView(image: .roundUp)
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
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
