//
//  QuizViewController.swift
//  Thesis
//
//  Created by István Juhász on 2022. 11. 28..
//

import Foundation
import UIKit

class QuizViewController: UIViewController {
    
    // MARK: - Properties
    
    public var questions: [Question] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(didPressExit))
        navigationController?.navigationBar.topItem?.leftBarButtonItem?.tintColor = .black
        view.backgroundColor = .white
    }
    
    // MARK: - Selectors
    
    @objc private func didPressExit() {
        dismiss(animated: true)
    }
}
