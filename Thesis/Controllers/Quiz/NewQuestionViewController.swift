//
//  NewQuestionViewController.swift
//  Thesis
//
//  Created by István Juhász on 2023. 01. 29..
//

import UIKit

class NewQuestionViewController: UIViewController {
    
    // MARK: - Properties
    
    private var answerLabels: [UILabel] = []
    private var questionTextField = NewQuestionCustomTextField(with: "Question")
    private var answer1TextField = NewQuestionCustomTextField(with: "Answer 1")
    private var answer2TextField = NewQuestionCustomTextField(with: "Answer 2")
    private var answer3TextField = NewQuestionCustomTextField(with: "Answer 3")
    private var answer4TextField = NewQuestionCustomTextField(with: "Answer 4")
    
    private let mainTitle: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .headline).bold()
        label.text = "Add a question and answer options"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: - Helpers
    private func setupUI() {
        self.view.backgroundColor = .white
        
        view.addSubview(mainTitle)
        view.addSubview(questionTextField)
        view.addSubview(answer1TextField)
        view.addSubview(answer2TextField)
        view.addSubview(answer3TextField)
        view.addSubview(answer4TextField)
        generateAnswerLabels()
        
        NSLayoutConstraint.activate([
            mainTitle.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1),
            mainTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            questionTextField.topAnchor.constraint(equalToSystemSpacingBelow: mainTitle.bottomAnchor, multiplier: 2),
            questionTextField.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: questionTextField.trailingAnchor, multiplier: 2),
            
            questionTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.09),
            answer1TextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.09),
            answer2TextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.09),
            answer3TextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.09),
            answer4TextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.09),
            
            answer1TextField.topAnchor.constraint(equalToSystemSpacingBelow: questionTextField.bottomAnchor, multiplier: 1.5),
            answer1TextField.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: answer1TextField.trailingAnchor, multiplier: 2),
            answerLabels[0].topAnchor.constraint(equalToSystemSpacingBelow: answer1TextField.bottomAnchor, multiplier: 0.5),
            
            answer2TextField.topAnchor.constraint(equalToSystemSpacingBelow: answerLabels[0].bottomAnchor, multiplier: 1),
            answer2TextField.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: answer2TextField.trailingAnchor, multiplier: 2),
            answerLabels[1].topAnchor.constraint(equalToSystemSpacingBelow: answer2TextField.bottomAnchor, multiplier: 0.5),
            
            answer3TextField.topAnchor.constraint(equalToSystemSpacingBelow: answerLabels[1].bottomAnchor, multiplier: 1),
            answer3TextField.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: answer3TextField.trailingAnchor, multiplier: 2),
            answerLabels[2].topAnchor.constraint(equalToSystemSpacingBelow: answer3TextField.bottomAnchor, multiplier: 0.5),
            
            answer4TextField.topAnchor.constraint(equalToSystemSpacingBelow: answerLabels[2].bottomAnchor, multiplier: 1),
            answer4TextField.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: answer4TextField.trailingAnchor, multiplier: 2),
            answerLabels[3].topAnchor.constraint(equalToSystemSpacingBelow: answer4TextField.bottomAnchor, multiplier: 0.5),
        ])
    }
    
    private func generateAnswerLabels() {
        for _ in 0...3 {
            let label = UILabel(frame: .zero)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Incorrect Answer"
            label.font = UIFont.preferredFont(forTextStyle: .callout).withTraits(traits: .traitItalic)
            label.textColor = .black
            answerLabels.append(label)
            view.addSubview(label)
            label.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2).isActive = true
        }
        answerLabels[0].text = "Correct Answer"
    }
    
    // MARK: - Selectors
}
