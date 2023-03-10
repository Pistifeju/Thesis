//
//  CompletionStatsView.swift
//  Thesis
//
//  Created by István Juhász on 2023. 03. 07..
//

import Foundation
import UIKit

class CompletionStatsView: UIView {
    
    // MARK: - Properties
    
//    private let completionsCount: Int
//    private let averagePointCount: Float
//    private let percentCount: Float
//    private let avgTimeToCompleteCount: Int
    
    private let completionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Completions"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textAlignment = .center
        return label
    }()
    
    private let completionsNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "27"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textAlignment = .center
        return label
    }()
    
    private let averagePointLabel: UILabel = {
        let label = UILabel()
        label.text = "Points Avg."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textAlignment = .center
        return label
    }()
    
    private let averagePointNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "17,78"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textAlignment = .center
        return label
    }()
    
    private let averagePercentLabel: UILabel = {
        let label = UILabel()
        label.text = "% Avg."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textAlignment = .center
        return label
    }()
    
    private let percentNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "88 %"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textAlignment = .center
        return label
    }()
    
    override var intrinsicContentSize: CGSize {
        layoutSubviews()
        return CGSize(width: UIScreen.main.bounds.width, height: percentNumberLabel.frame.height * 2 + 32)
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        layer.borderWidth = 1
        backgroundColor = .lightCyan
        layer.cornerRadius = 8
        let stackView = UIStackView(arrangedSubviews: [completionsLabel, averagePointLabel, averagePercentLabel])
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        addSubview(stackView)
        addSubview(completionsNumberLabel)
        addSubview(averagePointNumberLabel)
        addSubview(percentNumberLabel)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2),
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2),
            
            completionsNumberLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            completionsNumberLabel.centerXAnchor.constraint(equalTo: completionsLabel.centerXAnchor),
            
            averagePointNumberLabel.centerYAnchor.constraint(equalTo: completionsNumberLabel.centerYAnchor),
            averagePointNumberLabel.centerXAnchor.constraint(equalTo: averagePointLabel.centerXAnchor),
            
            percentNumberLabel.centerYAnchor.constraint(equalTo: completionsNumberLabel.centerYAnchor),
            percentNumberLabel.centerXAnchor.constraint(equalTo: averagePercentLabel.centerXAnchor),
        ])
    }
    
    public func configure(stats: [QuizUserStat]) {
        let percentages = stats.reduce(0) { $0 + $1.percent }
        let points = stats.reduce(0) { $0 + $1.score }
        
        completionsNumberLabel.text = "\(stats.count)"
        averagePointNumberLabel.text = "\(points/Float(stats.count))"
        percentNumberLabel.text = "\(percentages/Float(stats.count)) %"
    }
    
    // MARK: - Selectors
    
}
