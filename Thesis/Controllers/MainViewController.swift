//
//  MainViewController.swift
//  Thesis
//
//  Created by István Juhász on 2022. 11. 12..
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "MainViewController"
        label.font = .systemFont(ofSize: 22)
        
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    // MARK: - Selectors
    
}
