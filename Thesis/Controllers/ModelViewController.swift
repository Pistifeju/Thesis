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
    
    private let yourQuizzesTableView: UITableView = {
        let tb = UITableView(frame: .zero)
        tb.backgroundColor = .orange
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.rowHeight = 20
        tb.isScrollEnabled = true
        return tb
    }()
        
    private var goToARLearningModeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Go to AR Learning Mode", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 162/255, green: 210/255, blue: 255/255, alpha: 1)
        button.layer.cornerRadius = 8
        return button
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goToARLearningModeButton.addTarget(self, action: #selector(goToARLearningModeButtonPressed), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissVC))
                
        self.setupUI()
    }
    
    // MARK: - Helpers
    private func setupUI() {
        self.view.backgroundColor = .white
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.isHidden = false
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        view.addSubview(goToARLearningModeButton)
        
        NSLayoutConstraint.activate([
            goToARLearningModeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goToARLearningModeButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1),
        ])
    }
    
    private func loadModel() {
        
    }
    
    // MARK: - Selectors
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
    
    @objc private func goToARLearningModeButtonPressed() {
        guard let model = model else {
            return
        }
        let vc = ARViewController(with: model)
        navigationController?.pushViewController(vc, animated: true)
    }
}
