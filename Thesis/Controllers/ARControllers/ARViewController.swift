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

protocol ARViewControllerDelegate: AnyObject {
    func didLoad()
}

enum EntityState {
    case unselected
    case selected
    case correctName
    case wrongName
}

class ARViewController: UIViewController, FocusEntityDelegate {
    
    // MARK: - Properties
        
    weak var delegate: ARViewControllerDelegate?
    
    public var model: AnatomyModel
    private let modelInformationView = ModelInformationView(frame: .zero)
    
    private var entitiesState: [String: EntityState] = [String: EntityState]()
    private var modelEntities: [ModelEntity] = [ModelEntity]()
    private var modelEntitiesMaterials: [String: Material] = [String: Material]()
    
    private var selectedEntity: ModelEntity = ModelEntity()
    
    private lazy var focusSquare: FocusEntity = FocusEntity(on: self.arView, focus: .classic)
    
    private let nameTextField: UITextField = {
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

    
    // MARK: - Helpers
    
    private func configureUI() {
        view.addSubview(arView)
        view.addSubview(placeButton)
        view.addSubview(modelInformationView)
        view.addSubview(nameTextField)
        
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
            
            let keyExists = modelEntitiesMaterials[entity.name] != nil
            
            if keyExists {
                entity.model!.materials[0] = UnlitMaterial(color: .link)
                entity.model!.materials[0] = modelEntitiesMaterials[entity.name]!
            }
            
            if(entitiesState[entity.name] == .selected) {
                //Color blue the selected item
                entity.model?.materials[0] = selectedMaterial
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
        } else {
            //First unselect the previously selected entity.
            for entity in modelEntities {
                if(entitiesState[entity.name] == .selected) {
                    entitiesState[entity.name] = .unselected
                }
            }
            //Select the entity.
            entitiesState[selectedEntity.name] = .selected
        }
        colorModelEntities()
    }

    // MARK: - Selectors
    
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
                modelEntities.append(childModelEntity)
            }
        } else {
            for children in nameChildrens!.children {
                let childModelEntity = children as! ModelEntity
                childModelEntity.collision = CollisionComponent(shapes: [ShapeResource.generateConvex(from: childModelEntity.model!.mesh)])
                entitiesState[childModelEntity.name] = EntityState.unselected
                modelEntities.append(childModelEntity)
            }
        }

        let modelEntity = ModelEntity()
        modelEntity.addChild(entity)
        
        let anchorEntity = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: .zero))
        anchorEntity.addChild(modelEntity)

        arView.installGestures([.all],for: modelEntity)

        arView.scene.addAnchor(anchorEntity)
        
        focusSquare.isEnabled = false
        placeButton.isHidden = true
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
        
        let keyExists = modelEntitiesMaterials[entity.name] != nil
        
        if !keyExists {
            modelEntitiesMaterials[entity.name] = entity.model!.materials[0]
        }
        
        selectEntity(withSelectedEntity: entity)
        
        modelInformationView.configure(nameLabel: entity.name, textViewString: LoremSwiftum.Lorem.tweet)
        modelInformationView.isHidden = true
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
