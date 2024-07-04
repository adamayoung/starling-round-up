//
//  FormTextFieldContentView.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import UIKit

final class FormTextFieldContentView: UIView, UIContentView {

    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }

    private lazy var textField = UITextField()

    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        layoutMargins = .init(top: 15, left: 20, bottom: 15, right: 20)

        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            textField.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        ])
        let editingChangedAction = UIAction { [weak self] _ in
            guard
                let configuration = self?.configuration as? FormTextFieldContentConfiguration,
                let textField = self?.textField
            else {
                return
            }

            configuration.onChange?(textField.text)
        }
        textField.addAction(editingChangedAction, for: .editingChanged)

        configure(configuration: configuration)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? FormTextFieldContentConfiguration else {
            return
        }

        textField.placeholder = configuration.placeholder
        textField.text = configuration.text
    }

}

struct FormTextFieldContentConfiguration: UIContentConfiguration {

    var text: String?
    var placeholder: String?
    var onChange: ((String?) -> Void)?

    func makeContentView() -> UIView & UIContentView {
        FormTextFieldContentView(self)
    }

    func updated(for _: UIConfigurationState) -> FormTextFieldContentConfiguration {
        self
    }

}
