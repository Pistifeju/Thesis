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
}

class AREntity {
    var entity: ModelEntity
    var state: EntityState
    var originalMaterial: PhysicallyBasedMaterial
    var isHidden: Bool
    var isFaded: Bool 
    
    var currentMaterial: PhysicallyBasedMaterial {
        var selectedMaterial = PhysicallyBasedMaterial()
        selectedMaterial.baseColor.tint = .systemCyan
        selectedMaterial.roughness = 0.0
        selectedMaterial.sheen = .none
        selectedMaterial.specular = 0.0
        
        if(self.isFaded) {
            selectedMaterial.blending = .transparent(opacity: 0.5)
            originalMaterial.blending = .transparent(opacity: 0.5)
        } else {
            selectedMaterial.blending = .transparent(opacity: 1.0)
            originalMaterial.blending = .transparent(opacity: 1.0)
        }
        
        switch self.state {
        case .unselected:
            return originalMaterial
        case .selected:
            return selectedMaterial
        }
    }
    
    init(entity: ModelEntity, state: EntityState, originalMaterial: PhysicallyBasedMaterial, isHidden: Bool, isFaded: Bool) {
        self.entity = entity
        self.state = state
        self.originalMaterial = originalMaterial
        self.isHidden = isHidden
        self.isFaded = isFaded
    }
    
    init() {
        self.entity = ModelEntity()
        self.state = .unselected
        self.originalMaterial = PhysicallyBasedMaterial()
        self.isHidden = false
        self.isFaded = false
    }
}
