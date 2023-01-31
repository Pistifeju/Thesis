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
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private var goToARLearningModeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go to AR Learning Mode", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 1/255, green: 130/255, blue: 110/255, alpha: 1)
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        return button
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        goToARLearningModeButton.addTarget(self, action: #selector(didTapGoToARLearningModeButton), for: .touchUpInside)
        createNewTestButton.addTarget(self, action: #selector(didTapCreateNewTestButton), for: .touchUpInside)
        startTestButton.addTarget(self, action: #selector(didTapStartTestButton), for: .touchUpInside)
        
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
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: createNewTestButton.bottomAnchor, multiplier: 2),
            createNewTestButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            createNewTestButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            createNewTestButton.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            
            goToARLearningModeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createNewTestButton.topAnchor.constraint(equalToSystemSpacingBelow: goToARLearningModeButton.bottomAnchor, multiplier: 1),
            goToARLearningModeButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08),
            
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: startTestButton.bottomAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: startTestButton.trailingAnchor, multiplier: 2),
            startTestButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            startTestButton.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            
            modelInformationLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            modelInformationLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: modelInformationLabel.trailingAnchor, multiplier: 2),
            goToARLearningModeButton.topAnchor.constraint(equalToSystemSpacingBelow: modelInformationLabel.bottomAnchor, multiplier: 2),
        ])
    }
    
    // MARK: - Selectors
    
    @objc private func didTapStartTestButton() {
        let ac = UIAlertController(title: "Enter test code", message: "Enter the test code in order to start the test.", preferredStyle: .alert)
        ac.addTextField()
        ac.textFields![0].placeholder = "A678GH-76DFRT"
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        let submitAction = UIAlertAction(title: "Start", style: .default) { [unowned ac] _ in
            let code = ac.textFields![0].text
        }
        
        ac.addAction(cancelAction)
        ac.addAction(submitAction)
        
        present(ac, animated: true)
    }
    
    @objc private func dismissVC() {
        navigationController?.popViewController(animated: true)
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
    
    @objc private func didTapCreateNewTestButton() {
        let vc = CreateQuizViewController()
        vc.model = model
        vc.title = "Create a New Test"
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}
