//
//  ProfileViewController.swift
//  Thesis
//
//  Created by István Juhász on 2023. 01. 30..
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    private let user: User
    
    // MARK: - LifeCycle
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        title = user.username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        
        configureUI()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .systemBlue
        
        NSLayoutConstraint.activate([
            
        ])
    }
    
    // MARK: - Selectors
}
