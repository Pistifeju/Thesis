//
//  EndOfQuizController.swift
//  Thesis
//
//  Created by István Juhász on 2022. 12. 03..
//

import UIKit

class EndOfQuizController: UIViewController {
    
    // MARK: - Properties
    
    private let quiz: Quiz
    private let userAnswers: [[String]]
    
    // MARK: - Lifecycle
    
    init(quiz: Quiz, userAnswers: [[String]]) {
        self.quiz = quiz
        self.userAnswers = userAnswers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .yellow
        navigationItem.setHidesBackButton(true, animated: true)
        
        NSLayoutConstraint.activate([
        ])
    }
    
    private func checkGoodAnswers() -> Int {
        // TODO:
//        var goodAnswers: Int = 0
//        for question in questions {
//            if question.selectedIndex == question.answerIndex {
//                goodAnswers += 1
//            }
//        }
//
//        return goodAnswers
        return 1
    }
    
    // MARK: - Selectors
    
}
