//
//  QuizSettingsCustomLabel.swift
//  Thesis
//
//  Created by István Juhász on 2023. 01. 31..
//

import UIKit

class QuizSettingsCustomLabel: UILabel {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    init(with text: String) {
        super.init(frame: .zero)
        
        self.text = text
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        textColor = .black
        font = .preferredFont(forTextStyle: .callout).withTraits(traits: .traitItalic)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Selectors
}
