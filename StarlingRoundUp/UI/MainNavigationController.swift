//
//  MainNavigationController.swift
//  StarlingRoundUp
//
//  Created by Adam Young on 02/07/2024.
//

import UIKit

protocol MainNavigationView: AnyObject {}

protocol MainNavigationControlling: MainNavigationView, UINavigationController {}

final class MainNavigationController: UINavigationController, MainNavigationControlling {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.prefersLargeTitles = true
    }

}
