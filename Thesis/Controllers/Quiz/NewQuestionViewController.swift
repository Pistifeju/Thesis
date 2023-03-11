//
//  NewQuestionViewController.swift
//  Thesis
//
//  Created by István Juhász on 2023. 01. 29..
//

import UIKit
import BEMCheckBox

class NewQuestionViewController: UIViewController {
    
    // MARK: - Properties
        
    private let questionTypeSelector: UISegmentedControl = {
        let sc = UISegmentedControl()
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.backgroundColor = .lightGray.withAlphaComponent(0.3)
        sc.selectedSegmentTintColor = .white
        sc.tintColor = .black
        sc.insertSegment(withTitle: "Single Choice", at: 0, animated: true)
        sc.insertSegment(withTitle: "Multiple Choice", at: 1, animated: true)
        sc.insertSegment(withTitle: "True/False", at: 2, animated: true)
        return sc
    }()
    
    private let trueFalseSelector: UISegmentedControl = {
        let sc = UISegmentedControl()
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.backgroundColor = .lightGray.withAlphaComponent(0.3)
        sc.selectedSegmentTintColor = .white
        sc.tintColor = .black
        sc.insertSegment(withTitle: "True", at: 0, animated: true)
        sc.insertSegment(withTitle: "False", at: 1, animated: true)
        sc.isHidden = true
        return sc
    }()
    
    private var questionTextField = NewQuestionCustomTextField(with: "Question")
    private var answer1TextField = NewQuestionCustomTextField(with: "Answer 1")
    private var answer2TextField = NewQuestionCustomTextField(with: "Answer 2")
    private var answer3TextField = NewQuestionCustomTextField(with: "Answer 3")
    private var answer4TextField = NewQuestionCustomTextField(with: "Answer 4")
    
    private let answer1CheckBox = BEMCheckBox()
    private let answer2CheckBox = BEMCheckBox()
    private let answer3CheckBox = BEMCheckBox()
    private let answer4CheckBox = BEMCheckBox()
        
    private var questionType: QuestionType = .singleChoice {
        didSet {
            switch questionType {
            case .singleChoice:
                configureSingleChoiceUI()
                whatToDoLabel.text = "Add a question and select one answer as the correct answer."
            case .multipleChoice:
                configureSingleChoiceUI()
                whatToDoLabel.text = "Add a question and select the correct answers."
            case .TrueFalse:
                whatToDoLabel.text = "Add a question and select true or false as the correct answer."
                configureTrueFalseUI()
            }
        }
    }
    
