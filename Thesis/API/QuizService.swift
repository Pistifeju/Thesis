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
            "quizDescription": quiz.quizDescription,
            "timeToComplete": quiz.timeToComplete,
            "allowARMode": quiz.allowARMode,
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
    
    public func fetchAllQuizzes(completion: @escaping([Quiz]?, Error?) -> Void) {
        var quizzes = [Quiz]()
        let query = Firestore.firestore().collection("quizzes")

        query.addSnapshotListener { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
                        
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let data = change.document.data()
                    
                    let settings: [String: Any] = [
                        "name": data["name"] as Any,
                        "code": data["code"] as Any,
                        "quizDescription": data["quizDescription"] as Any,
                        "timeToComplete": data["timeToComplete"] as Any,
                        "allowARMode": data["allowARMode"] as Any,
                        "allowViewCompletedTest": data["allowViewCompletedTest"] as Any]
                    
                    let questionsAsData = data["questions"] as! [[String: Any]]
                    var questions: [Question] = []
                    
                    for question in questionsAsData {
                        let answers = [
                            question["answer1"] as! String,
                            question["answer2"] as! String,
                            question["answer3"] as! String,
                            question["answer4"] as! String,
                        ]
                        let innerQuestion = Question(question: question["question"] as! String, answers: answers)
                        questions.append(innerQuestion)
                    }
                    
                    let quiz = Quiz(settings: settings, questions: questions)
                                        
                    quizzes.append(quiz)
                }
            })
            
            completion(quizzes, nil)
        }
    }
}
