//
//  QuizViewController.swift
//  Thesis
//
//  Created by István Juhász on 2023. 02. 02..
//
//
import UIKit

class QuizViewController: UIViewController {
    
    // MARK: - Properties
    var inReviewMode = false
    var answeredQuestion: AnsweredQuestion? {
        didSet {
            selectUserAnswers()
        }
    }
    
    private var question: Question
    
    private let modelName: String
    
    private var answer1Button = CustomAnswerButton(answerLabel: "Answer 1")
    private var answer2Button = CustomAnswerButton(answerLabel: "Answer 2")
    private var answer3Button = CustomAnswerButton(answerLabel: "Answer 3")
    private var answer4Button = CustomAnswerButton(answerLabel: "Answer 4")
    
    private let trueFalseSelector: UISegmentedControl = {
        let sc = UISegmentedControl()
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.backgroundColor = .lightGray.withAlphaComponent(0.3)
        sc.selectedSegmentTintColor = .white
        sc.tintColor = .black
        sc.insertSegment(withTitle: "True", at: 0, animated: true)
        sc.insertSegment(withTitle: "False", at: 1, animated: true)
        sc.isHidden = true
        sc.layer.borderColor = UIColor.black.cgColor
        return sc
    }()
    
    private lazy var questionTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Сhoose 1 from multiple answers"
        label.adjustsFontSizeToFitWidth = true
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
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    // MARK: - LifeCycle
    
    init(question: Question, modelName: String) {
        self.question = question
        self.modelName = modelName
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if inReviewMode {
            setUpViewControllerForViewMode()
            selectUserAnswers()
        }
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
        
        view.addSubview(trueFalseSelector)
        
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
            
            questionTypeLabel.topAnchor.constraint(equalToSystemSpacingBelow: questionLabel.bottomAnchor, multiplier: 4),
            questionTypeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            answer1Button.topAnchor.constraint(equalToSystemSpacingBelow: questionTypeLabel.bottomAnchor, multiplier: 1),
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
            
            trueFalseSelector.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trueFalseSelector.topAnchor.constraint(equalToSystemSpacingBelow: questionTypeLabel.bottomAnchor, multiplier: 2),
            trueFalseSelector.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45),
            trueFalseSelector.heightAnchor.constraint(equalTo: trueFalseSelector.widthAnchor, multiplier: 0.35),
        ])
        
    }
    
    private func selectUserAnswers() {
        guard let answeredQuestion = answeredQuestion else { return }
        let buttons = [answer1Button, answer2Button, answer3Button, answer4Button]
        for answer in answeredQuestion.userAnswers {
            for button in buttons {
                if button.titleLabel?.text == answer {
                    button.isSelected = true
                }
            }
        }
        
        if answeredQuestion.type == .TrueFalse {
            if let answer = answeredQuestion.userAnswers.first {
                if answer == "True" {
                    trueFalseSelector.selectedSegmentIndex = 0
                } else {
                    trueFalseSelector.selectedSegmentIndex = 1
                }
            }
        }
    }
    
    private func configure() {
        questionLabel.text = question.question
        
        switch question.type {
        case .singleChoice:
            setButtonTitles()
            questionTypeLabel.text = "Сhoose 1 from multiple answers"
        case .multipleChoice:
            setButtonTitles()
            questionTypeLabel.text = "Сhoose the correct answers"
        case .TrueFalse:
            questionTypeLabel.text = "Select True or False"
            trueFalseSelector.isHidden = false
            answer1Button.isHidden = true
            answer2Button.isHidden = true
            answer3Button.isHidden = true
            answer4Button.isHidden = true
        }
    }
    
    private func setButtonTitles() {
        let buttons = [answer1Button, answer2Button, answer3Button, answer4Button]
        for i in 0...buttons.count - 1 {
            buttons[i].setTitle(question.answers[i], for: .normal)
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
    
    public func returnUserAnswers() -> AnsweredQuestion {
        let answeredQuestion = AnsweredQuestion(question: question, userAnswers: [])
        
        if question.type == .TrueFalse {
            guard trueFalseSelector.selectedSegmentIndex != -1 else {
                return answeredQuestion
            }
            
            answeredQuestion.userAnswers = [trueFalseSelector.titleForSegment(at: trueFalseSelector.selectedSegmentIndex)!]
            return answeredQuestion
        }
        
        let buttons = [answer1Button, answer2Button, answer3Button, answer4Button]
        let userAnswerButtons = buttons.filter({$0.isSelected})
        
        var answers = [String]()
        
        for button in userAnswerButtons {
            answers.append(button.titleLabel!.text!)
        }
        
        answeredQuestion.userAnswers = answers
        
        return answeredQuestion
    }
    
    private func setUpViewControllerForViewMode() {
        let buttons = [answer1Button, answer2Button, answer3Button, answer4Button]
        buttons.map({$0}).forEach({$0.isUserInteractionEnabled = false})
        trueFalseSelector.isUserInteractionEnabled = false
               
        if question.type == .singleChoice {
            for correctAnswer in question.correctAnswers {
                for button in buttons {
                    if button.currentTitle == correctAnswer {
                        button.backgroundColor = .greenButton.withAlphaComponent(0.8)
                    } else {
                        button.backgroundColor = .exitRed.withAlphaComponent(0.8)
                    }
                }
            }
        } else if question.type == .multipleChoice {
            for correctAnswer in question.correctAnswers {
                for button in buttons {
                    if button.currentTitle == correctAnswer {
                        button.backgroundColor = .exitRed.withAlphaComponent(0.8)
                    } else {
                        button.backgroundColor = .greenButton.withAlphaComponent(0.8)
                    }
                }
            }
        } else {
            let correctAnswer = question.correctAnswers.first
            let selectedIndex = trueFalseSelector.selectedSegmentIndex
            if selectedIndex != -1 {
                if trueFalseSelector.titleForSegment(at: selectedIndex) == correctAnswer {
                    trueFalseSelector.backgroundColor = .greenButton.withAlphaComponent(0.8)
                } else {
                    trueFalseSelector.backgroundColor = .exitRed.withAlphaComponent(0.8)
                }
            } else {
                trueFalseSelector.backgroundColor = .exitRed.withAlphaComponent(0.8)
            }
        }
    }
    
    private func colorSegmentedControl(with color: UIColor, x1: Double, x2: Double) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [color]

        // Set the gradient layer's frame to the segmented control's bounds
        gradientLayer.frame = trueFalseSelector.bounds

        // Set the gradient layer's start and end points to create a horizontal gradient
        gradientLayer.startPoint = CGPoint(x: x1, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: x2, y: 0.5)

        // Create a new image context with the same size as the segmented control
        UIGraphicsBeginImageContextWithOptions(trueFalseSelector.bounds.size, false, 0.0)

        // Draw the gradient layer into the image context
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)

        // Get the resulting image from the image context
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()

        // End the image context
        UIGraphicsEndImageContext()

        // Set the segmented control's background image to the resulting image
        trueFalseSelector.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
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
        
        if question.type == .singleChoice {
            for button in buttons where button != sender {
                button.isSelected = false
            }
        }
    }
}
