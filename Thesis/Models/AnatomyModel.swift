//
//  AnatomyModel.swift
//  Thesis
//
//  Created by István Juhász on 2022. 11. 28..
//

import Foundation
import RealmSwift

//This represents the AnatomyModel in Realm
@objcMembers class AnatomyModel: Object {
    dynamic var name: String?
    dynamic var informationText: String?
    dynamic var questions: List<Question> = List<Question>()
    dynamic var category: String?
    
    convenience init(name: String, informationText: String, category: String, questions: List<Question>) {
        self.init()
        self.name = name
        self.informationText = informationText
        self.category = category
        self.questions = questions
    }
}

// MARK: - CRUD methods

extension AnatomyModel {

  
  
}
