//
//  EndOfQuizController.swift
//  Thesis
//
//  Created by István Juhász on 2022. 12. 03..
//

import Foundation
import UIKit

class EndOfQuizController: UIViewController {
    
    // MARK: - Properties
    
    public var questions: [Question] = []
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "\(checkGoodAnswers())/\(self.questions.count)"
        label.translatesAutoresizingMaskIntoConstraints = false
        
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
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func checkGoodAnswers() -> Int {
        var goodAnswers: Int = 0
        for question in questions {
            if question.selectedIndex == question.answerIndex {
                goodAnswers += 1
            }
        }
        
        return goodAnswers
    }
    
    // MARK: - Selectors
    
}
