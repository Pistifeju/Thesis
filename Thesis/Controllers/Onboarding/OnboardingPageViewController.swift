//
//  OnboardingPageViewController.swift
//  Thesis
//
//  Created by István Juhász on 2022. 11. 12..
//

import Foundation
import UIKit

class OnboardingPageViewController: UIPageViewController {

    var pages = [UIViewController]()
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Colors.buttonGrey
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("CONTINUE", for: .normal)
        button.addTarget(self, action: #selector(continueTapped(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 16
        
        return button
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .systemGray2
        pageControl.currentPage = initialPage
        pageControl.backgroundStyle = .automatic
        
        return pageControl
    }()
    
    private let initialPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        configureUI()
    }
    
    private func setup() {
        dataSource = self
        delegate = self
        
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
        
        let page1 = OnboardingViewController(imageName: "onboarding1",
                                             titleText: "Welcome to AR Anatomy",
                                             subtitleText: "A unique application for learning anatomy with AR.")
        let page2 = OnboardingViewController(imageName: "onboarding2",
                                             titleText: "Explore",
                                             subtitleText: "Explore the human body through your phone.")
        let page3 = OnboardingViewController(imageName: "onboarding3",
                                             titleText: "Take Tests",
                                             subtitleText: "Tests are designed to consolidate the material covered, which allows you to test your knowledge.")
        
        // TODO: - Page3 onboarding image
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        
        pageControl.numberOfPages = pages.count

        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
    }
    
    private func configureUI() {
        navigationController?.navigationBar.tintColor = .white
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(skipTapped))
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        view.addSubview(pageControl)
        view.addSubview(continueButton)
        
        NSLayoutConstraint.activate([
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: continueButton.bottomAnchor, multiplier: 4),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.heightAnchor.constraint(equalToConstant: view.frame.height / 14),
            continueButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: continueButton.trailingAnchor, multiplier: 2),
            
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.topAnchor.constraint(equalToSystemSpacingBelow: pageControl.bottomAnchor, multiplier: 2),
        ])
    }
    
    fileprivate func didOnboard() {
        dismiss(animated: true)
        
        UserDefaults.standard.set(true, forKey: "hasOnboarded")
        
        let layout = UICollectionViewFlowLayout()
        let controller = MainViewController(collectionViewLayout: layout)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalTransitionStyle = .coverVertical
        nav.modalPresentationStyle = .fullScreen
        
        self.present(nav, animated: true)
    }
}

// MARK: - UIPageViewControllerDataSource

extension OnboardingPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
                
        if currentIndex == 0 {
            return nil              // wrap last
        } else {
            return pages[currentIndex - 1]  // go previous
        }
    }
        
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
       
        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]  // go next
        } else {
            if(pageControl.currentPage == pages.count - 1) {
                didOnboard()
            } 
            return nil
        }
    }
}

// MARK: - UIPageViewControllerDelegate

extension OnboardingPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
        
        pageControl.currentPage = currentIndex
    }
}

// MARK: - Actions

extension OnboardingPageViewController {

    @objc func pageControlTapped(_ sender: UIPageControl) {
        setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true, completion: nil)
    }
    
    @objc func skipTapped() {
        didOnboard()
    }
    
    @objc func continueTapped(_ sender: UIButton) {
        if(pageControl.currentPage == pages.count - 1) {
            didOnboard()
        } else {
            pageControl.currentPage += 1
            goToNextPage()
        }
    }
}

// MARK: - Extensions

extension OnboardingPageViewController {

    func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let currentPage = viewControllers?[0] else { return }
        guard let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentPage) else { return }
        
        setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
    }
    
    func goToPreviousPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let currentPage = viewControllers?[0] else { return }
        guard let prevPage = dataSource?.pageViewController(self, viewControllerBefore: currentPage) else { return }
        
        setViewControllers([prevPage], direction: .forward, animated: animated, completion: completion)
    }
    
    func goToSpecificPage(index: Int, ofViewControllers pages: [UIViewController]) {
        setViewControllers([pages[index]], direction: .forward, animated: true, completion: nil)
    }
}
