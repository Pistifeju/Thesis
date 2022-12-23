//
//  TestViewController.swift
//  Thesis
//
//  Created by István Juhász on 2022. 12. 23..
//

import Foundation
import UIKit
import LoremSwiftum

class TestViewController: UIViewController {
    
    // MARK: - Properties
    
    private let modelInformationView = ModelInformationView(frame: .zero)
    
    // MARK: - LifeCycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .systemBlue
        view.addSubview(modelInformationView)
        
        modelInformationView.configure(nameLabel: "Phalanx", textViewString: LoremSwiftum.Lorem.tweet)
        modelInformationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            modelInformationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            modelInformationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            modelInformationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    // MARK: - Selectors
}
