//
//  Constants.swift
//  Thesis
//
//  Created by István Juhász on 2022. 11. 12..
//

import UIKit
import RealityKit

let skeletalSystems = ["Laryngeal", "Chest", "Skull", "Arm", "Foot", "Hand", "Leg", "PelvicGirdle", "ShoulderGirdle", "VertebralColumn"]

struct Colors {
    static let buttonBlue = UIColor(red: 162 / 255, green: 210 / 255, blue: 255 / 255, alpha: 1)
    static let mainControllerCells = UIColor(red: 162 / 255, green: 210 / 255, blue: 255 / 255, alpha: 1)
}

enum Systems: String, CaseIterable{
    case skeletalSystem = "skeletalSystem"
    case visceralSystem = "visceralSystem"
    case muscularSystem = "muscularSystem"
}
