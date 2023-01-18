//
//  CustomAuthButton.swift
//  Thesis
//
//  Created by István Juhász on 2023. 01. 17..
//

import UIKit

enum FontSize {
    case big
    case medium
    case small
}

class CustomAuthButton: UIButton {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    init(title: String, hasBackground: Bool = false, fontSize: FontSize) {
        super.init(frame: .zero)
        super.setTitle(title, for: .normal)
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = hasBackground ? UIColor.systemBlue : UIColor.clear
        
        let titleColor = hasBackground ? UIColor.white : UIColor.systemBlue
        self.setTitleColor(titleColor, for: .normal)
        
        switch fontSize {
        case .big:
            self.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        case .medium:
            self.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        case .small:
            self.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .green
        
    }
    
    // MARK: - Selectors
    
}
