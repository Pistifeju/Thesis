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
    public var questionsIndex: Int = 0
    
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.text = questions[questionsIndex].question
        
        return label
    }()
    
    private lazy var questionsIndexLabel: UILabel = {
        let label = UILabel()
        label.text = "\(self.questionsIndex)/\(questions.count)"
        label.textColor = .gray
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        
        return label
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor(red: 255/255, green: 175/255, blue: 204/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        return button
    }()
    
    
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
        navigationItem.largeTitleDisplayMode = .always
    }
    
    // MARK: - Selectors
    
    @objc private func didPressExit() {
        dismiss(animated: true)
    }
}
