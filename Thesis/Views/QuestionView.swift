//
//  QuestionView.swift
//  Thesis
//
//  Created by István Juhász on 2022. 12. 03..
//

import UIKit
import RealmSwift

protocol QuestionViewDelegate: AnyObject {
    func didSelectAnswer(with question: Question)
    func didUnselectAnswer(with question: Question)
}

class QuestionView: UICollectionViewCell {
    
    // MARK: - Properties
    
    private var answeredQuestion: Bool = false
    
    weak var delegate: (QuestionViewDelegate)?
    
    private var question: Question {
        didSet {
            questionLabel.text = question.question
            answerButton1.setTitle(question.answers[0], for: .normal)
            answerButton2.setTitle(question.answers[1], for: .normal)
            answerButton3.setTitle(question.answers[2], for: .normal)
            answerButton4.setTitle(question.answers[3], for: .normal)
        }
    }
    
    private lazy var answerButton1: CustomAnswerButton = {
        let button = CustomAnswerButton(answerLabel: "")
        button.addTarget(self, action: #selector(didTapAnswerButton), for: .touchUpInside)
        button.titleLabel?.numberOfLines = 0
        button.tag = 0
        
        return button
    }()
    
    private lazy var answerButton2: CustomAnswerButton = {
        let button = CustomAnswerButton(answerLabel: "")
        button.addTarget(self, action: #selector(didTapAnswerButton), for: .touchUpInside)
        button.titleLabel?.numberOfLines = 0
        button.tag = 1
        
        return button
    }()
    
    private lazy var answerButton3: CustomAnswerButton = {
        let button = CustomAnswerButton(answerLabel: "")
        button.addTarget(self, action: #selector(didTapAnswerButton), for: .touchUpInside)
        button.titleLabel?.numberOfLines = 0
        button.tag = 2
        
        return button
    }()
    
    private lazy var answerButton4: CustomAnswerButton = {
        let button = CustomAnswerButton(answerLabel: "")
        button.addTarget(self, action: #selector(didTapAnswerButton), for: .touchUpInside)
        button.titleLabel?.numberOfLines = 0
        button.tag = 3
        
        return button
    }()
    
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.heightAnchor.constraint(equalToConstant: 100).isActive = true
        label.allowsDefaultTighteningForTruncation = true
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        self.question = Question()
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        answerButton1.backgroundColor = .white
        answerButton2.backgroundColor = .white
        answerButton3.backgroundColor = .white
        answerButton4.backgroundColor = .white
        
        answerButton1.isSelected = false
        answerButton2.isSelected = false
        answerButton3.isSelected = false
        answerButton4.isSelected = false
    }
    
    // MARK: - Helpers
    
    private func configureUI() {        
        let stackView = UIStackView(arrangedSubviews: [answerButton1, answerButton2, answerButton3, answerButton4])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        
        addSubview(questionLabel)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),
            questionLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 0),
            trailingAnchor.constraint(equalToSystemSpacingAfter: questionLabel.trailingAnchor, multiplier: 0),
            
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 0),
            trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 0),

            stackView.topAnchor.constraint(equalToSystemSpacingBelow: questionLabel.bottomAnchor, multiplier: 2),
            bottomAnchor.constraint(equalToSystemSpacingBelow: stackView.bottomAnchor, multiplier: 2),
        ])
    }
    
    public func configure(with question: Question) {
        self.question = question
        switch question.selectedIndex {
        case 0:
            answerButton1.backgroundColor = UIColor(red: 162/255, green: 210/255, blue: 255/255, alpha: 1)
            answerButton1.isSelected = true
        case 1:
            answerButton2.backgroundColor = UIColor(red: 162/255, green: 210/255, blue: 255/255, alpha: 1)
            answerButton2.isSelected = true
        case 2:
            answerButton3.backgroundColor = UIColor(red: 162/255, green: 210/255, blue: 255/255, alpha: 1)
            answerButton3.isSelected = true
        case 3:
            answerButton4.backgroundColor = UIColor(red: 162/255, green: 210/255, blue: 255/255, alpha: 1)
            answerButton4.isSelected = true
        default:
            break
        }
    }
    
    // MARK: - Selectors
    
    @objc private func didTapAnswerButton(_ sender: UIButton) {
        
        let realm = try! Realm()
        
        answerButton1.backgroundColor = .white
        answerButton2.backgroundColor = .white
        answerButton3.backgroundColor = .white
        answerButton4.backgroundColor = .white
        
        if(sender.isSelected) {
            //unselect
            sender.isSelected = false
            try! realm.write {
                question.selectedIndex = -1
            }
            delegate?.didUnselectAnswer(with: question)
        } else {
            if(answerButton1.isSelected || answerButton2.isSelected || answerButton3.isSelected || answerButton4.isSelected) {
                delegate?.didUnselectAnswer(with: question)
            }
            answerButton1.isSelected = false
            answerButton2.isSelected = false
            answerButton3.isSelected = false
            answerButton4.isSelected = false
            sender.isSelected = true
            sender.backgroundColor = UIColor(red: 162/255, green: 210/255, blue: 255/255, alpha: 1)
            try! realm.write {
                question.selectedIndex = sender.tag
            }
            delegate?.didSelectAnswer(with: question)
        }
    }
}
