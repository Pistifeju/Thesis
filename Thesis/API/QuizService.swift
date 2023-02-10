//
//  QuizService.swift
//  Thesis
//
//  Created by István Juhász on 2023. 01. 31..
//

import FirebaseFirestore
import FirebaseAuth

class QuizService {
    
    public static let shared = QuizService()
    private init() {}
    private let db = Firestore.firestore()
    
    /// A method to upload a newly created quiz to firebase firestore.
    /// - Parameters:
    ///   - quiz: The quiz which will be uploaded.
    ///   - completion: A completion with one value (Error?).
    ///   - Error?: An optinal error coming from firebase.
    public func uploadNewQuiz(quiz: Quiz, completion: @escaping(Error?) -> Void) {
        var questions: [[String: Any]] = []
        
        for question in quiz.questions {

            let questionMap: [String: Any] = [
                "question": question.question,
                "answers": question.answers,
                "correctAnswers": question.correctAnswers,
                "type": question.type.rawValue
            ]

            questions.append(questionMap)
        }
        
        let data: [String: Any] = [
            "name": quiz.name,
            "code": quiz.code,
            "model": quiz.model,
            "quizDescription": quiz.quizDescription,
            "timeToComplete": quiz.timeToComplete,
            "allowARMode": quiz.allowARMode,
            "allowViewCompletedTest": quiz.allowViewCompletedTest,
            "questions": questions]
                
        let ref = Firestore.firestore().collection("quizzes").addDocument(data: data) { error in
            if let error = error {
                completion(error)
                return
            }
        }
        
        let refID = ref.documentID
        
        let userID = Auth.auth().currentUser?.uid
        guard let id = userID else {
            return
        }
        
        Firestore.firestore().collection("users").document(id).collection("quizCreated").document(refID).setData([:]) { error in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
            return
        }
    }
    
    /// A method to fetch every quiz from firebase firestore.
    /// - Parameter completion: A completion with two value ([Quiz]?, Error?).
    /// - [Quiz]?: An optinal quiz array coming from firebase.
    /// - Error?: An optinal error coming from firebase.
    public func fetchAllQuizzes(completion: @escaping([Quiz]?, Error?) -> Void) {
        var quizzes = [Quiz]()
        
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
    public func fetchQuiz(with code: String, completion: @escaping(Quiz?, String?, Error?) -> Void) {
        Firestore.firestore().collection("quizzes").whereField("code", isEqualTo: code).getDocuments { snapshot, error in
            if let error = error {
                completion(nil, nil, error)
                return
            }
            
            guard let snapshot = snapshot, !snapshot.documents.isEmpty else {
                completion(nil, nil, nil)
                return
            }
            
            let data = snapshot.documents[0].data()
            let quizID = snapshot.documents[0].documentID
            
            let settings = self.createSettings(data: data)
            
            let questionsAsData = data["questions"] as! [[String: Any]]
            let questions = self.createQuestions(questionsAsData: questionsAsData)
            
            let quiz = Quiz(settings: settings, questions: questions)
            
            completion(quiz, quizID, nil)
        }
    }
    
    public func uploadFinishingQuiz(user: User, quizID: String, completedQuiz: CompletedQuiz, completion: @escaping(Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("quizzes").document(quizID).collection("quizTakenBy").document(uid).setData(["username": user.username, "score": completedQuiz.score, "percent": completedQuiz.percent]) { error in
            if let error = error {
                completion(error)
                return
            }
            
            var questions: [[String: Any]] = []
            
            for completedQuestion in completedQuiz.answeredQuestions {

                let questionMap: [String: Any] = [
                    "question": completedQuestion.question,
                    "answers": completedQuestion.answers,
                    "userAnswers": completedQuestion.userAnswers,
                    "correctAnswers": completedQuestion.correctAnswers,
                    "type": completedQuestion.type.rawValue
                ]

                questions.append(questionMap)
            }
            
            let completedQuizData: [String: Any] = [
                "name": completedQuiz.name,
                "quizDescription": completedQuiz.quizDescription,
                "allowViewCompletedTest": completedQuiz.allowViewCompletedTest,
                "questions": questions]
            
            Firestore.firestore().collection("users").document(uid).collection("takenQuizzes").document(quizID).setData(completedQuizData) { error in
                if let error = error {
                    completion(error)
                    return
                }
                
                completion(nil)
                return
            }
        }
    }
}

extension QuizService {
    private func createQuestions(questionsAsData: [[String: Any]]) -> [Question] {
        var questions: [Question] = []
        
        for question in questionsAsData {
            let answers: [String] = question["answers"] as! [String]
            let questionText: String = question["question"] as! String
            let type: String = question["type"] as! String
            let correctAnswers: [String] = question["correctAnswers"] as! [String]

            let innerQuestion = Question(question: questionText, answers: answers, correctAnswers: correctAnswers, type: QuestionType(rawValue: type) ?? .singleChoice)
            questions.append(innerQuestion)
        }
        
        return questions
    }
    
    private func createSettings(data: [String: Any]) -> [String: Any]{
        let settings: [String: Any] = [
            "name": data["name"] as Any,
            "code": data["code"] as Any,
            "model": data["model"] as Any,
            "quizDescription": data["quizDescription"] as Any,
            "timeToComplete": data["timeToComplete"] as Any,
            "allowARMode": data["allowARMode"] as Any,
            "allowViewCompletedTest": data["allowViewCompletedTest"] as Any]
        
        return settings
    }
}
