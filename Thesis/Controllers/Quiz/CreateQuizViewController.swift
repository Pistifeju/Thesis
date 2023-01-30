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
    
    var currentIndex: Int {
        guard let vc = viewControllers?.first else { return 0 }
        return pages.firstIndex(of: vc) ?? 0
    }
    
    public var model: AnatomyModel?
    var pages = [UIViewController]()
    
    private var deleteCurrentQuestion: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .red
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular, scale: .small)
        let image = UIImage(systemName: "trash", withConfiguration: config)
        button.setImage(image, for: .normal)
        return button
    }()
    
    private var addNewQuestionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add a new question", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 1/255, green: 130/255, blue: 110/255, alpha: 1)
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
        deleteCurrentQuestion.addTarget(self, action: #selector(didTapDeleteCurrentQuestionButton), for: .touchUpInside)
        
        let firstPage = NewQuestionViewController()
        firstPage.view.tag = 0
        firstPage.title = "\(pages.count)"
        pages.append(firstPage)
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        
        self.setupUI()
    }
    
    // MARK: - Helpers
    private func setupUI() {
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissVC))
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.isHidden = false
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        view.addSubview(addNewQuestionButton)
        view.addSubview(deleteCurrentQuestion)
        
        NSLayoutConstraint.activate([
            addNewQuestionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: addNewQuestionButton.bottomAnchor, multiplier: 2),
            addNewQuestionButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08),
            
            deleteCurrentQuestion.centerYAnchor.constraint(equalTo: addNewQuestionButton.centerYAnchor),
            deleteCurrentQuestion.leadingAnchor.constraint(equalToSystemSpacingAfter: addNewQuestionButton.trailingAnchor, multiplier: 2),
        ])
    }
    
    // MARK: - Selectors
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
    
    @objc private func didTapDeleteCurrentQuestionButton() {
        guard pages.count != 1 else {
            let alert = UIAlertController(title: "", message: "You must have at least 1 question in your test", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
            present(alert, animated: true)
            return
        }
        
        pages.remove(at: currentIndex)
        setViewControllers([pages[pages.count - 1]], direction: .reverse, animated: true, completion: nil)
    }
    
    @objc private func didTapAddNewQuestionButton() {
        let newPage = NewQuestionViewController()
        pages.append(newPage)
        
        setViewControllers([pages[pages.count - 1]], direction: .forward, animated: true)
        newPage.view.tag = currentIndex
    }
}

extension CreateQuizViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
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
