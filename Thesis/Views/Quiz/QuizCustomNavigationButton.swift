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
        backgroundColor = UIColor(red: 1/255, green: 130/255, blue: 110/255, alpha: 1)
        layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    // MARK: - Selectors
    
}
