//
//  CustomAnswerButton.swift
//  Thesis
//
//  Created by István Juhász on 2022. 12. 03..
//

import UIKit

class CustomAnswerButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            let green = UIColor(red: 1/255, green: 130/255, blue: 110/255, alpha: 1).cgColor
            layer.borderColor = isSelected ? green : UIColor.gray.cgColor
            layer.borderWidth = isSelected ? 3 : 2
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
        translatesAutoresizingMaskIntoConstraints = false
        isSelected = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
