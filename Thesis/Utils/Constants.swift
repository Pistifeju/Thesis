//
//  Constants.swift
//  Thesis
//
//  Created by István Juhász on 2022. 11. 12..
//

import Foundation
import UIKit

struct Colors {
    static let buttonGrey = UIColor(red: 55 / 255, green: 61 / 255, blue: 64 / 255, alpha: 1)
    static let mainControllerCells = UIColor(red: 255 / 255, green: 212 / 255, blue: 212 / 255, alpha: 1)
}

enum Systems: String, CaseIterable{
    case skeletalSystem = "skeletalSystem"
    case visceralSystem = "visceralSystem"
    case muscularSystem = "muscularSystem"
}
