//
//  ProfileCompletedQuizCollectionViewCell.swift
//  Thesis
//
//  Created by István Juhász on 2023. 03. 04..
//

import Foundation
import UIKit

class ProfileCompletedQuizCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "ProfileQuizCollectionViewCell"
    
    public var completedQuiz: CompletedQuiz?
    
    public var quizLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "Laryngel quiz 01"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    public var scoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "Score: 12/15"
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textAlignment = .center
        return label
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "square.and.pencil"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .black
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        return iv
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
        contentView.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .lightCyan
        contentView.addSubview(quizLabel)
        contentView.addSubview(scoreLabel)
        
        let stackView = UIStackView(arrangedSubviews: [quizLabel, scoreLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.axis = .vertical
        contentView.addSubview(stackView)
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.trailingAnchor.constraint(equalToSystemSpacingAfter: imageView.leadingAnchor, multiplier: -2),
            
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: imageView.trailingAnchor, multiplier: 2),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
        ])
    }
    
    public func configure(with quiz: CompletedQuiz) {
        self.completedQuiz = quiz
        quizLabel.text = quiz.name
        scoreLabel.text = "Score: \(quiz.score)/\(quiz.answeredQuestions.count)"
    }
    
    // MARK: - Selectors
    
}
