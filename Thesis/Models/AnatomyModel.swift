//
//  AnatomyModel.swift
//  Thesis
//
//  Created by István Juhász on 2022. 11. 28..
//

import Foundation

struct AnatomyModel {
    var name: String
    var informationText: String
    var questions: [Question]
    var category: String
    
    init(name: String, informationText: String, category: String, questions: [Question]) {
        self.name = name
        self.informationText = "This is the " + informationText
        self.questions = questions
        self.category = category
    }
}
