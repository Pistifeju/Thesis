//
//  Question.swift
//  Thesis
//
//  Created by István Juhász on 2022. 11. 28..
//

enum QuestionType: String, Codable {
    case singleChoice = "SingleChoice"
    case multipleChoice = "MultipleChoice"
    case TrueFalse = "True/False"
}

class Question: Codable {
    var question: String
    var answers: [String]
    var correctAnswers: [String]
    var type: QuestionType
    
    init(question: String, answers: [String], correctAnswers: [String], type: QuestionType) {
        self.question = question
        self.answers = answers
        self.correctAnswers = correctAnswers
        self.type = type
    }
    
    init() {
        self.question = ""
        self.answers = []
        self.correctAnswers = []
        self.type = .singleChoice
    }
}

class AnsweredQuestion: Question {
    var userAnswers: [String]
    
    init(question: String, answers: [String], correctAnswers: [String], type: QuestionType, userAnswers: [String]) {
        self.userAnswers = userAnswers
        super.init(question: question, answers: answers, correctAnswers: correctAnswers, type: type)
    }
    
    init(question: Question, userAnswers: [String]) {
        self.userAnswers = userAnswers
        super.init(question: question.question, answers: question.answers, correctAnswers: question.correctAnswers, type: question.type)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
