//
//  Quiz.swift
//  Thesis
//
//  Created by István Juhász on 2023. 01. 31..
//

struct Quiz {
    var settings: QuizSettings
    var questions: [Question]
    
    init(settings: QuizSettings, questions: [Question]) {
        self.settings = settings
        self.questions = questions
    }
}

struct QuizSettings {
    var name: String
    var code: String
    var timeToComplete: Int
    var enableARMode: Bool
    var allowViewCompletedTest: Bool
    
    init(name: String, code: String, timeToComplete: Int, enableARMode: Bool, allowViewCompletedTest: Bool) {
        self.name = name
        self.code = code
        self.timeToComplete = timeToComplete
        self.enableARMode = enableARMode
        self.allowViewCompletedTest = allowViewCompletedTest
    }
}
