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
    
    /// A method to upload a new quiz to firebase firestore.
    /// - Parameters:
    ///   - quiz: The quiz which will be uploaded.
    ///   - completion: A completion with one value (Error?).
    ///   - Error?: An optinal error coming from firebase.
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
    
    /// A method to fetch every quiz from firebase firestore.
    /// - Parameter completion: A completion with two value ([Quiz]?, Error?).
    /// - [Quiz]?: An optinal quiz array coming from firebase.
    /// - Error?: An optinal error coming from firebase.
    public func fetchAllQuizzes(completion: @escaping([Quiz]?, Error?) -> Void) {
        var quizzes = [Quiz]()
//        let query = Firestore.firestore().collection("quizzes")
        
        Firestore.firestore().collection("quizzes").getDocuments { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let snapshot = snapshot else { return }
                        
            snapshot.documents.forEach { document in
                let data = document.data()
                let settings = self.createSettings(data: data)
                
                let questionsAsData = data["questions"] as! [[String: Any]]
                let questions = self.createQuestions(questionsAsData: questionsAsData)
                
                let quiz = Quiz(settings: settings, questions: questions)
                
                quizzes.append(quiz)
            }
            
            completion(quizzes, nil)
        }
    }
    
    /// A method to fetch a quiz from firebase firestore.
    /// - Parameters:
    ///   - code: The code of the quiz which should be fetched.
    ///   - completion: A completion with two value (Quiz?, Error?).
    /// - Quiz?: An optinal quiz coming from firebase.
    /// - Error?: An optinal error coming from firebase.
    public func fetchQuiz(with code: String, completion: @escaping(Quiz?, Error?) -> Void) {
        Firestore.firestore().collection("quizzes").whereField("code", isEqualTo: code).getDocuments { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let snapshot = snapshot {
                if snapshot.documents.isEmpty {
                    completion(nil, nil)
                    return
                }
                let data = snapshot.documents[0].data()
                
                let settings = self.createSettings(data: data)
                
                let questionsAsData = data["questions"] as! [[String: Any]]
                let questions = self.createQuestions(questionsAsData: questionsAsData)
                
                let quiz = Quiz(settings: settings, questions: questions)
                
                completion(quiz, nil)
            }
            
            completion(nil, nil)
            return
        }
    }
}

extension QuizService {
    private func createQuestions(questionsAsData: [[String: Any]]) -> [Question] {
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
        
        return questions
    }
    
    private func createSettings(data: [String: Any]) -> [String: Any]{
        let settings: [String: Any] = [
            "name": data["name"] as Any,
            "code": data["code"] as Any,
            "quizDescription": data["quizDescription"] as Any,
            "timeToComplete": data["timeToComplete"] as Any,
            "allowARMode": data["allowARMode"] as Any,
            "allowViewCompletedTest": data["allowViewCompletedTest"] as Any]
        
        return settings
    }
}
