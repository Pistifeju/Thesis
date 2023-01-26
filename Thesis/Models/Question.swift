//
//  Question.swift
//  Thesis
//
//  Created by István Juhász on 2022. 11. 28..
//

class Question {
    var question: String
    var answerIndex: Int
    var answers: [String]
    var selectedIndex: Int
    
    init(question: String, answerIndex: Int, answers: [String]) {
        self.selectedIndex = -1
        self.question = question
        self.answerIndex = answerIndex
        self.answers = answers
    }
    
    init() {
        self.question = ""
        self.selectedIndex = -1
        self.answers = []
        self.answerIndex = 0
    }
}
