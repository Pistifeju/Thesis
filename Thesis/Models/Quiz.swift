//
//  Quiz.swift
//  Thesis
//
//  Created by István Juhász on 2023. 01. 31..
//

struct Quiz {
    var name: String
    var code: String
    var quizDescription: String
    var timeToComplete: Int
    var allowARMode: Bool
    var allowViewCompletedTest: Bool
    var questions: [Question]
    var model: String
    
    init(settings: [String: Any], questions: [Question]) {
        self.name = settings["name"] as! String
        self.code = settings["code"] as! String
        self.quizDescription = settings["quizDescription"] as! String
        self.model = settings["model"] as! String
        self.timeToComplete = settings["timeToComplete"] as! Int
        self.allowARMode = settings["allowARMode"] as! Bool
        self.allowViewCompletedTest = settings["allowViewCompletedTest"] as! Bool
        self.questions = questions
    }
}
