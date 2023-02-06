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
    private let percent: Double
    private let score: Int
    
    // MARK: - Lifecycle
    
    init(quiz: Quiz, percent: Double, score: Int) {
        self.quiz = quiz
        self.percent = percent
        self.score = score
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
        view.backgroundColor = .white
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
