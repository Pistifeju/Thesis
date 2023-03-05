//
//  ProfileViewController.swift
//  Thesis
//
//  Created by István Juhász on 2023. 01. 30..
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Properties

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.translatesAutoresizingMaskIntoConstraints = false
        refreshControl.addTarget(self, action: #selector(didRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    private var completedQuizzes: [CompletedQuiz]?
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private lazy var quizzesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cellSize = CGSize(width: view.frame.width - 32, height: view.frame.width / 4.5)
        layout.itemSize = cellSize
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
        self.completedQuizzes = []
        super.init(nibName: nil, bundle: nil)
        title = user.username
        fetchCompletedQuizzes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        
        quizzesCollectionView.register(ProfileQuizCollectionViewCell.self, forCellWithReuseIdentifier: ProfileQuizCollectionViewCell.identifier)
        quizzesCollectionView.delegate = self
        quizzesCollectionView.dataSource = self
        quizzesCollectionView.refreshControl = refreshControl
        
        configureUI()
    }
    
    private func fetchCompletedQuizzes() {
        QuizService.shared.fetchCompletedQuizzes { [weak self] completedQuiz, error in
            guard let strongSelf = self else { return }
            if let error = error {
                print(String(describing: error))
            }
            guard let completedQuizzes = completedQuiz else { return }
            
            strongSelf.refreshControl.endRefreshing()
            strongSelf.completedQuizzes = completedQuizzes
            strongSelf.spinner.stopAnimating()
            
            DispatchQueue.main.async {
                strongSelf.quizzesCollectionView.reloadData()
            }
        }
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(spinner)
        view.addSubview(quizzesSegmentedControl)
        quizzesSegmentedControl.selectedSegmentIndex = 0
        view.addSubview(quizzesCollectionView)
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            quizzesSegmentedControl.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1),
            quizzesSegmentedControl.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: quizzesSegmentedControl.trailingAnchor, multiplier: 2),
            
            quizzesCollectionView.topAnchor.constraint(equalToSystemSpacingBelow: quizzesSegmentedControl.bottomAnchor, multiplier: 2),
            quizzesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            quizzesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            quizzesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // MARK: - Selectors
    
    @objc private func didRefresh() {
        refreshControl.beginRefreshing()
        fetchCompletedQuizzes()
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let completedQuizzes = completedQuizzes else { return }
        
        let vc = EndOfQuizController(completedQuiz: completedQuizzes[indexPath.row], user: user)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let completedQuizzes = completedQuizzes else { return 0 }
        return completedQuizzes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileQuizCollectionViewCell.identifier, for: indexPath) as? ProfileQuizCollectionViewCell, let completedQuizzes = completedQuizzes else {
            return UICollectionViewCell.init()
        }
        cell.configure(with: completedQuizzes[indexPath.row])
        return cell
    }
}
