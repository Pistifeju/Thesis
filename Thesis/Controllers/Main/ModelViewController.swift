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
        label.font = UIFont.systemFont(ofSize: 100)
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
        button.backgroundColor = .greenButton
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
        
        modelInformationLabel.text = self.model?.informationText
        
        setupUI()
    }
    
    // MARK: - Helpers
    private func setupUI() {
        self.view.backgroundColor = .white
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem?.tintColor = .black
        navigationController?.navigationBar.tintColor = .black
        
        view.addSubview(modelInformationLabel)
        view.addSubview(goToARLearningModeButton)
        view.addSubview(startTestButton)
        view.addSubview(createNewTestButton)
        
        NSLayoutConstraint.activate([
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: createNewTestButton.bottomAnchor, multiplier: 2),
            createNewTestButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            createNewTestButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            createNewTestButton.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: startTestButton.bottomAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: startTestButton.trailingAnchor, multiplier: 2),
            startTestButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            startTestButton.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            
            goToARLearningModeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createNewTestButton.topAnchor.constraint(equalToSystemSpacingBelow: goToARLearningModeButton.bottomAnchor, multiplier: 2),
            goToARLearningModeButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08),
            
            modelInformationLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            modelInformationLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: modelInformationLabel.trailingAnchor, multiplier: 2),
            goToARLearningModeButton.topAnchor.constraint(equalToSystemSpacingBelow: modelInformationLabel.bottomAnchor, multiplier: 2),
        ])
    }
    
    private func startTestCompletion(with code: String) {
        QuizService.shared.fetchIfUserAlreadyCompletedQuiz(quizCode: code) { [weak self] completed, error in
            guard let strongSelf = self else { return }
            if let error = error {
                AlertManager.showQuizError(on: strongSelf, with: "Error Starting Test", and: error.localizedDescription)
                return
            }
            
            guard let completed = completed else { return }
            
            if completed {
                AlertManager.showQuizError(on: strongSelf, with: "Test already completed", and: "You have already completed this test.")
                return
            } else {
                QuizService.shared.fetchQuiz(with: code) { [weak self] quiz, quizCode, error in
                    if let error = error {
                        AlertManager.showQuizError(on: strongSelf, with: "Error Starting Test", and: error.localizedDescription)
                        return
                    }
                    
                    guard let quiz = quiz, let quizCode = quizCode else {
                        AlertManager.showQuizError(on: strongSelf, with: "Wrong Code", and: "Sorry, we couldn't find a test with that code.")
                        return
                    }
                    
                    if let customTabBarController = strongSelf.tabBarController as? MainTabController {
                        if let user = customTabBarController.user {
                            let vc = QuizPageViewController(quiz: quiz, user: user, quizCode: quizCode)
                            let nav = UINavigationController(rootViewController: vc)
                            nav.modalPresentationStyle = .fullScreen
                            strongSelf.present(nav, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Selectors
    
    @objc private func didTapStartTestButton() {
        let ac = UIAlertController(title: "Enter test code", message: "Enter the test code in order to start the test.", preferredStyle: .alert)
        ac.addTextField()
        ac.textFields![0].placeholder = "A678GH-76DFRT"
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        let submitAction = UIAlertAction(title: "Start", style: .default) { [unowned ac] _ in
            let code = ac.textFields![0].text
            guard let code = code else { return }
            self.startTestCompletion(with: code)
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
        
        let vc = ARViewController(with: model, fromTest: false)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    @objc private func didTapCreateNewTestButton() {
        guard let model = model, let name = model.name else {
            return
        }
        
        let vc = CreateQuizViewController()
        vc.title = "Create a New Test"
        vc.model = name
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}
