//
//  Quiz.swift
//  Thesis
//
//  Created by István Juhász on 2023. 01. 31..
//

struct Quiz {
    var name: String
    var code: String
    var timeToComplete: Int
    var enableARMode: Bool
    var allowViewCompletedTest: Bool
    var questions: [Question]
    
    init(settings: [String: Any], questions: [Question]) {
        self.name = settings["name"] as! String
        self.code = settings["code"] as! String
        self.timeToComplete = settings["timeToComplete"] as! Int
        self.enableARMode = settings["enableARMode"] as! Bool
        self.allowViewCompletedTest = settings["allowViewCompletedTest"] as! Bool
        self.questions = questions
    }
}
