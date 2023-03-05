//
//  ProfileQuizCollectionViewCell.swift
//  Thesis
//
//  Created by István Juhász on 2023. 03. 04..
//

import Foundation
import UIKit

class ProfileQuizCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "ProfileQuizCollectionViewCell"
    
    public var completedQuiz: CompletedQuiz?
    
    public var quizLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "Laryngel quiz 01"
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    public var scoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "Score\n12/15"
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        quizLabel.text = nil
        scoreLabel.text = nil
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        contentView.addSubview(quizLabel)
        contentView.addSubview(scoreLabel)
        
        contentView.backgroundColor = .lightCyan
        contentView.layer.cornerRadius = 12
        
        NSLayoutConstraint.activate([
            quizLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            quizLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.47),
            quizLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2),
            
            scoreLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            quizLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.47),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: scoreLabel.trailingAnchor, multiplier: 2),
        ])
    }
    
    public func configure(with quiz: CompletedQuiz) {
        self.completedQuiz = quiz
        quizLabel.text = quiz.name
        scoreLabel.text = "Score:\n\(quiz.score)/\(quiz.answeredQuestions.count)"
    }
    
    // MARK: - Selectors
    
}
