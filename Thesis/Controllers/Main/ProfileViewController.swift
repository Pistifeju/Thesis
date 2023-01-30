//
//  ProfileViewController.swift
//  Thesis
//
//  Created by István Juhász on 2023. 01. 30..
//
import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    private let user: User?
    
    init(user: User?) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - Helpers
    private func setupUI() {
        self.view.backgroundColor = .white
        title = "Profile"
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.isHidden = false
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        NSLayoutConstraint.activate([
            
        ])
    }
    
    // MARK: - Selectors
}
