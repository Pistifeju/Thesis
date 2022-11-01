//
//  ARViewController.swift
//  Thesis
//
//  Created by István Juhász on 2022. 11. 01..
//
import UIKit
import RealityKit
import ARKit
import FocusEntity
import LoremSwiftum

class ARViewController: UIViewController, FocusEntityDelegate {
    
    // MARK: - Properties
    
    private let modelInformationView = ModelInformationView(frame: .zero)
    
    private var lastHitObject: ModelEntity = ModelEntity()
    private var lastHitObjectMaterial: [Material] = [Material]()
    private var placedDown = false
    private lazy var focusSquare: FocusEntity = FocusEntity(on: self.arView, focus: .classic)
    
    private lazy var placeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        button.addTarget(self, action: #selector(placeObject), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var arView: ARView = {
        let arview = ARView()
        arview.translatesAutoresizingMaskIntoConstraints = false
        arview.isUserInteractionEnabled = true
        arview.addCoaching()
        arview.debugOptions = [.showPhysics]
        
        return arview
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modelInformationView.delegate = self
        
        configureUI()
        setupARView()

    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.addSubview(arView)
        view.addSubview(placeButton)
        view.addSubview(modelInformationView)
        
        arView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arView.topAnchor.constraint(equalTo: view.topAnchor),
            arView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            arView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            arView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        placeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeButton.widthAnchor.constraint(equalToConstant: 50),
            placeButton.heightAnchor.constraint(equalToConstant: 50),
            placeButton.centerXAnchor.constraint(equalTo: arView.centerXAnchor),
            placeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        modelInformationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            modelInformationView.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            modelInformationView.heightAnchor.constraint(equalToConstant: 200),
            modelInformationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            modelInformationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            modelInformationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        modelInformationView.isHidden = true
        changePlaceButtonVisibility()
    }
    
    private func changePlaceButtonVisibility() {
        if modelInformationView.isHidden {
            placeButton.isHidden = false
            focusSquare.isEnabled = true
        } else {
            placeButton.isHidden = true
            focusSquare.isEnabled = false
        }
    }
    
    private func setupARView() {
        arView.automaticallyConfigureSession = false
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        configuration.environmentTexturing = .automatic
        arView.session.run(configuration)
        
        arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
    }

    
    
    // MARK: - Selectors
    
    @objc private func placeObject() {
        let modelName = "Skull"
        
        let entity = try! Entity.load(named: modelName)
        let geomChildrens = entity.findEntity(named: "Geom")
        let nameChildrens = entity.findEntity(named: modelName)
        
        if let geomChildrens = geomChildrens {
            for children in geomChildrens.children {
                let childModelEntity = children as! ModelEntity
                childModelEntity.collision = CollisionComponent(shapes: [ShapeResource.generateConvex(from: childModelEntity.model!.mesh)])
            }
        } else {
            for children in nameChildrens!.children {
                let childModelEntity = children as! ModelEntity
                childModelEntity.collision = CollisionComponent(shapes: [ShapeResource.generateConvex(from: childModelEntity.model!.mesh)])
            }
        }

        let modelEntity = ModelEntity()
        modelEntity.addChild(entity)
        
        let anchorEntity = AnchorEntity(plane: .horizontal)
        anchorEntity.addChild(modelEntity)

        arView.installGestures([.all],for: modelEntity)

        arView.scene.addAnchor(anchorEntity)
        
        focusSquare.isEnabled = false
    }
    
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        let tapLocation: CGPoint = sender.location(in: arView)
        let result: [CollisionCastHit] = arView.hitTest(tapLocation)
        
        guard let hitTest: CollisionCastHit = result.first, hitTest.entity.name != "Ground Plane"
        else {
            modelInformationView.isHidden = true
            changePlaceButtonVisibility()
            lastHitObject.model?.materials = lastHitObjectMaterial
            return
        }

        let entity: ModelEntity = hitTest.entity as! ModelEntity
        
        lastHitObject.model?.materials = lastHitObjectMaterial
        lastHitObject = entity
        lastHitObjectMaterial = entity.model!.materials
        
        let material = SimpleMaterial(color: .link, isMetallic: false)
        entity.model?.materials = [material]

        
        modelInformationView.isHidden = false
        changePlaceButtonVisibility()
        modelInformationView.configure(nameLabel: entity.name, textViewString: LoremSwiftum.Lorem.tweet)
    }
}

extension ARViewController: ModelInformationViewDelegate {
    func didTapExit() {
        modelInformationView.isHidden = true
        changePlaceButtonVisibility()
        lastHitObject.model?.materials = lastHitObjectMaterial
    }
}

extension ARView: ARCoachingOverlayViewDelegate {
    func addCoaching() {
        // Create a ARCoachingOverlayView object
        let coachingOverlay = ARCoachingOverlayView()
        // Make sure it rescales if the device orientation changes
        coachingOverlay.autoresizingMask = [
          .flexibleWidth, .flexibleHeight
        ]
        self.addSubview(coachingOverlay)
        
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coachingOverlay.centerXAnchor.constraint(equalTo: centerXAnchor),
            coachingOverlay.centerYAnchor.constraint(equalTo: centerYAnchor),
            coachingOverlay.topAnchor.constraint(equalTo: self.topAnchor),
            coachingOverlay.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            coachingOverlay.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            coachingOverlay.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        // Set the Augmented Reality goal
        coachingOverlay.goal = .horizontalPlane
        // Set the ARSession
        coachingOverlay.session = self.session
        // Set the delegate for any callbacks
        coachingOverlay.delegate = self
      }
    
      // Example callback for the delegate object
    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        coachingOverlayView.activatesAutomatically = false

    }
}
