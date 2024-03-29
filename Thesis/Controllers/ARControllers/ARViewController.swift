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
import FirebaseAuth
import simd

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
        
    private var model: AnatomyModel
    private var fromTest: Bool
    private var modelAnchor: AnchorEntity = AnchorEntity()
    private let modelInformationView = ModelInformationView(frame: .zero)
    
    private var selectedEntity: AREntity = AREntity()
    private var entities: [AREntity] = [AREntity]()
    
    private lazy var focusSquare: FocusEntity = FocusEntity(on: self.arView, focus: .classic)
    
    private lazy var arView: ARView = {
        let arview = ARView()
        arview.translatesAutoresizingMaskIntoConstraints = false
        arview.isUserInteractionEnabled = true
        arview.debugOptions = [.none]
        return arview
    }()
    
    public lazy var placeButton: UIButton = {
        let button = UIButton(type: .system)
        
        let viewWidth = view.frame.size.width
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: viewWidth / 9, weight: .medium, scale: .large)
        let largeImage = UIImage(systemName: "checkmark.circle.fill", withConfiguration: largeConfig)
        
        button.setImage(largeImage, for: .normal)
        button.addTarget(self, action: #selector(placeObject), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.alpha = 0.0
        
        return button
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        
        let viewWidth = view.frame.size.width
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: viewWidth / 9, weight: .medium, scale: .large)
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
        
        let viewWidth = view.frame.size.width
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: viewWidth / 9, weight: .medium, scale: .large)
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
        
        let viewWidth = view.frame.size.width
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: viewWidth / 9, weight: .medium, scale: .large)
        let largeImage = UIImage(systemName: "x.square", withConfiguration: largeConfig)
        
        button.setImage(largeImage, for: .normal)
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    init(with model: AnatomyModel, fromTest: Bool) {
        self.model = model
        self.fromTest = fromTest
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
        addCoaching()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arView.scene.removeAnchor(modelAnchor)
        arView.scene.anchors.removeAll()
        entities = [AREntity]()
        selectedEntity = AREntity()
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
        
        let viewWidth = view.frame.size.width
        
        NSLayoutConstraint.activate([
            arView.topAnchor.constraint(equalTo: view.topAnchor),
            arView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            arView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            arView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            placeButton.widthAnchor.constraint(equalToConstant: viewWidth / 7.5),
            placeButton.heightAnchor.constraint(equalToConstant: viewWidth / 7.5),
            placeButton.centerXAnchor.constraint(equalTo: arView.centerXAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: placeButton.bottomAnchor, multiplier: 2),
        ])
        
        modelInformationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            modelInformationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            modelInformationView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            modelInformationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            resetButton.heightAnchor.constraint(equalToConstant: viewWidth / 9),
            resetButton.widthAnchor.constraint(equalToConstant: viewWidth / 9),
            resetButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            arView.trailingAnchor.constraint(equalToSystemSpacingAfter: resetButton.trailingAnchor, multiplier: 2),
        ])
        
        NSLayoutConstraint.activate([
            colourButton.heightAnchor.constraint(equalToConstant: viewWidth / 9),
            colourButton.widthAnchor.constraint(equalToConstant: viewWidth / 9),
            colourButton.topAnchor.constraint(equalToSystemSpacingBelow: resetButton.bottomAnchor, multiplier: 2),
            arView.trailingAnchor.constraint(equalToSystemSpacingAfter: colourButton.trailingAnchor, multiplier: 2),
        ])
        
        NSLayoutConstraint.activate([
            exitButton.heightAnchor.constraint(equalToConstant: viewWidth / 9),
            exitButton.widthAnchor.constraint(equalToConstant: viewWidth / 9),
            exitButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            exitButton.leadingAnchor.constraint(equalToSystemSpacingAfter: arView.leadingAnchor, multiplier: 2),
        ])
        
        self.colorPickerHeight = colorPickerView.heightAnchor.constraint(equalToConstant: 0)
        self.colorPickerHeight.isActive = true
        colorPickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorPickerView.widthAnchor.constraint(equalToConstant: viewWidth / 9),
            colorPickerView.topAnchor.constraint(equalToSystemSpacingBelow: colourButton.bottomAnchor, multiplier: 2),
            colorPickerView.centerXAnchor.constraint(equalTo: self.colourButton.centerXAnchor),
        ])
        self.view.bringSubviewToFront(self.modelInformationView)
        
        modelInformationView.isHidden = true
    }
    
    private func setupARView() {
        arView.automaticallyConfigureSession = false
        
        let configuration = ARWorldTrackingConfiguration()
        arView.environment.sceneUnderstanding.options = .collision
        configuration.planeDetection = [.horizontal]
        configuration.environmentTexturing = .automatic
        arView.session.run(configuration, options: [.stopTrackedRaycasts, .removeExistingAnchors, .resetSceneReconstruction, .resetTracking])
        
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
    
    private func saveColorForEntity(entityName: String, color: UIColor?) {
        let id = Auth.auth().currentUser?.uid
        let defaults = UserDefaults.standard
                
        if let object = defaults.object(forKey: id!) as? [String: Any] {
            let notes = object["notes"] as! [String: String]
            var colors = object["colors"] as! [String: String]
            var colorRawValue = ""
            
            if let color {
                if color == UIColor.red {
                    colorRawValue = "red"
                } else if color == UIColor.green {
                    colorRawValue = "green"
                } else if color == UIColor.orange {
                    colorRawValue = "orange"
                }
                
                colors[entityName] = colorRawValue
                
            } else {
                colors[entityName] = nil
            }
            
            let user: [String: Any] = ["notes": notes, "colors": colors]
            defaults.set(user, forKey: id!)
        }
    }
    
    private func loadColorForEntity(entityName: String) -> UIColor? {
        let id = Auth.auth().currentUser?.uid
        let defaults = UserDefaults.standard
        
        if let object = defaults.object(forKey: id!) as? [String: Any] {
            let colors = object["colors"] as! [String: String]
            if let color = colors[entityName] {
                if color == "red" {
                    return UIColor.red
                } else if color == "green" {
                    return UIColor.green
                } else if color == "orange" {
                    return UIColor.orange
                }
            }
        }
        
        return nil
    }
    
    private func saveNoteforEntity(entityName: String, note: String) {
        let id = Auth.auth().currentUser?.uid
        let defaults = UserDefaults.standard
        
        if let object = defaults.object(forKey: id!) as? [String: Any] {
            var notes = object["notes"] as! [String: String]
            let colors = object["colors"] as! [String: String]

            notes[entityName] = note
            let user: [String: Any] = ["notes": notes, "colors": colors]
            defaults.set(user, forKey: id!)
        }
    }
    
    private func loadNoteForEntity(entityName: String) -> String {
        let id = Auth.auth().currentUser?.uid
        let defaults = UserDefaults.standard

        if let object = defaults.object(forKey: id!) as? [String: Any] {
            let notes = object["notes"] as! [String: String]
            if let note = notes[entityName] {
                return note
            }
        }
        
        return ""
    }
    
    private func loadEntities(from childrens: Entity.ChildCollection?) {
        for children in childrens! {
            let childModelEntity = children as! ModelEntity
            childModelEntity.collision = CollisionComponent(shapes: [ShapeResource.generateConvex(from: childModelEntity.model!.mesh)])
            let informationText = self.model.subModels?[childModelEntity.name] ?? "Under Development"
            let notes = loadNoteForEntity(entityName: childModelEntity.name)
            let color = loadColorForEntity(entityName: childModelEntity.name)
            let arEntity = AREntity(entity: childModelEntity, state: .unselected, originalMaterial: childModelEntity.model!.materials[0] as! PhysicallyBasedMaterial, isHidden: false, isFaded: false, informationText: informationText, notes: notes)
            if let color {
                arEntity.coloredMaterialColor = color
                arEntity.state = .colored
            }
            
            self.entities.append(arEntity)
            self.colorModelEntities()
        }
    }
    
    // MARK: - Selectors
    
    @objc private func dismissView() {
        let alert = UIAlertController(title: "Do you want to exit?", message: "", preferredStyle: .alert)
    
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: {action in
            
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] action in
            guard let strongSelf = self else { return }
            
            if strongSelf.fromTest {
                strongSelf.navigationController?.popViewController(animated: true)
            } else {
                strongSelf.dismiss(animated: true)
            }
            
        }))
        
        self.present(alert, animated: true)
    }
    
    @objc private func resetModel() {
        let alert = UIAlertController(title: "Do you want to reset your model?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
            
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] action in
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
        
        self.present(alert, animated: true)
    }
    
    @objc private func placeObject() {
        let modelName = self.model.name ?? ""
        
        let entity = try! Entity.load(named: modelName)
        
        var geomChildrens = entity.findEntity(named: "Geom")
        
        while !(geomChildrens?.children.first is ModelEntity) {
            geomChildrens = geomChildrens?.children.first
        }

        self.loadEntities(from: geomChildrens?.children)
        
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
                if let selectedColor = self.selectedColor {
                    selectedModelEntity.coloredMaterialColor = selectedColor
                    selectedModelEntity.state = .colored
                    saveColorForEntity(entityName: selectedModelEntity.entity.name, color: selectedColor)
                } else {
                    selectedModelEntity.state = .unselected
                    saveColorForEntity(entityName: selectedModelEntity.entity.name, color: nil)
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
        
        modelInformationView.configure(nameLabel: entity.name.replacingOccurrences(of: "_", with: " "), textViewString: entityForText?.informationText ?? "", notesTextViewString: entityForText?.notes ?? "")
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
    func didWriteNote(note: String) {
        saveNoteforEntity(entityName: self.selectedEntity.entity.name, note: note)
    }
    
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

extension ARViewController: ARCoachingOverlayViewDelegate {
    func addCoaching() {
        // Create a ARCoachingOverlayView object
        let coachingOverlay = ARCoachingOverlayView()
        // Make sure it rescales if the device orientation changes
        coachingOverlay.autoresizingMask = [
            .flexibleWidth, .flexibleHeight
        ]
        
        view.addSubview(coachingOverlay)
        
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coachingOverlay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coachingOverlay.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            coachingOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            coachingOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            coachingOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coachingOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        // Set the Augmented Reality goal
        coachingOverlay.goal = .horizontalPlane
        // Set the ARSession
        coachingOverlay.session = arView.session
        // Set the delegate for any callbacks
        coachingOverlay.delegate = self
    }
    
    // Example callback for the delegate object
    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        coachingOverlayView.activatesAutomatically = true
        
        placeButton.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.placeButton.alpha = 1
        }
    }
    
    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
        placeButton.isHidden = true
        self.placeButton.alpha = 0
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
                
                self.view.layoutIfNeeded()
            }
            return
        }
        
        self.selectedColor = color
    }
}
