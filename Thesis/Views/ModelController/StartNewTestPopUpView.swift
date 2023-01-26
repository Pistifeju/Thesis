//
//  StartNewTestPopUpView.swift
//  Thesis
//
//  Created by István Juhász on 2023. 01. 25..
//

import UIKit

protocol StartNewTestPopUpViewDelegate: AnyObject {
    func didTapBackButton()
}

class StartNewTestPopUpView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: StartNewTestPopUpViewDelegate?
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        return view
    }()
    
    private let enterCodeLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter Test Code"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let testCodeTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.attributedPlaceholder = NSAttributedString(string: "GF5763-FFGSD2", attributes: [.foregroundColor: UIColor.systemGray])
        tf.autocapitalizationType = .allCharacters
        tf.textAlignment = .center
        tf.textColor = .black
        tf.backgroundColor = .systemGray.withAlphaComponent(0.1)
        tf.layer.cornerRadius = 8
        return tf
    }()
    
    private let menuButton = PopUpViewButton(with: "Start")
    private let backButton = PopUpViewButton(with: "Back")
    
    // MARK: - Lifecycle
    
    init() {
        super.init(frame: .zero)
        
        self.frame = UIScreen.main.bounds
        
        menuButton.addTarget(self, action: #selector(didTapStart), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .gray
        backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        
        let stackView = UIStackView(arrangedSubviews: [enterCodeLabel, testCodeTextField])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.spacing = 10
        
        addSubview(container)
        container.addSubview(menuButton)
        container.addSubview(backButton)
        container.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3),
            container.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6),
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            stackView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: container.topAnchor, multiplier: 4),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: container.leadingAnchor, multiplier: 2),
            container.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2),
            
            testCodeTextField.heightAnchor.constraint(equalToConstant: 50),
            testCodeTextField.leadingAnchor.constraint(equalToSystemSpacingAfter: container.leadingAnchor, multiplier: 2),
            container.trailingAnchor.constraint(equalToSystemSpacingAfter: testCodeTextField.trailingAnchor, multiplier: 2),
        ])
        
        NSLayoutConstraint.activate([
            menuButton.leadingAnchor.constraint(equalToSystemSpacingAfter: container.leadingAnchor, multiplier: 2),
            container.bottomAnchor.constraint(equalToSystemSpacingBelow: menuButton.bottomAnchor, multiplier: 2),
            menuButton.heightAnchor.constraint(equalToConstant: 50),
            menuButton.widthAnchor.constraint(equalToConstant: 75),
            
            container.trailingAnchor.constraint(equalToSystemSpacingAfter: backButton.trailingAnchor, multiplier: 2),
            container.bottomAnchor.constraint(equalToSystemSpacingBelow: backButton.bottomAnchor, multiplier: 2),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            backButton.widthAnchor.constraint(equalToConstant: 75),
        ])
    }
    
    func animateOut() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, animations: {
            self.container.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
            self.alpha = 0
        }) { [weak self] complete in
            if complete {
                self?.removeFromSuperview()
                self?.delegate?.didTapBackButton()
            }
        }
    }
    
    func animateIn() {
        self.container.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
        self.alpha = 0
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, animations: {
            self.container.transform = .identity
            self.alpha = 1
        })
    }
    
    // MARK: - Selectors
    
    @objc private func didTapStart() {
        
    }
    
    @objc private func didTapBack() {
        testCodeTextField.text = ""
        animateOut()
    }
}
