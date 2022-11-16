//
//  ARModel+CoreDataProperties.swift
//  Thesis
//
//  Created by István Juhász on 2022. 11. 15..
//
//

import Foundation
import CoreData


extension ARModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ARModel> {
        return NSFetchRequest<ARModel>(entityName: "ARModel")
    }

    @NSManaged public var name: String?
    @NSManaged public var informationText: String?
    @NSManaged public var category: String?

}

extension ARModel : Identifiable {

}
