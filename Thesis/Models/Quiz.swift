//
//  Quiz.swift
//  Thesis
//
//  Created by István Juhász on 2023. 01. 31..
//

struct Quiz: Codable { 
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

struct CompletedQuiz: Codable {
    var name: String
    var code: String
    var quizDescription: String
    var allowViewCompletedTest: Bool
    var answeredQuestions: [AnsweredQuestion]
    var timeToComplete: Int
    var score: Float
    
    public func calculateScore() -> Float {
        var score: Float = 0
        
        for question in answeredQuestions {
            let correctAnswers = question.correctAnswers
            let userAnswers = question.userAnswers
            
            switch question.type {
            case .singleChoice:
                if userAnswers == correctAnswers {
                    score += 1
                }
            case .multipleChoice:
                var multipleChoiceScore = 0.0
                
                if userAnswers == correctAnswers {
                    multipleChoiceScore = 1
                } else if !correctAnswers.isEmpty && userAnswers.isEmpty {
                    multipleChoiceScore = 0
                } else {
                    for userAnswer in userAnswers {
                        if correctAnswers.contains(userAnswer) {
                            multipleChoiceScore += 0.25
                        } else {
                            multipleChoiceScore -= 0.25
                        }
                    }
                }
                
                score += Float(max(multipleChoiceScore, 0.0))
            case .TrueFalse:
                if userAnswers == correctAnswers {
                    score += 1
                }
            }
        }
        
        return score
    }
    
    var percent: Float {
        return (self.score / Float(answeredQuestions.count)) * 100.0
    }
    
    init(settings: [String: Any], answeredQuestions: [AnsweredQuestion]) {
        self.name = settings["name"] as! String
        self.quizDescription = settings["quizDescription"] as! String
        self.allowViewCompletedTest = settings["allowViewCompletedTest"] as! Bool
        self.answeredQuestions = answeredQuestions
        self.timeToComplete = settings["timeToComplete"] as! Int
        self.code = settings["code"] as! String
        if let score = settings["score"] {
            self.score = score as! Float
        } else {
            self.score = -1
        }
        
    }
}
