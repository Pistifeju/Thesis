//
//  EndOfQuizController.swift
//  Thesis
//
//  Created by István Juhász on 2022. 12. 03..
//

import UIKit

class EndOfQuizController: UIViewController {
    
    // MARK: - Properties
    
    private let completedQuiz: CompletedQuiz
    
    // MARK: - Lifecycle
    
    private let descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.preferredFont(forTextStyle: .title3)
        tv.textColor = .black
        tv.textAlignment = .justified
        tv.isScrollEnabled = false
        tv.isUserInteractionEnabled = true
        tv.isEditable = false
        tv.isSelectable = false
        return tv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Error"
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    private let completionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Completion"
        label.textColor = .gray
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        return label
    }()
    
    private let divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = .black
        divider.tintColor = .black
        divider.layer.cornerRadius = 2
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }()
    
    private let achievedScoreLabel = EndOfQuizStatLabel(text: "Achieved Score: Error/Error point(s)")
    private let achievedPercentLabel = EndOfQuizStatLabel(text: "Achieved percent: Error%")
    private let timeUsedLabel = EndOfQuizStatLabel(text: "Time used for completion: Error minute(s).")
    
    private var reviewQuizButton = QuizCustomNavigationButton(title: "Review Test")
    private var exitButton = QuizCustomNavigationButton(title: "Exit")
    
    init(completedQuiz: CompletedQuiz) {
        self.completedQuiz = completedQuiz
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exitButton.addTarget(self, action: #selector(didTapExit), for: .touchUpInside)
        
        calculateScore()
        
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
        
        titleLabel.text = completedQuiz.name
        descriptionTextView.text = completedQuiz.quizDescription
        navigationController?.navigationBar.isHidden = true
        
        navigationItem.setHidesBackButton(true, animated: true)
        
        exitButton.backgroundColor = .exitRed
        
        //Labels
        view.addSubview(titleLabel)
        view.addSubview(completionLabel)
        view.addSubview(timeUsedLabel)
        view.addSubview(achievedScoreLabel)
        view.addSubview(achievedPercentLabel)
        
        view.addSubview(divider)
        view.addSubview(reviewQuizButton)
        view.addSubview(exitButton)
        
        if !descriptionTextView.text.isEmpty {
            view.addSubview(descriptionTextView)
            descriptionTextView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 4).isActive = true
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: descriptionTextView.trailingAnchor, multiplier: 4).isActive = true
            descriptionTextView.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 2).isActive = true
            divider.topAnchor.constraint(equalToSystemSpacingBelow: descriptionTextView.bottomAnchor, multiplier: 2).isActive = true
            
            view.layoutSubviews()
            if descriptionTextView.contentSize.height > view.frame.height / 2.5 {
                descriptionTextView.isScrollEnabled = true
                descriptionTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
            }
        } else {
            divider.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 2).isActive = true
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 4),
            
            divider.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 4),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: divider.trailingAnchor, multiplier: 4),
            divider.heightAnchor.constraint(equalToConstant: 2),
            
            completionLabel.topAnchor.constraint(equalToSystemSpacingBelow: divider.bottomAnchor, multiplier: 1),
            completionLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 4),
            
            timeUsedLabel.topAnchor.constraint(equalToSystemSpacingBelow: completionLabel.bottomAnchor, multiplier: 2),
            timeUsedLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 4),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: timeUsedLabel.trailingAnchor, multiplier: 4),
            
            achievedScoreLabel.topAnchor.constraint(equalToSystemSpacingBelow: timeUsedLabel.bottomAnchor, multiplier: 1),
            achievedScoreLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 4),
            
            achievedPercentLabel.topAnchor.constraint(equalToSystemSpacingBelow: achievedScoreLabel.bottomAnchor, multiplier: 1),
            achievedPercentLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 4),
            
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: exitButton.bottomAnchor, multiplier: 2),
            exitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            exitButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            exitButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07),
            
            exitButton.topAnchor.constraint(equalToSystemSpacingBelow: reviewQuizButton.bottomAnchor, multiplier: 2),
            reviewQuizButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reviewQuizButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            reviewQuizButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07),
        ])
        
        if !completedQuiz.allowViewCompletedTest {
            reviewQuizButton.isHidden = true
        }
    }
    
    private func calculateScore() {
        for question in completedQuiz.answeredQuestions {
            switch question.type {
            case .singleChoice:
                print("")
            case .multipleChoice:
                print("")
            case .TrueFalse:
                print("")
            }
        }
    }
    
    // MARK: - Selectors
    
    @objc private func didTapExit() {
        let defaults = UserDefaults.standard
        for (key, value) in defaults.dictionaryRepresentation() {
            print("\(key) = \(value)")
        }
    }
}
