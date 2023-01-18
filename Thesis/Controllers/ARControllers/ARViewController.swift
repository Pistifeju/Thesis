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

protocol ARViewControllerDelegate: AnyObject {
    func didLoad()
}

class ARViewController: UIViewController, FocusEntityDelegate {
    
    // MARK: - Properties
    
    private var colorPickerView: ColorPickerView = ColorPickerView(frame: .zero)
    
    private var colorPickerHeight = NSLayoutConstraint()
    private var selectedColor: UIColor? = nil {
        didSet {
            if let color = self.selectedColor {
                colourButton.tintColor = color
            } else {
                colourButton.tintColor = .white
            }
        }
    }
    
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
        button.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .medium, scale: .large)
        let largeImage = UIImage(systemName: "gobackward", withConfiguration: largeConfig)
        
        button.setImage(largeImage, for: .normal)
        button.addTarget(self, action: #selector(resetModel), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.isHidden = true
        
        return button
    }()
    
    private lazy var colourButton: UIButton = {
        let button = UIButton(type: .system)
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .medium, scale: .large)
        let largeImage = UIImage(systemName: "paintpalette.fill", withConfiguration: largeConfig)
        
        button.setImage(largeImage, for: .normal)
        button.addTarget(self, action: #selector(didTapColours), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.tintColor = .white
        
        return button
    }()
    
    private lazy var exitButton: UIButton = {
        let button = UIButton(type: .system)
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .medium, scale: .large)
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
        colorPickerView.pickerDelegate = self
        
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
        view.addSubview(colourButton)
        view.addSubview(colorPickerView)
        
        NSLayoutConstraint.activate([
            arView.topAnchor.constraint(equalTo: view.topAnchor),
            arView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            arView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            arView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            placeButton.widthAnchor.constraint(equalToConstant: 50),
            placeButton.heightAnchor.constraint(equalToConstant: 50),
            placeButton.centerXAnchor.constraint(equalTo: arView.centerXAnchor),
            placeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        modelInformationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            modelInformationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            modelInformationView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            modelInformationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            resetButton.heightAnchor.constraint(equalToConstant: 50),
            resetButton.widthAnchor.constraint(equalToConstant: 50),
            resetButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            arView.trailingAnchor.constraint(equalToSystemSpacingAfter: resetButton.trailingAnchor, multiplier: 2),
        ])
        
        NSLayoutConstraint.activate([
            colourButton.heightAnchor.constraint(equalToConstant: 50),
            colourButton.widthAnchor.constraint(equalToConstant: 50),
            colourButton.topAnchor.constraint(equalToSystemSpacingBelow: resetButton.bottomAnchor, multiplier: 2),
            arView.trailingAnchor.constraint(equalToSystemSpacingAfter: colourButton.trailingAnchor, multiplier: 2),
        ])
        
        NSLayoutConstraint.activate([
            exitButton.heightAnchor.constraint(equalToConstant: 50),
            exitButton.widthAnchor.constraint(equalToConstant: 50),
            exitButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            exitButton.leadingAnchor.constraint(equalToSystemSpacingAfter: arView.leadingAnchor, multiplier: 2),
        ])
        
        self.colorPickerHeight = colorPickerView.heightAnchor.constraint(equalToConstant: 0)
        self.colorPickerHeight.isActive = true
        colorPickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorPickerView.widthAnchor.constraint(equalToConstant: 50),
            colorPickerView.topAnchor.constraint(equalToSystemSpacingBelow: colourButton.bottomAnchor, multiplier: 2),
            colorPickerView.centerXAnchor.constraint(equalTo: self.colourButton.centerXAnchor),
        ])
        self.view.bringSubviewToFront(self.modelInformationView)
        
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
        arView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:))))
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
                if(entities[index].state != .colored) {
                    entities[index].state = .unselected
                    if(entities[index].entity.name == entity.name) {
                        entities[index].state = .selected
                    }
                }
            }
        }
        
        colorModelEntities()
    }
    
    private func loadEntities(from childrens: Entity.ChildCollection?) {
        for children in childrens! {
            let childModelEntity = children as! ModelEntity
            childModelEntity.collision = CollisionComponent(shapes: [ShapeResource.generateConvex(from: childModelEntity.model!.mesh)])
            let informationText = self.model.subModels?[childModelEntity.name]
            let arEntity = AREntity(entity: childModelEntity, state: .unselected, originalMaterial: childModelEntity.model!.materials[0] as! PhysicallyBasedMaterial, isHidden: false, isFaded: false, informationText: informationText!)
            self.entities.append(arEntity)
        }
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
            strongSelf.colourButton.isHidden = true
        }))
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: { action in
            
        }))
        
        self.present(alert, animated: true)
    }
    
    @objc private func placeObject() {
        let modelName = self.model.name ?? "" //Skull, Chest better hitbox
        
        let entity = try! Entity.load(named: modelName)
        
        let geomChildrens = entity.findEntity(named: "Geom")
        
        if !(geomChildrens?.children.first is ModelEntity) {
            let childrens = geomChildrens?.children.first?.children.first?.children.first?.children.first!.children // just dont please
            self.loadEntities(from: childrens)
        } else {
            self.loadEntities(from: geomChildrens?.children)
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
        colourButton.isHidden = false
    }
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        let pressLocation: CGPoint = sender.location(in: arView)
        let result: [CollisionCastHit] = arView.hitTest(pressLocation)
        
        guard let hitTest: CollisionCastHit = result.first, hitTest.entity.name != "Ground Plane"
        else {
            return
        }
        
        let entity: ModelEntity = hitTest.entity as! ModelEntity
        
        var selectedModelEntity = AREntity()
        
        for index in 0..<entities.count {
            if(entities[index].entity.name == entity.name) {
                selectedModelEntity = entities[index]
                if let selectedColor = self.selectedColor{
                    selectedModelEntity.state = .colored
                    selectedModelEntity.coloredMaterialColor = selectedColor
                } else {
                    selectedModelEntity.state = .unselected
                }
                entities[index] = selectedModelEntity
                break
            }
        }
        
        self.colorModelEntities()
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        self.colorPickerHeight.constant = 0
        UIView.animate(withDuration: 0.5) {
            // request layout on the *superview*
            self.view.layoutIfNeeded()
        }
        
        let tapLocation: CGPoint = sender.location(in: arView)
        let result: [CollisionCastHit] = arView.hitTest(tapLocation)
        
        guard let hitTest: CollisionCastHit = result.first, hitTest.entity.name != "Ground Plane"
        else {
            self.modelInformationView.notesTextView.endEditing(true)
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
        
        let entityForText = self.entities.first(where: { $0.entity.name == entity.name })
        
        modelInformationView.configure(nameLabel: entity.name.replacingOccurrences(of: "_", with: " "), textViewString: entityForText!.informationText)
        self.modelInformationView.updateBottomButtons(entity: self.selectedEntity)
    }
    
    @objc private func didTapColours() {
        if(self.colorPickerHeight.constant == 0) {
            self.colorPickerHeight.constant = 300
        } else {
            self.colorPickerHeight.constant = 0
        }
        UIView.animate(withDuration: 0.5) {
            
            // request layout on the *superview*
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - ModelInformationViewDelegate

extension ARViewController: ModelInformationViewDelegate {
    func didTapIsolate() {
        if(self.selectedEntity.isIsolated) {
            self.selectedEntity.isolated = false
            for index in 0..<self.entities.count {
                if(self.selectedEntity.entity.name != entities[index].entity.name) {
                    entities[index].isIsolated = false
                }
            }
        } else {
            self.selectedEntity.isolated = true
            for index in 0..<self.entities.count {
                if(self.selectedEntity.entity.name != entities[index].entity.name) {
                    entities[index].isIsolated = true
                }
            }
        }
        self.modelInformationView.updateBottomButtons(entity: self.selectedEntity)
        colorModelEntities()
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
        if(self.selectedEntity.isFadedOthers) {
            self.selectedEntity.isFadedOthers = false
            for index in 0..<self.entities.count {
                if(self.selectedEntity.entity.name != entities[index].entity.name) {
                    entities[index].isFaded = false
                }
            }
        } else {
            self.selectedEntity.isFadedOthers = true
            for index in 0..<self.entities.count {
                if(self.selectedEntity.entity.name != entities[index].entity.name) {
                    entities[index].isFaded = true
                }
            }
        }
        self.modelInformationView.updateBottomButtons(entity: self.selectedEntity)
        colorModelEntities()
    }
    
    func didTapClose() {
        modelInformationView.isHidden = true
        selectEntity(withSelectedEntity: nil)
    }
}

// MARK: - ARCoachingOverlayViewDelegate

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

// MARK: - ColorPickerViewDelegate

extension ARViewController: ColorPickerViewDelegate {
    func didSelectColor(withColor: UIColor?) {
        guard let color = withColor else {
            self.colourButton.tintColor = .white
            self.selectedColor = nil
            self.colorPickerHeight.constant = 0
            UIView.animate(withDuration: 0.5) {
                
                // request layout on the *superview*
                self.view.layoutIfNeeded()
            }
            return
        }
        
        self.selectedColor = color
    }
}
