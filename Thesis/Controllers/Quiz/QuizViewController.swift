//
//  QuizViewController.swift
//  Thesis
//
//  Created by István Juhász on 2023. 02. 02..
//
//7UYQ1Y-4I920G
import UIKit

protocol QuizViewControllerDelegate: AnyObject {
    func didSelectAnswer(selected: Bool?)
}

class QuizViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: QuizViewControllerDelegate?
    
    private let question: Question
    public var selectedButton: UIButton?
    
    private let modelName: String
    private let correctAnswerString: String
    
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
    
    init(question: Question, modelName: String) {
        self.question = question
        self.modelName = modelName
        self.correctAnswerString = question.answers[0]
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        answer1Button.addTarget(self, action: #selector(didTapAnswerButton(_:)), for: .touchUpInside)
        answer2Button.addTarget(self, action: #selector(didTapAnswerButton(_:)), for: .touchUpInside)
        answer3Button.addTarget(self, action: #selector(didTapAnswerButton(_:)), for: .touchUpInside)
        answer4Button.addTarget(self, action: #selector(didTapAnswerButton(_:)), for: .touchUpInside)
        
        setupUI()
        configure()
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
        ])
        
    }
    
    private func configure() {
        questionLabel.text = question.question
        
        randomizeAnswerButtons()
    }
    
    private func randomizeAnswerButtons() {
        let buttons = [answer1Button, answer2Button, answer3Button, answer4Button]
        let range = 0...3
        var uniqueNumbers = Set<Int>()
        var setLength = -1
        while uniqueNumbers.count < 4 {
            let randomNum = range.randomElement()!
            uniqueNumbers.insert(randomNum)
            if uniqueNumbers.count > setLength {
                setLength = uniqueNumbers.count
                buttons[setLength - 1].setTitle(question.answers[randomNum], for: .normal)
            }
        }
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
    
    @objc private func didTapAnswerButton(_ sender: UIButton) {
        let buttons = [answer1Button, answer2Button, answer3Button, answer4Button]
        
        var alreadySelected = false
        for button in buttons {
            if button.isSelected {
                alreadySelected = true
                break
            }
        }
        
        sender.isSelected.toggle()
        for button in buttons where button != sender {
            button.isSelected = false
        }
        
        if sender.isSelected && alreadySelected {
            delegate?.didSelectAnswer(selected: nil)
        } else {
            delegate?.didSelectAnswer(selected: sender.isSelected)
        }
        
        if sender.isSelected {
            self.selectedButton = sender
        } else {
            self.selectedButton = nil
        }
    }
}
