//
//  DatabaseManager.swift
//  Thesis
//
//  Created by István Juhász on 2022. 11. 15..
//

import Foundation
import UIKit
import RealmSwift

final class DatabaseManager {
    static func deleteAll() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    static func loadData() {
        let skeletalModels: [AnatomyModel] = []
        
        let skeletalSystem: [[String]] = [
            ["Laryngeal", "This is the Laryngeal."],
            ["Chest", "This is the Chest."],
            ["Skull", "This is the Skull."],
            ["Arm", "This is the Arm."],
            ["Foot", "This is the Foot."],
            ["Hand", "This is the Hand."],
            ["Leg", "This is the Leg."],
            ["PelvicGirdle", "This is the PelvicGirdle."],
            ["ShoulderGirdle", "This is the ShoulderGirdle."],
            ["VertebralColumn", "This is the VertebralColumn."],
        ]
        
        let answers: [[String]] = [
            ["1", "2", "3", "nullaaaa"],
            ["nem tom", "esku nem", "nem", "be"],
            ["mert be szartam", "nem is az", "sabaton", "miiii"],
            ["nem mondom el", "mert nem jarok orara", "temi anyja miatt", "meguntam"],
        ]
        
        let skeletalQuestions: [Question] = [
            Question(question: "Hany fogad van?", answerIndex: 0, answers: List<String>()),
            Question(question: "be szartal?", answerIndex: 3, answers: List<String>()),
            Question(question: "miert fosos a gatyad", answerIndex: 0, answers: List<String>()),
            Question(question: "miert fogsz bukni falmaszasbol", answerIndex: 1, answers: List<String>()),
        ]
        
        for i in 0...skeletalQuestions.count-1 {
            let innerAnswers: List<String> = List<String>()
            innerAnswers.append(objectsIn: answers[i])
            skeletalQuestions[i].answers = innerAnswers
        }
        
        let realm = try! Realm()
                
        skeletalSystem.forEach { system in
            let innerQuestions = List<Question>()
            innerQuestions.append(objectsIn: skeletalQuestions)
            let anatomyModel = AnatomyModel(name: system[0], informationText: system[1], category: "skeletal", questions: innerQuestions)
            realm.beginWrite()
            realm.add(anatomyModel)
            try! realm.commitWrite()
        }
    }
    
}
