//
//  PopUpViewButton.swift
//  Thesis
//
//  Created by István Juhász on 2023. 01. 25..
//

import UIKit

class PopUpViewButton: UIButton {
    init(with title: String) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        setTitle(title, for: .normal)
        self.setTitleColor(.black, for: .normal)
        self.layer.cornerRadius = 12
        if title == "Start" {
            self.backgroundColor = UIColor(red: 162/255, green: 210/255, blue: 255/255, alpha: 1)
        } else {
            self.backgroundColor = UIColor(red: 255/255, green: 175/255, blue: 204/255, alpha: 1)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
