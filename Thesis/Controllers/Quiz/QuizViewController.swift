//
//  QuizViewController.swift
//  Thesis
//
//  Created by István Juhász on 2022. 11. 28..
//

import UIKit
import RealmSwift

class QuizViewController: UIViewController {
    
    // MARK: - Properties
    
    public var questions: [Question] = []
    public var questionsIndex: Int = 0 {
        didSet {
            questionsIndexLabel.text = "\(questionsIndex+1)/\(questions.count)"
            backButton.isHidden = questionsIndex == 0 ? true : false
            nextButton.isHidden = questionsIndex == questions.count - 1 ? true : false
        }
    }
    
    private var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = UIColor(red: 162/255, green: 210/255, blue: 255/255, alpha: 1)
        progressView.trackTintColor = .lightGray
        
        return progressView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(QuestionView.self, forCellWithReuseIdentifier: "questionCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    private lazy var questionsIndexLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(questionsIndex+1)/\(questions.count)"
        
        return label
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor(red: 255/255, green: 175/255, blue: 204/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor(red: 162/255, green: 210/255, blue: 255/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor(red: 255/255, green: 175/255, blue: 204/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.reloadData()
        
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(didPressExit))
        navigationController?.navigationBar.topItem?.leftBarButtonItem?.tintColor = .black
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(submitButton)
        view.addSubview(questionsIndexLabel)
        view.addSubview(backButton)
        view.addSubview(nextButton)
        view.addSubview(collectionView)
        view.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            submitButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: submitButton.trailingAnchor, multiplier: 4),
            submitButton.widthAnchor.constraint(equalToConstant: view.frame.size.width / 4),
            submitButton.heightAnchor.constraint(equalToConstant: view.frame.size.width / 9),
            
            questionsIndexLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 4),
            questionsIndexLabel.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor),
            
            progressView.heightAnchor.constraint(equalToConstant: 5),
            progressView.topAnchor.constraint(equalToSystemSpacingBelow: submitButton.bottomAnchor, multiplier: 2),
            progressView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 4),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: progressView.trailingAnchor, multiplier: 4),
            
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: backButton.bottomAnchor, multiplier: 2),
            backButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 4),
            backButton.widthAnchor.constraint(equalToConstant: view.frame.size.width / 4),
            backButton.heightAnchor.constraint(equalToConstant: view.frame.size.width / 9),
                        
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: nextButton.bottomAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: nextButton.trailingAnchor, multiplier: 4),
            nextButton.widthAnchor.constraint(equalToConstant: view.frame.size.width / 4),
            nextButton.heightAnchor.constraint(equalToConstant: view.frame.size.width / 9),

            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 4),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: collectionView.trailingAnchor, multiplier: 4),
            collectionView.topAnchor.constraint(equalToSystemSpacingBelow: progressView.bottomAnchor, multiplier: 2),
            collectionView.bottomAnchor.constraint(equalToSystemSpacingBelow: nextButton.topAnchor, multiplier: -2),
        ])
    }
    
    // MARK: - Selectors
    
    @objc private func didPressExit() {
        let realm = try! Realm()
        let alert = UIAlertController(title: "Do you want to exit?", message: "Your answers will not be saved.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] action in
            guard let strongSelf = self else { return }
            for question in strongSelf.questions {
                try! realm.write {
                    question.selectedIndex = -1
                }
            }
            self?.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: { _ in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func didTapNext() {
        self.collectionView.scrollToItem(at: IndexPath(item: questionsIndex+1, section: 0), at: .right, animated: true)
    }
    
    @objc private func didTapBack() {
        self.collectionView.scrollToItem(at: IndexPath(item: questionsIndex-1, section: 0), at: .left, animated: true)
    }
    
    @objc private func didTapSubmit() {
        let alert = UIAlertController(title: "Do you want to submit your answers?", message: progressView.progress != 1.0 ? "There are unanswered questions." : "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] action in
            guard let strongSelf = self else {
                return
            }
            let vc = EndOfQuizController()
            vc.questions = strongSelf.questions
            strongSelf.navigationController?.pushViewController(vc, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: { _ in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension QuizViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.questionsIndex = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "questionCell", for: indexPath) as! QuestionView
        cell.configure(with: questions[indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

// MARK: -

extension QuizViewController: QuestionViewDelegate {
    func didSelectAnswer(with question: Question) {
        progressView.setProgress(progressView.progress + 1.0 / Float(questions.count), animated: true)
    }
    
    func didUnselectAnswer(with question: Question) {
        progressView.setProgress(progressView.progress - 1.0 / Float(questions.count), animated: true)
    }
}
