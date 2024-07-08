//
//  UIAlertController+Error.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 08/07/2024.
//

import UIKit

extension UIAlertController {

    convenience init(title: String, error: Error, completion: (() -> Void)? = nil) {
        let message = {
            guard let error = error as? LocalizedError else {
                return String(
                    localized: "UNKNOWN_ERROR",
                    comment: "An unknown error occurred."
                )
            }

            return error.localizedDescription
        }()

        self.init(title: title, message: message, preferredStyle: .alert)

        let dismissAction = UIAlertAction(
            title: String(localized: "OK", comment: "OK"),
            style: .default
        ) { _ in
            completion?()
        }
        addAction(dismissAction)
    }

}
