//
//  CustomAnswerButton.swift
//  Thesis
//
//  Created by István Juhász on 2022. 12. 03..
//

import UIKit

class CustomAnswerButton: UIButton {
    
    init(answerLabel: String) {
        super.init(frame: .zero)
        setTitleColor(UIColor.black, for: .normal)
        setTitle(answerLabel, for: .normal)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        contentHorizontalAlignment = .left
        layer.cornerRadius = 8
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 2
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
