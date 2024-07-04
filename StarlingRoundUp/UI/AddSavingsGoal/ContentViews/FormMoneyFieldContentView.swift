//
//  FormMoneyFieldContentView.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import UIKit

final class FormMoneyFieldContentView: UIView, UIContentView {

    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }

    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = .preferredFont(forTextStyle: .body)
        textField.textColor = .secondaryLabel
        textField.textAlignment = .right
        textField.keyboardType = .decimalPad
        return textField
    }()

    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        layoutMargins = .init(top: 15, left: 20, bottom: 15, right: 20)

        addSubview(label)
        addSubview(textField)
        label.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            label.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            label.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),

            textField.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            textField.leadingAnchor.constraint(equalTo: label.trailingAnchor),
            textField.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])

        let editingChangedAction = UIAction { [weak self] _ in
            guard
                let configuration = self?.configuration as? FormMoneyFieldContentConfiguration,
                let textField = self?.textField
            else {
                return
            }

            let text = textField.text ?? ""

            guard let doubleAmount = Double(text) else {
                configuration.onChange?(nil)
                return
            }

            let decimals = String(doubleAmount).split(separator: ".")[1]
            if decimals.count > 2 {
                textField.text = String(text.dropLast(1))
            }

            let minorUnits = Int(doubleAmount * 100)
            configuration.onChange?(minorUnits)
        }
        textField.addAction(editingChangedAction, for: .editingChanged)

        configure(configuration: configuration)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? FormMoneyFieldContentConfiguration else {
            return
        }

        label.text = configuration.label
        textField.text = {
            guard let amount = configuration.amount else {
                return ""
            }

            return "\(amount)"
        }()
        textField.placeholder = configuration.placeholder
    }

}

struct FormMoneyFieldContentConfiguration: UIContentConfiguration {

    var label: String?
    var amount: Int?
    var placeholder: String?
    var onChange: ((Int?) -> Void)?

    func makeContentView() -> UIView & UIContentView {
        FormMoneyFieldContentView(self)
    }

    func updated(for _: UIConfigurationState) -> FormMoneyFieldContentConfiguration {
        self
    }

}
