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

enum EntityState {
    case unselected
    case selected
    case correctName
    case wrongName
    case wrongAndSelected
    case correctAndSelected
}

class ARViewController: UIViewController, FocusEntityDelegate {
    
    // MARK: - Properties
        
    weak var delegate: ARViewControllerDelegate?
    
    private let lottieAnimationView = AnimationView()
    
    public var model: AnatomyModel
    private var modelAnchor: AnchorEntity = AnchorEntity()
    private let modelInformationView = ModelInformationView(frame: .zero)
    
    private var entitiesState: [String: EntityState] = [String: EntityState]()
    private var modelEntities: [ModelEntity] = [ModelEntity]()
    private var modelEntitiesMaterials: [String: Material] = [String: Material]()
    
    private var selectedEntity: ModelEntity = ModelEntity()
    
    private lazy var focusSquare: FocusEntity = FocusEntity(on: self.arView, focus: .classic)
    
    private lazy var nameTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.tintColor = .black
        tf.textColor = .black
        tf.layer.cornerRadius = 10
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.returnKeyType = .done
        
        tf.leftViewMode = .always
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        
        tf.isHidden = true
        tf.clearsOnBeginEditing = true
        
        return tf
    }()
    
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
        nameTextField.delegate = self
        
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
    
    private func setupAnimation(with animation: String) {
        lottieAnimationView.isHidden = false
        lottieAnimationView.animation = LottieAnimation.named(animation)
        lottieAnimationView.contentMode = .scaleAspectFit
        lottieAnimationView.loopMode = .playOnce
        
        lottieAnimationView.play { [weak self] finished in
            guard let strongSelf = self else {return}
            strongSelf.lottieAnimationView.isHidden = true
        }
    }
    
    private func configureUI() {
        view.addSubview(arView)
        view.addSubview(placeButton)
        view.addSubview(modelInformationView)
        view.addSubview(nameTextField)
        view.addSubview(lottieAnimationView)
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
            modelInformationView.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            modelInformationView.heightAnchor.constraint(equalToConstant: 200),
            modelInformationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            modelInformationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            modelInformationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        let textFieldOnKeyboard = view.keyboardLayoutGuide.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10)
        view.keyboardLayoutGuide.setConstraints([textFieldOnKeyboard], activeWhenAwayFrom: .top)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: 52),
            nameTextField.widthAnchor.constraint(equalToConstant: view.frame.size.width / 2),
        ])
        
        lottieAnimationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lottieAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lottieAnimationView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            lottieAnimationView.heightAnchor.constraint(equalToConstant: 100),
            lottieAnimationView.widthAnchor.constraint(equalToConstant: 100),
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
        configuration.planeDetection = [.horizontal]
        configuration.environmentTexturing = .automatic
        arView.session.run(configuration)
        
        arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
    }
    
    private func colorModelEntities() {
        let selectedMaterial = SimpleMaterial(color: .link, isMetallic: false) //Blue
        let wrongNameMaterial = SimpleMaterial(color: .red, isMetallic: false) //Red
        let correctNameMaterial = SimpleMaterial(color: .green, isMetallic: false) //Green
        
        for entity in modelEntities {

            switch entitiesState[entity.name] {
            case .selected:
                entity.model!.materials[0] = selectedMaterial
            case .unselected:
                entity.model!.materials[0] = UnlitMaterial(color: .link)
                entity.model!.materials[0] = modelEntitiesMaterials[entity.name]!
            case .correctName:
                entity.model!.materials[0] = correctNameMaterial
            case .wrongName:
                entity.model!.materials[0] = wrongNameMaterial
            case .wrongAndSelected:
                entity.model!.materials[0] = selectedMaterial
            case .correctAndSelected:
                entity.model!.materials[0] = selectedMaterial
            case .none:
                break
            }
        }
    }
    
    private func selectEntity(withSelectedEntity: ModelEntity?) {
        modelInformationView.isHidden = false
        nameTextField.isHidden = false
        nameTextField.becomeFirstResponder()
        nameTextField.text = ""
        
        
        //If we didnt hit any modelEntity
        guard let selectedEntity = withSelectedEntity else {
            
            for entity in modelEntities {
                if entitiesState[entity.name] == .wrongAndSelected {
                    entitiesState[entity.name] = .wrongName
                }
                if entitiesState[entity.name] == .correctAndSelected {
                    entitiesState[entity.name] = .correctName
                }
            }
            
            //Unselect the selected entity if there is one.
            for entity in modelEntities {
                if(entitiesState[entity.name] == .selected) {
                    entitiesState[entity.name] = .unselected
                }
            }
            modelInformationView.isHidden = true
            nameTextField.isHidden = true
            nameTextField.resignFirstResponder()
            colorModelEntities()
            return
        }
        
        if(entitiesState[selectedEntity.name] == .selected) {
            // If its already selected, just unselect
            entitiesState[selectedEntity.name] = .unselected
            modelInformationView.isHidden = true
            nameTextField.isHidden = true
            nameTextField.resignFirstResponder()
        } else if (entitiesState[selectedEntity.name] == .wrongAndSelected){
            entitiesState[selectedEntity.name] = .wrongName
            modelInformationView.isHidden = true
            nameTextField.isHidden = true
            nameTextField.resignFirstResponder()
        } else if (entitiesState[selectedEntity.name] == .correctAndSelected){
            entitiesState[selectedEntity.name] = .correctName
            modelInformationView.isHidden = true
            nameTextField.isHidden = true
            nameTextField.resignFirstResponder()
        } else {
            
            for entity in modelEntities {
                if entitiesState[entity.name] == .wrongAndSelected {
                    entitiesState[entity.name] = .wrongName
                }
                if entitiesState[entity.name] == .correctAndSelected {
                    entitiesState[entity.name] = .correctName
                }
            }
            
            for entity in modelEntities {
                if(entitiesState[entity.name] == .selected) {
                    entitiesState[entity.name] = .unselected
                }
            }
            if(entitiesState[selectedEntity.name] == .wrongName) {
                entitiesState[selectedEntity.name] = .wrongAndSelected
            } else if (entitiesState[selectedEntity.name] == .correctName) {
                entitiesState[selectedEntity.name] = .correctAndSelected
            } else {
                //First unselect the previously selected entity.
                entitiesState[selectedEntity.name] = .selected
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
            strongSelf.entitiesState = [String: EntityState]()
            strongSelf.modelEntities = [ModelEntity]()
            strongSelf.modelEntitiesMaterials = [String: Material]()
            strongSelf.selectedEntity = ModelEntity()
            strongSelf.resetButton.isHidden = true
            strongSelf.placeButton.isHidden = false
            strongSelf.focusSquare.isEnabled = true
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
                entitiesState[childModelEntity.name] = EntityState.unselected
                modelEntitiesMaterials[childModelEntity.name] = childModelEntity.model!.materials[0]
                modelEntities.append(childModelEntity)
            }
        } else {
            for children in nameChildrens!.children {
                let childModelEntity = children as! ModelEntity
                childModelEntity.collision = CollisionComponent(shapes: [ShapeResource.generateConvex(from: childModelEntity.model!.mesh)])
                entitiesState[childModelEntity.name] = EntityState.unselected
                modelEntitiesMaterials[childModelEntity.name] = childModelEntity.model!.materials[0]
                modelEntities.append(childModelEntity)
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
            modelInformationView.isHidden = true
            selectEntity(withSelectedEntity: nil)
            return
        }
        
        let entity: ModelEntity = hitTest.entity as! ModelEntity
        self.selectedEntity = entity
        selectEntity(withSelectedEntity: entity)
        
        modelInformationView.configure(nameLabel: entity.name, textViewString: LoremSwiftum.Lorem.tweet)
        modelInformationView.isHidden = true
    }
}

extension ARViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Check if the textField.text is equeals to the name of the modelEntity
        let text = textField.text ?? ""
        if text == "" {
            //Unselect here
            selectEntity(withSelectedEntity: selectedEntity)
        } else if self.selectedEntity.name.lowercased() == textField.text?.lowercased() {
            entitiesState[selectedEntity.name] = .correctName
            setupAnimation(with: "checkmark")
        } else {
            entitiesState[selectedEntity.name] = .wrongName
            setupAnimation(with: "failed")
        }
        colorModelEntities()
        nameTextField.resignFirstResponder()
        nameTextField.isHidden = true
        textField.text = ""
        return true
    }
}

extension ARViewController: ModelInformationViewDelegate {
    func didTapExit() {
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
