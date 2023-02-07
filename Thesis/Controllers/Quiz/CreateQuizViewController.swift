//
//  CreateQuizViewController.swift
//  Thesis
//
//  Created by István Juhász on 2023. 01. 26..
//

import UIKit

class CreateQuizViewController: UIPageViewController {
    
    // MARK: - Properties
    
    private let initialPage = 0
    public var model: String?
    
    var currentIndex: Int {
        guard let vc = viewControllers?.first else { return 0 }
        return pages.firstIndex(of: vc) ?? 0
    }
    
    private let settingsPage = QuizSettingsViewController()
    var pages = [UIViewController]()
    
    private let numberOfQuestionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Question: 1/1"
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .callout).italic()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var deleteCurrentQuestionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .red
        let config = UIImage.SymbolConfiguration(pointSize: view.frame.size.width / 11, weight: .regular, scale: .small)
        let image = UIImage(systemName: "trash", withConfiguration: config)
        button.setImage(image, for: .normal)
        return button
    }()
    
    private lazy var testSettingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        let config = UIImage.SymbolConfiguration(pointSize: view.frame.size.width / 11, weight: .regular, scale: .small)
        let image = UIImage(systemName: "gearshape", withConfiguration: config)
        button.setImage(image, for: .normal)
        return button
    }()
    
    private var addNewQuestionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add a new question", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.greenButton
        button.layer.cornerRadius = 12
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        return button
    }()
    
    // MARK: - LifeCycle
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey: Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        addNewQuestionButton.addTarget(self, action: #selector(didTapAddNewQuestionButton), for: .touchUpInside)
        deleteCurrentQuestionButton.addTarget(self, action: #selector(didTapDeleteCurrentQuestionButton), for: .touchUpInside)
        testSettingsButton.addTarget(self, action: #selector(didTapTestSettingsButton), for: .touchUpInside)
        
        let firstPage = NewQuestionViewController()
        firstPage.view.tag = 0
        pages.append(firstPage)
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        
        self.setupUI()
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Finish", style: .plain, target: self, action: #selector(didTapFinishButton))
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.isHidden = false
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        view.addSubview(addNewQuestionButton)
        view.addSubview(deleteCurrentQuestionButton)
        view.addSubview(testSettingsButton)
        view.addSubview(numberOfQuestionsLabel)
        
        NSLayoutConstraint.activate([
            addNewQuestionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: addNewQuestionButton.bottomAnchor, multiplier: 2),
            addNewQuestionButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08),
            
            deleteCurrentQuestionButton.centerYAnchor.constraint(equalTo: addNewQuestionButton.centerYAnchor),
            deleteCurrentQuestionButton.leadingAnchor.constraint(equalToSystemSpacingAfter: addNewQuestionButton.trailingAnchor, multiplier: 2),
            
            testSettingsButton.centerYAnchor.constraint(equalTo: addNewQuestionButton.centerYAnchor),
            addNewQuestionButton.leadingAnchor.constraint(equalToSystemSpacingAfter: testSettingsButton.trailingAnchor, multiplier: 2),
            
            addNewQuestionButton.topAnchor.constraint(equalToSystemSpacingBelow: numberOfQuestionsLabel.bottomAnchor, multiplier: 2),
            numberOfQuestionsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func updateNumberOfQuestionsLabel(with index: Int) {
        numberOfQuestionsLabel.text = "Question: \(index)/\(pages.count)"
    }
    
    private func isQuizReady() -> Bool {
        var isReady = true
        for page in pages {
            let page = page as! NewQuestionViewController
            if !page.areQuestionsReady() {
                isReady = false
            }
        }
        
        return isReady
    }
    
    private func createQuiz() {
        guard let model = model else { return }
        
        settingsPage.createSettingsModel(model: model) { [weak self] settings in
            guard let strongSelf = self else { return }
            guard let settings = settings else {
                AlertManager.showQuizError(on: strongSelf, with: "Error Creating Test", and: "An unknown error occurred")
                return }
                        
            var questions: [Question] = []
            for page in strongSelf.pages {
                let page = page as! NewQuestionViewController
                
                if let question = page.createQuestion() {
                    questions.append(question)
                }
            }
            
            let quiz = Quiz(settings: settings, questions: questions)
            strongSelf.uploadQuizToFirebase(quiz: quiz)
        }
    }
    
    private func uploadQuizToFirebase(quiz: Quiz) {
        QuizService.shared.uploadNewQuiz(quiz: quiz) { [weak self] error in
            guard let strongSelf = self else { return }
            
            if let error = error {
                AlertManager.showCreateQuizError(on: strongSelf, with: error)
            }
            
            AlertManager.showCreateQuizAlert(on: strongSelf) {
                strongSelf.dismiss(animated: true)
            }
        }
    }
    
    // MARK: - Selectors
    
    @objc private func dismissVC() {
        AlertManager.showLeaveCurrentQuizAlert(on: self) {
            self.dismiss(animated: true)
        }
    }
    
    @objc private func didTapFinishButton() {
        if settingsPage.areSettingsReady() {
            if isQuizReady() {
                AlertManager.showFinishTestAlert(on: self, title: "Finish test", message: "Would you like to finish creating your test?", secondaryAction: "Finish") {
                    self.createQuiz()
                }
            } else {
                AlertManager.showIncompleteQuizError(on: self, with: "Test is incomplete", and: "Make sure to finish every question in the test")
            }
        } else {
            AlertManager.showIncompleteQuizError(on: self, with: "Settings are incomplete", and: "Please fill in the necessary fields in the settings panel.")
        }
    }
    
    @objc private func didTapDeleteCurrentQuestionButton() {
        guard pages.count != 1 else {
            AlertManager.showQuizError(on: self, with: "", and: "You must have at least 1 question in your test")
            return
        }
        
        pages.remove(at: currentIndex)
        if pages.count == 1 {
            setViewControllers([pages[currentIndex]], direction: .forward, animated: true, completion: nil)
        } else {
            setViewControllers([pages[currentIndex + 1]], direction: .forward, animated: true, completion: nil)
        }
        
        updateNumberOfQuestionsLabel(with: currentIndex + 1)
    }
    
    @objc private func didTapAddNewQuestionButton() {
        let newPage = NewQuestionViewController()
        pages.append(newPage)
        
        setViewControllers([pages[pages.count - 1]], direction: .forward, animated: true)
        newPage.view.tag = currentIndex
        
        updateNumberOfQuestionsLabel(with: currentIndex + 1)
    }
    
    @objc private func didTapTestSettingsButton() {
        present(settingsPage, animated: true)
    }
}

// MARK: - UIPageViewControllerDelegate, UIPageViewControllerDataSource

extension CreateQuizViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        updateNumberOfQuestionsLabel(with: currentIndex + 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        guard pages.count != 1 else { return nil }
                
        if currentIndex == 0 {
            return nil              // wrap last
        } else {
            return pages[currentIndex - 1]  // go previous
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        guard pages.count != 1 else { return nil }
                
        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]  // go next
        } else {
            return pages.first              // wrap to first
        }
    }
    
}
