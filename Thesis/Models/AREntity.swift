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

struct AREntity {
    var entity: ModelEntity
    var state: EntityState
    var originalMaterial: Material
    var isHidden: Bool
    var isFaded: Bool
    
    var currentMaterial: Material {
        var selectedMaterial = SimpleMaterial(color: .systemCyan, isMetallic: false) //Blue
        selectedMaterial.roughness = 0.0
        
        switch self.state {
        case .unselected:
            return originalMaterial
        case .selected:
            return selectedMaterial
        }
    }
    
    init(entity: ModelEntity, state: EntityState, originalMaterial: Material, isHidden: Bool, isFaded: Bool) {
        self.entity = entity
        self.state = state
        self.originalMaterial = originalMaterial
        self.isHidden = isHidden
        self.isFaded = isFaded
    }
    
    init() {
        self.entity = ModelEntity()
        self.state = .unselected
        self.originalMaterial = UnlitMaterial(color: .link)
        self.isHidden = false
        self.isFaded = false
    }
}
