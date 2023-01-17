//
//  AnatomyModel.swift
//  Thesis
//
//  Created by István Juhász on 2022. 11. 28..
//

//This represents the AnatomyModel in UserDefaults
struct AnatomyModel: Codable {
    var name: String?
    var informationText: String?
    var category: String?
    var subModels: [String: String]?
    
    init() {}
    
    init(name: String, informationText: String, category: String) {
        self.name = name
        self.informationText = informationText
        self.category = category
    }
}

// MARK: - CRUD methods

extension AnatomyModel {

}
