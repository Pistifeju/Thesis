//
//  ModelViewController.swift
//  Thesis
//
//  Created by István Juhász on 2023. 01. 19..
//

import UIKit

class ModelViewController: UIViewController {
    
    // MARK: - Properties
    
    public var model: AnatomyModel?
    
    private var startNewTestPopUpView = StartNewTestPopUpView()
    
    private var createNewTestButton = ModelControllerAddButton(title: "create test", imageName: "list.bullet.clipboard")
    private var startTestButton = ModelControllerAddButton(title: "start test", imageName: "plus")
    
    private let modelInformationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .body, compatibleWith: .none)
        label.numberOfLines = 0
        label.text = "Error"
        label.textAlignment = .justified
        return label
    }()
    
    private var goToARLearningModeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go to AR Learning Mode", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 162/255, green: 210/255, blue: 255/255, alpha: 1)
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        return button
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startNewTestPopUpView.delegate = self
        
        goToARLearningModeButton.addTarget(self, action: #selector(didTapGoToARLearningModeButton), for: .touchUpInside)
        createNewTestButton.addTarget(self, action: #selector(didTapCreateNewTestButton), for: .touchUpInside)
        startTestButton.addTarget(self, action: #selector(didTapStartTestButtonButton), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "clock.arrow.circlepath"), style: .plain, target: self, action: #selector(didTapHistoryButton))
        
        modelInformationLabel.text = self.model?.informationText
        
        setupUI()
    }
    
    // MARK: - Helpers
    private func setupUI() {
        self.view.backgroundColor = .white
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.isHidden = false
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        view.addSubview(modelInformationLabel)
        view.addSubview(goToARLearningModeButton)
        view.addSubview(startTestButton)
        view.addSubview(createNewTestButton)
        
        NSLayoutConstraint.activate([
            modelInformationLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            modelInformationLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: modelInformationLabel.trailingAnchor, multiplier: 2),
            
            goToARLearningModeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goToARLearningModeButton.topAnchor.constraint(equalToSystemSpacingBelow: modelInformationLabel.bottomAnchor, multiplier: 2),
            goToARLearningModeButton.heightAnchor.constraint(equalToConstant: 45),
            
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: startTestButton.bottomAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: startTestButton.trailingAnchor, multiplier: 2),
            startTestButton.heightAnchor.constraint(equalToConstant: 100),
            startTestButton.widthAnchor.constraint(equalToConstant: 100),
            
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: createNewTestButton.bottomAnchor, multiplier: 2),
            createNewTestButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            createNewTestButton.heightAnchor.constraint(equalToConstant: 100),
            createNewTestButton.widthAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    private func addStartNewTestPopUpViewToView() {
        view.addSubview(startNewTestPopUpView)
        
        NSLayoutConstraint.activate([
            startNewTestPopUpView.topAnchor.constraint(equalTo: view.topAnchor),
            startNewTestPopUpView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            startNewTestPopUpView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            startNewTestPopUpView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    // MARK: - Selectors
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
    
    @objc private func didTapGoToARLearningModeButton() {
        guard let model = model else {
            return
        }
        
        let vc = ARViewController(with: model)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapHistoryButton() {
        
    }
    
    @objc private func didTapStartTestButtonButton() {
        DispatchQueue.main.async {
            self.addStartNewTestPopUpViewToView()
            self.startNewTestPopUpView.animateIn()
        }
    }
    
    @objc private func didTapCreateNewTestButton() {
        
    }
}

// MARK: - StartNewTestPopUpViewDelegate

extension ModelViewController: StartNewTestPopUpViewDelegate {
    func didTapBackButton() {
        startNewTestPopUpView.removeFromSuperview()
    }
}
