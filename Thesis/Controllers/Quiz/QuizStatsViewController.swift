//
//  QuizStatsViewController.swift
//  Thesis
//
//  Created by István Juhász on 2023. 03. 07..
//

import Foundation
import UIKit

class QuizStatsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let quiz: Quiz
    
    private let completionStatsView = CompletionStatsView(frame: .zero)
    
    private let codeLabel: UILabel = {
        let label = UILabel()
        label.text = "Code: "
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    private let numberOfQuestionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Number of questions: "
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    private let dividerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.tintColor = .black
        return view
    }()
    
    // MARK: - LifeCycle
    
    init(quiz: Quiz) {
        self.quiz = quiz
        self.codeLabel.text = "Code: \(quiz.code)"
        self.numberOfQuestionsLabel.text = "Number of questions: \(quiz.questions.count)"
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
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .white
        title = quiz.name
        
        view.addSubview(dividerView)
        view.addSubview(completionStatsView)
        
        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dividerView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 0),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: dividerView.trailingAnchor, multiplier: 0),
            dividerView.heightAnchor.constraint(equalToConstant: 2),
            
            completionStatsView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: completionStatsView.trailingAnchor, multiplier: 2),
            completionStatsView.topAnchor.constraint(equalToSystemSpacingBelow: dividerView.bottomAnchor, multiplier: 2),
        ])
    }
    
    // MARK: - Selectors
}
