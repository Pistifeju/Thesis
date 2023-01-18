//
//  User.swift
//  Thesis
//
//  Created by István Juhász on 2023. 01. 18..
//

struct User: Codable {
    let username: String
    let email: String
    
    init(dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
    }
}
