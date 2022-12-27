//
//  ModelInformationButton.swift
//  Thesis
//
//  Created by István Juhász on 2022. 12. 23..
//

import Foundation
import UIKit

class ModelInformationButton: UIButton {
    convenience init(title: String, type: UIButton.ButtonType = .system) {
        self.init(type: type)
        layer.opacity = 0.7
        tintColor = .white
        backgroundColor = .clear
        setTitleColor(UIColor.white, for: .normal)
        setTitle(title, for: .normal)
        titleLabel!.font = UIFont.preferredFont(forTextStyle: .subheadline)
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.lineBreakMode = .byWordWrapping
        titleLabel?.textAlignment = .center
    }
}
