//
//  AREntity.swift
//  Thesis
//
//  Created by István Juhász on 2022. 12. 22..
//

import Foundation
import RealityKit
import MetalKit

enum EntityState {
    case unselected
    case selected
    case correctName
    case wrongName
    case wrongAndSelected
    case correctAndSelected
}

struct AREntity {
    var entity: ModelEntity
    var state: EntityState
    var originalMaterial: Material
    
    var currentMaterial: Material {
        var selectedMaterial = SimpleMaterial(color: .systemCyan, isMetallic: false) //Blue
        selectedMaterial.roughness = 0.0
        var wrongNameMaterial = SimpleMaterial(color: .systemRed, isMetallic: false) //Red
        var correctNameMaterial = SimpleMaterial(color: .systemGreen, isMetallic: false) //Green
        
//        let device = MTLCreateSystemDefaultDevice()
//
//        let defaultLibrary = device!.makeDefaultLibrary()!
//
//        let modifier = CustomMaterial.GeometryModifier(
//            named: "basicModifier",
//            in: defaultLibrary)
//
//        //Selected Color
//        let selectedShader = CustomMaterial.SurfaceShader(
//            named: "basicSelectedShader",
//            in: defaultLibrary)
//
//        let selectedMaterial = try! CustomMaterial(
//            surfaceShader: selectedShader,
//            geometryModifier: modifier,
//            lightingModel: .lit)
//
//        //Wrong Color
//        let wrongShader = CustomMaterial.SurfaceShader(
//            named: "basicWrongShader",
//            in: defaultLibrary)
//
//        let wrongNameMaterial = try! CustomMaterial(
//            surfaceShader: wrongShader,
//            geometryModifier: modifier,
//            lightingModel: .lit)
//
//        //Correct Color
//        let correctShader = CustomMaterial.SurfaceShader(
//            named: "basicCorrectShader",
//            in: defaultLibrary)
//
//        let correctNameMaterial = try! CustomMaterial(
//            surfaceShader: correctShader,
//            geometryModifier: modifier,
//            lightingModel: .lit)
        
        switch self.state {
        case .unselected:
            return originalMaterial
        case .selected:
            return selectedMaterial
        case .correctName:
            return correctNameMaterial
        case .wrongName:
            return wrongNameMaterial
        case .wrongAndSelected:
            return selectedMaterial
        case .correctAndSelected:
            return selectedMaterial
        }
    }
    
    init(entity: ModelEntity, state: EntityState, originalMaterial: Material) {
        self.entity = entity
        self.state = state
        self.originalMaterial = originalMaterial
    }
    
    init() {
        self.entity = ModelEntity()
        self.state = .unselected
        self.originalMaterial = UnlitMaterial(color: .link)
    }
}
