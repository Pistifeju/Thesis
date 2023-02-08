//
//  EndOfQuizStatLabel.swift
//  Thesis
//
//  Created by István Juhász on 2023. 02. 09..
//

import UIKit

class EndOfQuizStatLabel: UILabel {
    init(text: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.text = text
        textColor = .gray
        font = UIFont.preferredFont(forTextStyle: .title3)
        numberOfLines = 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
