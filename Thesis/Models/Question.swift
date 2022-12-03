//
//  Question.swift
//  Thesis
//
//  Created by István Juhász on 2022. 11. 28..
//

import Foundation
import RealmSwift

@objcMembers class Question: Object {
    dynamic var question: String = ""
    dynamic var answerIndex: Int = 0
    dynamic var answers: List<String> = List<String>()
    dynamic var selectedIndex: Int = -1
    
    convenience init(question: String, answerIndex: Int, answers: List<String>) {
        self.init()
        self.question = question
        self.answerIndex = answerIndex
        self.answers = answers
    }
}