    private let whatToDoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .headline).bold()
        label.text = "Add a question and select one answer as the correct answer."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        questionTypeSelector.addTarget(self, action: #selector(handleTypeChange), for: .valueChanged)
        questionTypeSelector.selectedSegmentIndex = 0
        navigationController?.navigationBar.tintColor = .black
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        answer1CheckBox.addTarget(self, action: #selector(didTapCheckbox(_:)), for: .valueChanged)
        answer2CheckBox.addTarget(self, action: #selector(didTapCheckbox(_:)), for: .valueChanged)
        answer3CheckBox.addTarget(self, action: #selector(didTapCheckbox(_:)), for: .valueChanged)
        answer4CheckBox.addTarget(self, action: #selector(didTapCheckbox(_:)), for: .valueChanged)
        
        trueFalseSelector.selectedSegmentIndex = 0
        
        setupUI()
    }
    
    // MARK: - Helpers
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(questionTypeSelector)
        view.addSubview(trueFalseSelector)
        view.addSubview(whatToDoLabel)
        
        view.addSubview(questionTextField)
        view.addSubview(answer1TextField)
        view.addSubview(answer2TextField)
        view.addSubview(answer3TextField)
        view.addSubview(answer4TextField)
        
        view.addSubview(answer1CheckBox)
        view.addSubview(answer2CheckBox)
        view.addSubview(answer3CheckBox)
        view.addSubview(answer4CheckBox)
        
        answer1CheckBox.on = true
        
        setupCheckBoxes()
        configureSingleChoiceUI()
        
        NSLayoutConstraint.activate([
            questionTypeSelector.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            questionTypeSelector.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            whatToDoLabel.topAnchor.constraint(equalToSystemSpacingBelow: questionTypeSelector.bottomAnchor, multiplier: 2),
            whatToDoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            whatToDoLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: whatToDoLabel.leadingAnchor, multiplier: 2),
            
            trueFalseSelector.topAnchor.constraint(equalToSystemSpacingBelow: questionTextField.bottomAnchor, multiplier: 2),
            trueFalseSelector.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trueFalseSelector.heightAnchor.constraint(equalTo: questionTextField.heightAnchor, multiplier: 0.75),
            trueFalseSelector.widthAnchor.constraint(equalTo: questionTextField.heightAnchor, multiplier: 2)
        ])
    }
    
    private func setupCheckBoxes() {
        let boxes = [answer1CheckBox, answer2CheckBox, answer3CheckBox, answer4CheckBox]
        for i in 0...boxes.count - 1 {
            boxes[i].translatesAutoresizingMaskIntoConstraints = false
            boxes[i].onAnimationType = .fade
            boxes[i].offAnimationType = .fade
            boxes[i].onTintColor = .greenButton
            boxes[i].tintColor = .greenButton
            boxes[i].onFillColor = .greenButton
            boxes[i].onCheckColor = .white
            boxes[i].animationDuration = 0
            boxes[i].tag = i
        }
    }
    
    private func configureTrueFalseUI() {
        answer1TextField.isHidden = true
        answer2TextField.isHidden = true
        answer3TextField.isHidden = true
        answer4TextField.isHidden = true
        answer1CheckBox.isHidden = true
        answer2CheckBox.isHidden = true
        answer3CheckBox.isHidden = true
        answer4CheckBox.isHidden = true
        trueFalseSelector.isHidden = false
    }
    
    private func configureSingleChoiceUI() {
        trueFalseSelector.isHidden = true
        
        let boxes = [answer1CheckBox, answer2CheckBox, answer3CheckBox, answer4CheckBox]
        let textfields = [answer1TextField, answer2TextField, answer3TextField, answer4TextField]
        
        whatToDoLabel.topAnchor.constraint(equalToSystemSpacingBelow: questionTypeSelector.bottomAnchor, multiplier: 2).isActive = true

        NSLayoutConstraint.activate([
            questionTextField.topAnchor.constraint(equalToSystemSpacingBelow: whatToDoLabel.bottomAnchor, multiplier: 2),
            questionTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.09),
            questionTextField.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: questionTextField.trailingAnchor, multiplier: 2),
        ])
        
        answer1TextField.topAnchor.constraint(equalToSystemSpacingBelow: questionTextField.bottomAnchor, multiplier: 1.5).isActive = true
        
        for i in 0...textfields.count - 1 {
            textfields[i].isHidden = false
            boxes[i].isHidden = false
            if i != 0 {
                textfields[i].topAnchor.constraint(equalToSystemSpacingBelow: textfields[i - 1].bottomAnchor, multiplier: 1).isActive = true
            }
            textfields[i].heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.09).isActive = true
            textfields[i].leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2).isActive = true
            boxes[i].centerYAnchor.constraint(equalTo: textfields[i].centerYAnchor).isActive = true
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: boxes[i].trailingAnchor, multiplier: 2).isActive = true
            boxes[i].heightAnchor.constraint(equalTo: textfields[i].heightAnchor, multiplier: 0.5).isActive = true
            boxes[i].widthAnchor.constraint(equalTo: textfields[i].heightAnchor, multiplier: 0.5).isActive = true
            boxes[i].leadingAnchor.constraint(equalToSystemSpacingAfter: textfields[i].trailingAnchor, multiplier: 2).isActive = true
        }
        
        self.view.layoutSubviews()
        self.view.layoutIfNeeded()
    }
    
    public func createQuestion() -> Question? {
        guard let questionLabel = questionTextField.text, let answer1 = answer1TextField.text, let answer2 = answer2TextField.text, let answer3 = answer3TextField.text, let answer4 = answer4TextField.text else { return nil }
        
        let answers = [answer1, answer2, answer3, answer4]
        let boxes = [answer1CheckBox, answer2CheckBox, answer3CheckBox, answer4CheckBox]
        let selectedBoxes = boxes.filter({ $0.on })
        var correctAnswers: [String] = []
        
        for box in selectedBoxes {
            correctAnswers.append(answers[box.tag])
        }
        
        let question = Question(question: questionLabel, answers: answers, correctAnswers: correctAnswers, type: questionType)
        
        if questionType == .TrueFalse {
            question.answers = []
            question.correctAnswers = [trueFalseSelector.titleForSegment(at: trueFalseSelector.selectedSegmentIndex)!]
        }
        
        return question
    }
    
    public func areQuestionsReady() -> Bool {
        if questionType == .TrueFalse {
            if questionTextField.text!.isEmpty {
                questionTextField.layer.borderColor = UIColor.red.cgColor
                return false
            }
            
            return true
        }
        
        var isReady = true
        let textFields: [UITextField] = [questionTextField, answer1TextField, answer2TextField, answer3TextField, answer4TextField]
        for textField in textFields {
            if textField.text!.isEmpty {
                isReady = false
                textField.layer.borderColor = UIColor.red.cgColor
            } else {
                textField.layer.borderColor = UIColor.systemGray.withAlphaComponent(0.8).cgColor
            }
        }
        
        return isReady
    }
    
    // MARK: - Selectors
    
    @objc private func handleTypeChange() {
        switch questionTypeSelector.selectedSegmentIndex {
        case 0:
            self.questionType = .singleChoice
        case 1:
            self.questionType = .multipleChoice
        case 2:
            self.questionType = .TrueFalse
        default:
            break
        }
    }
    
    @objc private func didTapCheckbox(_ sender: BEMCheckBox) {
        if questionType == .singleChoice {
            let boxes = [answer1CheckBox, answer2CheckBox, answer3CheckBox, answer4CheckBox]
            for box in boxes where box != sender {
                box.on = false
            }
        }
    }
}
