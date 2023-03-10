//
//  CompletionsStatsUITableViewCell.swift
//  Thesis
//
//  Created by István Juhász on 2023. 03. 10..
//

import Foundation
import UIKit

class CompletionsStatsUITableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "CompletionsStatsUITableViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        return label
    }()
    
    private let statsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(statsLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            statsLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: statsLabel.trailingAnchor, multiplier: 2),
        ])
    }
    
    public func configure(stats: QuizUserStat) {
        nameLabel.text = stats.name
        statsLabel.text = "\(stats.score) p.(\(stats.percent)%)"
    }
    
    // MARK: - Selectors
    
}

