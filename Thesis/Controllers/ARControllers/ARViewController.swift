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
import Lottie

protocol ARViewControllerDelegate: AnyObject {
    func didLoad()
}

class ARViewController: UIViewController, FocusEntityDelegate {
    
    // MARK: - Properties
    
    weak var delegate: ARViewControllerDelegate?
    
    public var model: AnatomyModel
    private var modelAnchor: AnchorEntity = AnchorEntity()
    private let modelInformationView = ModelInformationView(frame: .zero)
    
    private var selectedEntity: AREntity = AREntity()
    private var entities: [AREntity] = [AREntity]()
    
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
        arview.debugOptions = [.none]
        
        return arview
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .large)
        let largeImage = UIImage(systemName: "gobackward", withConfiguration: largeConfig)
        
        button.setImage(largeImage, for: .normal)
        button.addTarget(self, action: #selector(resetModel), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.isHidden = true
        
        return button
    }()
    
    private lazy var exitButton: UIButton = {
        let button = UIButton(type: .system)
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .large)
        let largeImage = UIImage(systemName: "x.square", withConfiguration: largeConfig)
        
        button.setImage(largeImage, for: .normal)
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    init(with model: AnatomyModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modelInformationView.delegate = self
        focusSquare.isEnabled = true
        view.keyboardLayoutGuide.followsUndockedKeyboard = true
        
        configureUI()
        setupARView()
        delegate?.didLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.addSubview(arView)
        view.addSubview(placeButton)
        view.addSubview(modelInformationView)
        view.addSubview(resetButton)
        view.addSubview(exitButton)
        
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
            modelInformationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            modelInformationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            modelInformationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            resetButton.heightAnchor.constraint(equalToConstant: 25),
            resetButton.widthAnchor.constraint(equalToConstant: 25),
            resetButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            arView.trailingAnchor.constraint(equalToSystemSpacingAfter: resetButton.trailingAnchor, multiplier: 2),
        ])
        
        NSLayoutConstraint.activate([
            exitButton.heightAnchor.constraint(equalToConstant: 25),
            exitButton.widthAnchor.constraint(equalToConstant: 25),
            exitButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            exitButton.leadingAnchor.constraint(equalToSystemSpacingAfter: arView.leadingAnchor, multiplier: 2),
        ])
        
        modelInformationView.isHidden = true
    }
    
    private func setupARView() {
        arView.automaticallyConfigureSession = false
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.frameSemantics.insert(.personSegmentationWithDepth)
        configuration.frameSemantics.insert(.personSegmentation)
        arView.environment.sceneUnderstanding.options = .collision
        configuration.planeDetection = [.horizontal]
        configuration.environmentTexturing = .automatic
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
    }
    
    private func colorModelEntities() {
        for entity in entities {
            entity.entity.model?.materials[0] = entity.currentMaterial
        }
    }
    
    private func selectEntity(withSelectedEntity: ModelEntity?) {
        modelInformationView.isHidden = false
        
        //If we didnt hit any modelEntity
        guard let entity = withSelectedEntity else {
            //Unselect the selected entity if there is one.
            
            for index in 0..<entities.count {
                if entities[index].state == .selected {
                    entities[index].state = .unselected
                }
            }
            
            modelInformationView.isHidden = true
            colorModelEntities()
            return
        }
        
        var selectedPreviouslySelectedModel = false
        for index in 0..<entities.count {
            if(entity.name == entities[index].entity.name && entities[index].state == .selected) {
                //This means the user tapped on the same entity which was already selected.
                entities[index].state = .unselected
                selectedPreviouslySelectedModel = true
                modelInformationView.isHidden = true
                break
            }
        }
        
        if(selectedPreviouslySelectedModel == false) {
            for index in 0..<entities.count {
                entities[index].state = .unselected
                if(entities[index].entity.name == entity.name) {
                    entities[index].state = .selected
                }
            }
        }
        
        colorModelEntities()
    }

    // MARK: - Selectors
    
    @objc private func dismissView() {
        let alert = UIAlertController(title: "Do you want to exit?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] action in
            guard let strongSelf = self else { return }
            strongSelf.navigationController?.popToRootViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: {action in
            
        }))
        
        self.present(alert, animated: true)
    }
    
    @objc private func resetModel() {
        let alert = UIAlertController(title: "Do you want to reset your model?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] action in
            guard let strongSelf = self else { return }
            //Reset
            strongSelf.arView.scene.removeAnchor(strongSelf.modelAnchor)
            strongSelf.entities = [AREntity]()
            strongSelf.resetButton.isHidden = true
            strongSelf.placeButton.isHidden = false
            strongSelf.focusSquare.isEnabled = true
            strongSelf.modelInformationView.isHidden = true
        }))
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: { action in
            
        }))
        
        self.present(alert, animated: true)
    }
    
    @objc private func placeObject() {
        let modelName = self.model.name ?? "" //Skull, Chest better hitbox
        
        let entity = try! Entity.load(named: modelName)
        
        let geomChildrens = entity.findEntity(named: "Geom")
        let nameChildrens = entity.findEntity(named: modelName)
        
        if let geomChildrens = geomChildrens {
            for children in geomChildrens.children {
                let childModelEntity = children as! ModelEntity
                childModelEntity.collision = CollisionComponent(shapes: [ShapeResource.generateConvex(from: childModelEntity.model!.mesh)])
                self.entities.append(AREntity(entity: childModelEntity, state: .unselected, originalMaterial: childModelEntity.model!.materials[0] as! PhysicallyBasedMaterial, isHidden: false, isFaded: false))
            }
        } else {
            for children in nameChildrens!.children {
                let childModelEntity = children as! ModelEntity
                childModelEntity.collision = CollisionComponent(shapes: [ShapeResource.generateConvex(from: childModelEntity.model!.mesh)])
                self.entities.append(AREntity(entity: childModelEntity, state: .unselected, originalMaterial: childModelEntity.model!.materials[0] as! PhysicallyBasedMaterial, isHidden: false, isFaded: false))
            }
        }

        let modelEntity = ModelEntity()
        modelEntity.addChild(entity)
        
        let anchorEntity = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: .zero))
        anchorEntity.addChild(modelEntity)
        self.modelAnchor = anchorEntity

        arView.installGestures([.all],for: modelEntity)

        arView.scene.addAnchor(anchorEntity)
        
        focusSquare.isEnabled = false
        placeButton.isHidden = true
        resetButton.isHidden = false
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        let tapLocation: CGPoint = sender.location(in: arView)
        let result: [CollisionCastHit] = arView.hitTest(tapLocation)
        
        guard let hitTest: CollisionCastHit = result.first, hitTest.entity.name != "Ground Plane"
        else {
            selectEntity(withSelectedEntity: nil)
            return
        }
        
        let entity: ModelEntity = hitTest.entity as! ModelEntity
        
        for index in 0..<entities.count {
            if(entities[index].entity.name == entity.name) {
                self.selectedEntity = entities[index]
                break
            }
        }
        
        selectEntity(withSelectedEntity: entity)
        
        modelInformationView.configure(nameLabel: entity.name, textViewString: LoremSwiftum.Lorem.tweet)
        self.modelInformationView.updateBottomButtons(entity: self.selectedEntity)
    }
}

extension ARViewController: ModelInformationViewDelegate {
    func didTapIsolate() {
        
    }
    
    func didTapFade() {
        if(self.selectedEntity.isFaded) {
            self.selectedEntity.isFaded = false
        } else {
            self.selectedEntity.isFaded = true
        }
        self.modelInformationView.updateBottomButtons(entity: self.selectedEntity)
        colorModelEntities()
    }
    
    func didTapFadeOthers() {
        
    }
    
    func didTapClose() {
        modelInformationView.isHidden = true
        selectEntity(withSelectedEntity: nil)
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
