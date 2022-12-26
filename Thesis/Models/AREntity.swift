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
    case colored
}

class AREntity {
    var entity: ModelEntity
    var state: EntityState
    var originalMaterial: PhysicallyBasedMaterial
    var coloredMaterialColor: UIColor
    var isHidden: Bool
    var isFaded: Bool 
    var isFadedOthers: Bool
    var isolated: Bool
    var isIsolated: Bool {
        get{
            return isolated
        }
        set(value) {
            if(value) {
                entity.isEnabled = false
            } else {
                entity.isEnabled = true
            }
        }
    }
    
    var currentMaterial: PhysicallyBasedMaterial {
        var selectedMaterial = PhysicallyBasedMaterial()
        selectedMaterial.baseColor.tint = .systemCyan
        selectedMaterial.roughness = 0.0
        selectedMaterial.sheen = .none
        selectedMaterial.specular = 0.0
        
        var coloredMaterial = PhysicallyBasedMaterial()
        coloredMaterial.baseColor.tint = coloredMaterialColor
        coloredMaterial.specular = 0.0
        coloredMaterial.sheen = .none
        coloredMaterial.roughness = 0.0
        
        if(self.isFaded) {
            selectedMaterial.blending = .transparent(opacity: 0.5)
            originalMaterial.blending = .transparent(opacity: 0.5)
            coloredMaterial.blending = .transparent(opacity: 0.5)
        } else {
            selectedMaterial.blending = .transparent(opacity: 1.0)
            originalMaterial.blending = .transparent(opacity: 1.0)
            coloredMaterial.blending = .transparent(opacity: 1.0)
        }
        
        switch self.state {
        case .unselected:
            return originalMaterial
        case .selected:
            return selectedMaterial
        case .colored:
            return coloredMaterial
        }
    }
    
    init(entity: ModelEntity, state: EntityState, originalMaterial: PhysicallyBasedMaterial, isHidden: Bool, isFaded: Bool) {
        self.coloredMaterialColor = UIColor.white
        self.entity = entity
        self.state = state
        self.originalMaterial = originalMaterial
        self.isHidden = isHidden
        self.isFaded = isFaded
        self.isFadedOthers = false
        self.isolated = false
        self.isIsolated = false
    }
    
    init() {
        self.entity = ModelEntity()
        self.state = .unselected
        self.originalMaterial = PhysicallyBasedMaterial()
        self.coloredMaterialColor = UIColor.white
        self.isHidden = false
        self.isFaded = false
        self.isFadedOthers = false
        self.isolated = false
        self.isIsolated = false
    }
}
