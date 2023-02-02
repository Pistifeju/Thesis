//
//  QuizViewController.swift
//  Thesis
//
//  Created by István Juhász on 2023. 02. 02..
//
//7UYQ1Y-4I920G
import UIKit

class QuizViewController: UIViewController {
    
    // MARK: - Properties
    
    private let question: Question
    
    private var goToARModeButton = QuizCustomNavigationButton(title: "Start AR Mode")
    private var answer1Button = CustomAnswerButton(answerLabel: "Answer 1")
    private var answer2Button = CustomAnswerButton(answerLabel: "Answer 2")
    private var answer3Button = CustomAnswerButton(answerLabel: "Answer 3")
    private var answer4Button = CustomAnswerButton(answerLabel: "Answer 4")
    
    private lazy var questionTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Сhoose 1 from multiple answers"
        return label
    }()
    
    private let labelForHeight: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .title2).bold()
        label.text = "This is going to be a long title but its going to be invisible its only for creating a height."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .title2).bold()
        label.text = "Error loading question"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.textAlignment = .center
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
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        view.backgroundColor = .white
        
        //Labels
        view.addSubview(labelForHeight)
        view.addSubview(questionLabel)
        view.addSubview(questionTypeLabel)
        
        //Buttons
        view.addSubview(answer1Button)
        view.addSubview(answer2Button)
        view.addSubview(answer3Button)
        view.addSubview(answer4Button)
        view.addSubview(goToARModeButton)
        
        NSLayoutConstraint.activate([
            labelForHeight.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: calculateHeightForTitleLabel()),
            labelForHeight.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelForHeight.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 4),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: labelForHeight.trailingAnchor, multiplier: 4),
            
            questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: calculateHeightForTitleLabel()),
            questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            questionLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 4),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: questionLabel.trailingAnchor, multiplier: 4),
            questionLabel.centerYAnchor.constraint(equalTo: labelForHeight.centerYAnchor),
            
            answer1Button.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.09),
            answer2Button.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.09),
            answer3Button.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.09),
            answer4Button.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.09),
            goToARModeButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07),
            
            questionTypeLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 4),
            questionTypeLabel.topAnchor.constraint(equalToSystemSpacingBelow: questionLabel.bottomAnchor, multiplier: 4),
            
            answer1Button.topAnchor.constraint(equalToSystemSpacingBelow: questionTypeLabel.bottomAnchor, multiplier: 1),
            answer1Button.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 4),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: answer1Button.trailingAnchor, multiplier: 4),
            
            answer2Button.topAnchor.constraint(equalToSystemSpacingBelow: answer1Button.bottomAnchor, multiplier: 1),
            answer2Button.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 4),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: answer2Button.trailingAnchor, multiplier: 4),
            
            answer3Button.topAnchor.constraint(equalToSystemSpacingBelow: answer2Button.bottomAnchor, multiplier: 1),
            answer3Button.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 4),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: answer3Button.trailingAnchor, multiplier: 4),
            
            answer4Button.topAnchor.constraint(equalToSystemSpacingBelow: answer3Button.bottomAnchor, multiplier: 1),
            answer4Button.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 4),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: answer4Button.trailingAnchor, multiplier: 4),
            
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: goToARModeButton.bottomAnchor, multiplier: 1),
            goToARModeButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 4),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: goToARModeButton.trailingAnchor, multiplier: 4),
        ])
        
    }
    
    private func configureUI() {
        questionLabel.text = question.question
        answer1Button.setTitle(question.answers[0], for: .normal)
        answer2Button.setTitle(question.answers[1], for: .normal)
        answer3Button.setTitle(question.answers[2], for: .normal)
        answer4Button.setTitle(question.answers[3], for: .normal)
    }
    
    private func calculateHeightForTitleLabel() -> CGFloat {
        // submit button topAnchor 16
        // submit button height view.frame.size.width / 9
        // progressView height submitButton.height / 10
        // progressView topAnchor 16
        // this view topAnchor 16
        // for better UI 16
        let submitButtonHeight = view.frame.size.width / 9
        let height = 16 + 16 + 16 + 16 + submitButtonHeight + submitButtonHeight / 10
        return height
    }
    
    // MARK: - Selectors
}
