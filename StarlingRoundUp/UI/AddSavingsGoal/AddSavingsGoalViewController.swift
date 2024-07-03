//
//  AddSavingsGoalViewController.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 03/07/2024.
//

import UIKit

protocol AddSavingsGoalView: AnyObject {}

protocol AddSavingsGoalViewControlling: AddSavingsGoalView, UIViewController {}

final class AddSavingsGoalViewController: UIViewController, AddSavingsGoalViewControlling {

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }

}
