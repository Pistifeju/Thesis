//
//  QuizService.swift
//  Thesis
//
//  Created by István Juhász on 2023. 01. 31..
//

import FirebaseFirestore

class QuizService {
    
    public static let shared = QuizService()
    private init() {}
    private let db = Firestore.firestore()
    
    public func uploadNewQuiz(quiz: Quiz, completion: @escaping(Error?) -> Void) {
        var questions: [[String: String]] = []
        
        for question in quiz.questions {
            let questionMap = [
                "question": question.question,
                "answer1": question.answers[0],
                "answer2": question.answers[1],
                "answer3": question.answers[2],
                "answer4": question.answers[3]
            ]
            questions.append(questionMap)
        }
        
        let data: [String: Any] = [
            "name": quiz.name,
            "code": quiz.code,
            "timeToComplete": quiz.timeToComplete,
            "allowARMode": quiz.enableARMode,
            "allowViewCompletedTest": quiz.allowViewCompletedTest,
            "questions": questions]
        
        Firestore.firestore().collection("quizzes").addDocument(data: data) { error in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
}
