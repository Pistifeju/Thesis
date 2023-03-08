//
//  ProfileViewController.swift
//  Thesis
//
//  Created by István Juhász on 2023. 01. 30..
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    private var completedQuizzes: [CompletedQuiz]?
    private var yourQuizzes: [Quiz]?
    
    private lazy var yourQuizzesRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.translatesAutoresizingMaskIntoConstraints = false
        refreshControl.addTarget(self, action: #selector(didRefreshYourQuizzes), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var completedQuizzesRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.translatesAutoresizingMaskIntoConstraints = false
        refreshControl.addTarget(self, action: #selector(didRefreshCompletedQuizzes), for: .valueChanged)
        return refreshControl
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private let completedQuizzesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let yourQuizzesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        return collectionView
    }()
    
    private let user: User
    
    private let quizzesSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl()
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.backgroundColor = .lightGray.withAlphaComponent(0.3)
        sc.selectedSegmentTintColor = .white
        sc.tintColor = .black
        sc.insertSegment(withTitle: "Completed Quizzes", at: 0, animated: true)
        sc.insertSegment(withTitle: "Your Quizzes", at: 1, animated: true)
        return sc
    }()
    
    // MARK: - LifeCycle
    
    init(user: User) {
        self.user = user
        self.spinner.startAnimating()
        super.init(nibName: nil, bundle: nil)
        title = user.username
        fetchCompletedQuizzes()
        fetchYourQuizzes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .done, target: self, action: #selector(didTapSignOut))
        
        quizzesSegmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        setupCollectionViews()
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(spinner)
        view.addSubview(quizzesSegmentedControl)
        quizzesSegmentedControl.selectedSegmentIndex = 0
        view.addSubview(completedQuizzesCollectionView)
        view.addSubview(yourQuizzesCollectionView)
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            quizzesSegmentedControl.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1),
            quizzesSegmentedControl.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: quizzesSegmentedControl.trailingAnchor, multiplier: 2),
            
            completedQuizzesCollectionView.topAnchor.constraint(equalToSystemSpacingBelow: quizzesSegmentedControl.bottomAnchor, multiplier: 2),
            completedQuizzesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            completedQuizzesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            completedQuizzesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            yourQuizzesCollectionView.topAnchor.constraint(equalToSystemSpacingBelow: quizzesSegmentedControl.bottomAnchor, multiplier: 2),
            yourQuizzesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            yourQuizzesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            yourQuizzesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupCollectionViews() {
        let layout = UICollectionViewFlowLayout()
        let cellSize = CGSize(width: view.frame.width - 32, height: view.frame.width / 4.5)
        layout.itemSize = cellSize
        layout.scrollDirection = .vertical
        completedQuizzesCollectionView.setCollectionViewLayout(layout, animated: true)
        completedQuizzesCollectionView.register(ProfileCompletedQuizCollectionViewCell.self, forCellWithReuseIdentifier: ProfileCompletedQuizCollectionViewCell.identifier)
        completedQuizzesCollectionView.delegate = self
        completedQuizzesCollectionView.dataSource = self
        completedQuizzesCollectionView.refreshControl = completedQuizzesRefreshControl
        
        yourQuizzesCollectionView.setCollectionViewLayout(layout, animated: true)
        yourQuizzesCollectionView.register(ProfileYourQuizCollectionViewCell.self, forCellWithReuseIdentifier: ProfileYourQuizCollectionViewCell.identifier)
        yourQuizzesCollectionView.delegate = self
        yourQuizzesCollectionView.dataSource = self
        yourQuizzesCollectionView.refreshControl = yourQuizzesRefreshControl
    }
    
    private func fetchCompletedQuizzes() {
        QuizService.shared.fetchCompletedQuizzes { [weak self] completedQuiz, error in
            guard let strongSelf = self else { return }
            if let error = error {
                print(String(describing: error))
            }
            
            strongSelf.completedQuizzesRefreshControl.endRefreshing()
            guard let completedQuizzes = completedQuiz else { return }
            
            strongSelf.completedQuizzes = completedQuizzes
            strongSelf.spinner.stopAnimating()
            
            DispatchQueue.main.async {
                strongSelf.completedQuizzesCollectionView.reloadData()
            }
        }
    }
    
    private func fetchYourQuizzes() {
        QuizService.shared.fetchAllQuizzesForUser { [weak self] quizzes, error in
            guard let strongSelf = self else { return }
            
            if let error = error {
                print(String(describing: error))
            }
            
            strongSelf.yourQuizzesRefreshControl.endRefreshing()
            guard let quizzes = quizzes else { return }
            
            strongSelf.yourQuizzes = quizzes
            DispatchQueue.main.async {
                strongSelf.yourQuizzesCollectionView.reloadData()
            }
        }
    }
    
    // MARK: - Selectors
    
    @objc private func didRefreshCompletedQuizzes() {
        completedQuizzesRefreshControl.isHidden = false
        completedQuizzesRefreshControl.beginRefreshing()
        fetchCompletedQuizzes()
    }
    
    @objc private func didRefreshYourQuizzes() {
        yourQuizzesRefreshControl.isHidden = false
        yourQuizzesRefreshControl.beginRefreshing()
        fetchYourQuizzes()
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            yourQuizzesCollectionView.isHidden = true
            completedQuizzesCollectionView.isHidden = false
        } else {
            yourQuizzesCollectionView.isHidden = false
            completedQuizzesCollectionView.isHidden = true
        }
    }
    
    @objc private func didTapSignOut() {
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            AuthService.shared.signOut { [weak self] error in
                guard let strongSelf = self else { return }
                if let error = error {
                    AlertManager.showLogoutErrorAlert(on: strongSelf, with: error)
                    return
                }
                
                if let sceneDelegate = strongSelf.view.window?.windowScene?.delegate as? SceneDelegate {
                    sceneDelegate.checkAuthentication()
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if collectionView == completedQuizzesCollectionView {
            guard let completedQuizzes = completedQuizzes else { return }
            let vc = EndOfQuizController(completedQuiz: completedQuizzes[indexPath.row], user: user)
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        } else {
            guard let yourQuizzes = yourQuizzes else { return }
            let vc = QuizStatsViewController(quiz: yourQuizzes[indexPath.row])
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == completedQuizzesCollectionView {
            guard let completedQuizzes = completedQuizzes else { return 0 }
            return completedQuizzes.count
        } else {
            guard let yourQuizzes = yourQuizzes else { return 0 }
            return yourQuizzes.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == completedQuizzesCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCompletedQuizCollectionViewCell.identifier, for: indexPath) as? ProfileCompletedQuizCollectionViewCell, let completedQuizzes = completedQuizzes else {
                return UICollectionViewCell.init()
            }
            cell.configure(with: completedQuizzes[indexPath.row])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileYourQuizCollectionViewCell.identifier, for: indexPath) as? ProfileYourQuizCollectionViewCell, let yourQuizzes = yourQuizzes else {
                return UICollectionViewCell.init()
            }
            
            cell.configure(with: yourQuizzes[indexPath.row])
            return cell
        }
        
        
    }
}
