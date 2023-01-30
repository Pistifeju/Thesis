//
//  QuizSettingsViewController.swift
//  Thesis
//
//  Created by István Juhász on 2023. 01. 30..
//

import UIKit

class QuizSettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let settingsTitle: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .headline).bold()
        label.text = "Test Settings"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Helpers
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(settingsTitle)

        NSLayoutConstraint.activate([
            settingsTitle.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1),
            settingsTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    // MARK: - Selectors
}
