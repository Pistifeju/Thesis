//
//  DatabaseManager.swift
//  Thesis
//
//  Created by István Juhász on 2022. 11. 15..
//

import UIKit

final class DatabaseManager {
    static func loadData() {
        
        let decoder = JSONDecoder()

        guard let fileUrl = Bundle.main.url(forResource: "SkeletalJSON", withExtension: "json") else { return }
        guard let data = try? Data(contentsOf: fileUrl) else { return }

        do {
            let skeletalModels = try decoder.decode([AnatomyModel].self, from: data)
            if let encoded = try? JSONEncoder().encode(skeletalModels) {
                UserDefaults.standard.set(encoded, forKey: "skeletalModels")
            }
        } catch {
            
        }
        
    }
}
