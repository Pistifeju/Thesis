//
//  Question.swift
//  Thesis
//
//  Created by István Juhász on 2022. 11. 28..
//

class Question {
    var question: String
    var answers: [String]
    
    init(question: String, answers: [String]) {
        self.question = question
        self.answers = answers
    }
    
    init() {
        self.question = ""
        self.answers = []
    }
}
