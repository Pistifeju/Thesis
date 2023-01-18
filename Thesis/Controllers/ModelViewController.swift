//
//  ModelViewController.swift
//  Thesis
//
//  Created by István Juhász on 2023. 01. 19..
//

import UIKit

class ModelViewController: UIViewController {
    
    // MARK: - Properties
    
    public var modelName = ""
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissVC))
        
        self.setupUI()
    }
    
    // MARK: - Helpers
    private func setupUI() {
        self.view.backgroundColor = .white
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.isHidden = false
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        NSLayoutConstraint.activate([
            
        ])
    }
    
    private func loadModel() {
        
    }
    
    // MARK: - Selectors
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
}
