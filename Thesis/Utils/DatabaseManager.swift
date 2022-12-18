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
        deleteAll()
        
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
            ["igen", "nem tudom", "nem", "ki tudja"],
            ["0", "20", "4", "sok"],
            ["van", "nincs", "nem mondom el", "ki tudja?"],
            ["Errol en semmit sem tudok sajnos.", "nincs annyi ido amennyi alatt el lehetne donteni", "feladom.", "hello there"],
        ]
        
        let skeletalQuestions: [Question] = [
            Question(question: "Ez egy teszt kerdes?", answerIndex: 0, answers: List<String>()),
            Question(question: "Hany teszt kerdes lesz ebben a kerdessorban?", answerIndex: 2, answers: List<String>()),
            Question(question: "Mutasd meg, hogy a kovetkezo problema NL-beli: input egy G (iranyitatlan) graf, van-e benne 10-elemu lefogo csucshalmaz?", answerIndex: 0, answers: List<String>()),
            Question(question: "Az A eldöntési problémáról azt tudjuk, hogy logaritmikus tárban visszavezehető egy olyan B eldöntési problémára, mely eldönthető n^5 időben determinisztikusan. Mit tudunk ekkor, A milyen (tár és/vagy idő)korlátban dönthető el biztosan?", answerIndex: 1, answers: List<String>()),
        ]
        
        for i in 0...skeletalQuestions.count-1 {
            let innerAnswers: List<String> = List<String>()
            innerAnswers.append(objectsIn: answers[i])
            skeletalQuestions[i].answers = innerAnswers
        }
        
//        do {
//            // Delete the realm if a migration would be required, instead of migrating it.
//            // While it's useful during development, do not leave this set to `true` in a production app!
//            let configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
//            let realm = try Realm(configuration: configuration)
//        } catch {
//            print("Error opening realm: \(error.localizedDescription)")
//        }
            
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
