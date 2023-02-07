//
//  QuizPageViewController.swift
//  Thesis
//
//  Created by István Juhász on 2022. 11. 28..
//
//7UYQ1Y-4I920G
import UIKit

class QuizPageViewController: UIPageViewController {
    
    // MARK: - Properties
    
    private let initialPage = 0
    private var pages = [UIViewController]()
    
    private let modelName: String
    
    var currentIndex: Int {
        guard let vc = viewControllers?.first else { return 0 }
        return pages.firstIndex(of: vc) ?? 0
    }
    
    private var quiz: Quiz {
        didSet {
            updateUI(with: 1)
        }
    }
    
    private var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = UIColor.greenButton
        progressView.trackTintColor = .lightGray
        progressView.progressViewStyle = .bar
        return progressView
    }()
    
    private lazy var questionsIndexLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "error"
        return label
    }()
    
    private var goToARModeButton = QuizCustomNavigationButton(title: "Start AR Mode")
    private var submitButton = QuizCustomNavigationButton(title: "Submit")
    
    // MARK: - Lifecycle
    
    init(quiz: Quiz, modelName: String) {
        self.quiz = quiz
        self.modelName = modelName
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        goToARModeButton.addTarget(self, action: #selector(didTapGoToARMode), for: .touchUpInside)
        
        createPages()
        
        submitButton.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)
        
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func createPages() {
        for question in quiz.questions {
            let vc = QuizViewController(question: question, modelName: modelName)
            pages.append(vc)
        }
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        
        updateUI(with: 1)
    }
    
    private func configureUI() {
        title = quiz.name
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(didPressExit))
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        
        view.addSubview(submitButton)
        view.addSubview(questionsIndexLabel)
        view.addSubview(progressView)
        view.addSubview(goToARModeButton)
        
        NSLayoutConstraint.activate([
            submitButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: submitButton.trailingAnchor, multiplier: 4),
            submitButton.widthAnchor.constraint(equalToConstant: view.frame.size.width / 4),
            submitButton.heightAnchor.constraint(equalToConstant: view.frame.size.width / 9),
            
            questionsIndexLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 4),
            questionsIndexLabel.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor),
            
            progressView.heightAnchor.constraint(equalTo: submitButton.heightAnchor, multiplier: 0.10),
            progressView.topAnchor.constraint(equalToSystemSpacingBelow: submitButton.bottomAnchor, multiplier: 2),
            progressView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 4),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: progressView.trailingAnchor, multiplier: 4),
            
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: goToARModeButton.bottomAnchor, multiplier: 1),
            goToARModeButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 4),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: goToARModeButton.trailingAnchor, multiplier: 4),
            goToARModeButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07),
        ])
        
        if !quiz.allowARMode {
            goToARModeButton.isHidden = true
        }
    }
    
    private func updateUI(with index: Int) {
        questionsIndexLabel.text = "Question \(index)/\(pages.count)"
        updateProgressView()
    }
    
    private func updateProgressView() {
        UIView.animate(withDuration: 0.5) {
            self.progressView.setProgress(Float(self.currentIndex + 1) / Float(self.quiz.questions.count), animated: true)
        }
    }
    
    // MARK: - Selectors
    
    @objc private func didPressExit() {
        // TODO: - Finish DidPressExit
    }
    
    @objc private func didTapSubmit() {
        // TODO: - Finish didTapSubmit
        var userAnswers: [[String]] = []
        
        for page in pages {
            if page is QuizViewController {
                let vc = page as! QuizViewController
                userAnswers.append(vc.returnUserAnswers())
            }
        }
        
        AlertManager.showFinishTestAlert(on: self, title: "Submit test", message: "Would you like to submit your test?", secondaryAction: "Submit") {
            
            let vc = EndOfQuizController(quiz: self.quiz, userAnswers: userAnswers)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func didTapGoToARMode() {
        if let encoded = UserDefaults.standard.data(forKey: "skeletalModels"), let anatomyModels = try? JSONDecoder().decode([AnatomyModel].self, from: encoded) {
            
            var model = AnatomyModel()
            for anatomyModel in anatomyModels {
                if let name = anatomyModel.name {
                    if name == modelName {
                        model = anatomyModel
                        break
                    }
                }
            }
            
            let vc = ARViewController(with: model, fromTest: true)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UIPageViewControllerDelegate, UIPageViewControllerDataSource

extension QuizPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        updateUI(with: currentIndex + 1)
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
