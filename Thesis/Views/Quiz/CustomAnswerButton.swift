//
//  CustomAnswerButton.swift
//  Thesis
//
//  Created by István Juhász on 2022. 12. 03..
//

import UIKit

class CustomAnswerButton: UIButton {
    
    var correctAnswer: Bool? {
        didSet {
            guard let correctAnswer = correctAnswer else { return }
            layer.borderColor = correctAnswer ? UIColor.greenButton.cgColor : UIColor.exitRed.cgColor
        }
    }
    
    override var isSelected: Bool {
        didSet {
            layer.borderColor = isSelected ? UIColor.black.cgColor : UIColor.gray.cgColor
            layer.borderWidth = isSelected ? 3.5 : 2
        }
    }
    
    init(answerLabel: String) {
        super.init(frame: .zero)
        setTitleColor(UIColor.black, for: .normal)
        setTitle(answerLabel, for: .normal)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        contentHorizontalAlignment = .left
        layer.cornerRadius = 8
        layer.borderWidth = 2
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.numberOfLines = 2
        translatesAutoresizingMaskIntoConstraints = false
        isSelected = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
