//
//  DatabaseManager.swift
//  Thesis
//
//  Created by István Juhász on 2022. 11. 15..
//

import Foundation
import UIKit
import CoreData

final class DatabaseManager {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getAllItems() -> [ARModel]? {
        do {
            return try context.fetch(ARModel.fetchRequest())
        } catch {
            // error
        }
        return nil
    }
    
    func createItem(name: String, informationText: String, category: String) {
        let newItem = ARModel(context: context)
        newItem.name = name
        newItem.informationText = informationText
        newItem.category = category
            
        do {
            try context.save()
            getAllItems()
        } catch {

        }
    }
//
//    func deleteItem(item: ToDoListItem) {
//        context.delete(item)
//
//        do {
//            try context.save()
//        } catch {
//
//        }
//    }
//
//    func updateItem(item: ToDoListItem, newName: String) {
//        item.name = newName
//        do {
//            try context.save()
//        } catch {
//
//        }
//    }
}
