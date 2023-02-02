//
//  QuizViewController.swift
//  Thesis
//
//  Created by István Juhász on 2023. 02. 02..
//
//69FIE2-KS6UGM
import UIKit

class QuizViewController: UIViewController {
    
    // MARK: - Properties
    
    private let question: Question
    
    private var answer1Button = CustomAnswerButton(answerLabel: "Answer 1")
    private var answer2Button = CustomAnswerButton(answerLabel: "Answer 2")
    private var answer3Button = CustomAnswerButton(answerLabel: "Answer 3")
    private var answer4Button = CustomAnswerButton(answerLabel: "Answer 4")
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .headline).bold()
        label.text = "Error loading question"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - LifeCycle
    
    init(question: Question) {
        self.question = question
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Helpers
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(questionLabel)
        view.addSubview(answer1Button)
        view.addSubview(answer2Button)
        view.addSubview(answer3Button)
        view.addSubview(answer4Button)
        
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1),
            questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            answer1Button.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.09),
            answer2Button.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.09),
            answer3Button.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.09),
            answer4Button.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.09),
            
            answer1Button.topAnchor.constraint(equalToSystemSpacingBelow: questionLabel.bottomAnchor, multiplier: 1.5),
            answer1Button.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: answer1Button.trailingAnchor, multiplier: 2),
            
            answer2Button.topAnchor.constraint(equalToSystemSpacingBelow: answer1Button.bottomAnchor, multiplier: 1),
            answer2Button.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: answer2Button.trailingAnchor, multiplier: 2),
            
            answer3Button.topAnchor.constraint(equalToSystemSpacingBelow: answer2Button.bottomAnchor, multiplier: 1),
            answer3Button.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: answer3Button.trailingAnchor, multiplier: 2),
            
            answer4Button.topAnchor.constraint(equalToSystemSpacingBelow: answer3Button.bottomAnchor, multiplier: 1),
            answer4Button.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: answer4Button.trailingAnchor, multiplier: 2),
        ])
    }
    
    // MARK: - Selectors
}

