//
//  QuizStatsViewController.swift
//  Thesis
//
//  Created by István Juhász on 2023. 03. 07..
//

import Foundation
import UIKit

class QuizStatsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.isHidden = false
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let quiz: Quiz
    
    private var stats: [QuizUserStat]?
    
    private let completionStatsView = CompletionStatsView(frame: .zero)
    
    private let dividerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.tintColor = .black
        return view
    }()
    
    private let statsEmptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No one has yet completed this test."
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
    
    private let completionsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Completions"
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textAlignment = .left
        label.isHidden = true
        return label
    }()
    
    private let completionsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CompletionsStatsUITableViewCell.self, forCellReuseIdentifier: CompletionsStatsUITableViewCell.identifier)
        tableView.isHidden = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        tableView.allowsSelection = false
        return tableView
    }()
    
    // MARK: - LifeCycle
    
    init(quiz: Quiz) {
        self.quiz = quiz
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        completionsTableView.delegate = self
        completionsTableView.dataSource = self
        
        configureUI()
        self.fetchStats()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        completionStatsView.isHidden = true
        dividerView.isHidden = true
        view.backgroundColor = .white
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .white
        title = quiz.name
        
        view.addSubview(spinner)
        spinner.startAnimating()
        view.addSubview(statsEmptyLabel)
        view.addSubview(dividerView)
        view.addSubview(completionsLabel)
        view.addSubview(completionStatsView)
        view.addSubview(completionsTableView)
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            statsEmptyLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: statsEmptyLabel.trailingAnchor, multiplier: 2),
            statsEmptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statsEmptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            dividerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dividerView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 0),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: dividerView.trailingAnchor, multiplier: 0),
            dividerView.heightAnchor.constraint(equalToConstant: 2),
            
            completionStatsView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: completionStatsView.trailingAnchor, multiplier: 2),
            completionStatsView.topAnchor.constraint(equalToSystemSpacingBelow: dividerView.bottomAnchor, multiplier: 2),
            
            completionsLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            completionsLabel.topAnchor.constraint(equalToSystemSpacingBelow: completionStatsView.bottomAnchor, multiplier: 2),
            
            completionsTableView.topAnchor.constraint(equalToSystemSpacingBelow: completionsLabel.bottomAnchor, multiplier: 2),
            completionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            completionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            completionsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func fetchStats() {
        QuizService.shared.fetchUsersForQuiz(quizCode: quiz.code) { [weak self] stats, error in
            guard let strongSelf = self else { return }
            if error != nil {
                AlertManager.showBasicErrorAlert(on: strongSelf, with: "Error loading statistics.", and: "Please try again later.")
            }
            
            if let stats {
                strongSelf.stats = stats
                strongSelf.completionStatsView.configure(stats: stats)
                strongSelf.showStats()
                DispatchQueue.main.async {
                    strongSelf.completionsTableView.reloadData()
                }
            }
        }
    }
    
    private func showStats() {
        guard let stats = stats else { return }
        if !stats.isEmpty {
            dividerView.isHidden = false
            completionStatsView.isHidden = false
            completionsLabel.isHidden = false
            completionsTableView.isHidden = false
        } else {
            statsEmptyLabel.isHidden = false
        }
        
        spinner.stopAnimating()
        spinner.isHidden = true
    }
    
    // MARK: - Selectors
}

// MARK: - UITableViewDelegate

extension QuizStatsViewController: UITableViewDelegate {    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        view.layoutIfNeeded()
        return completionsLabel.frame.height * 1.5
    }
}

// MARK: - UITableViewDataSource

extension QuizStatsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stats?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let stats = stats, let cell = tableView.dequeueReusableCell(withIdentifier: CompletionsStatsUITableViewCell.identifier, for: indexPath) as? CompletionsStatsUITableViewCell else {
            return UITableViewCell.init()
        }

        cell.configure(stats: stats[indexPath.row])
        return cell
    }
}
