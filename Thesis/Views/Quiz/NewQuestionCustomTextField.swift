//
//  NewQuestionCustomTextField.swift
//  Thesis
//
//  Created by István Juhász on 2023. 01. 27..
//

import UIKit

class NewQuestionCustomTextField: UITextField {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    init(with holder: String) {
        super.init(frame: .zero)
        
        configureUI(placeholder: holder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI(placeholder: String) {
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.systemGray])
        backgroundColor = .white
        layer.borderColor = UIColor.systemGray.withAlphaComponent(0.8).cgColor
        layer.borderWidth = 2
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 12
        returnKeyType = .done
        autocorrectionType = .no
        textColor = .black
        leftViewMode = .always
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 1))
    }
    
    // MARK: - Selectors
}
