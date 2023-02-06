//
//  Question.swift
//  Thesis
//
//  Created by István Juhász on 2022. 11. 28..
//

enum QuestionType: String {
    case singleChoice = "Single Choice"
    case multipleChoice = "Multiple Choice"
    case TrueFalse = "True/False"
}

class Question {
    let question: String
    let answers: [String]
    let type: QuestionType
    
    init(question: String, answers: [String], type: QuestionType) {
        self.question = question
        self.answers = answers
        self.type = type
    }
    
    init() {
        self.question = ""
        self.answers = []
        self.type = .singleChoice
    }
}
