//
//  QuizCustomNavigationButton.swift
//  Thesis
//
//  Created by István Juhász on 2023. 02. 02..
//

import UIKit

class QuizCustomNavigationButton: UIButton {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    init(title: String) {
        super.init(frame: .zero)
        super.setTitle(title, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        setTitleColor(.white, for: .normal)
        setTitleColor(UIColor.init(white: 1, alpha: 0.3), for: .highlighted)
        backgroundColor = .greenButton
        layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    // MARK: - Selectors
    
}
