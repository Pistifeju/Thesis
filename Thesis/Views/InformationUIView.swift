//
//  ModelInformationView.swift
//  BasicARApp
//
//  Created by István Juhász on 2022. 09. 28..
//

import UIKit
import LoremSwiftum

protocol ModelInformationViewDelegate: AnyObject {
    func didTapExit()
}

class ModelInformationView: UIView {

    var delegate: ModelInformationViewDelegate?
    
    private lazy var exitButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.setImage(UIImage(systemName: "x.circle"), for: .normal)
        button.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
        
        return button
    }()
    
    @objc private func didTapExitButton() {
        print("DidTapExitButton")
        delegate?.didTapExit()
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .blue
        label.text = "Valami"
        
        return label
    }()
    
    private let textView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.textColor = .black
        textView.font = .systemFont(ofSize: 16)
        textView.text = LoremSwiftum.Lorem.tweet
        textView.backgroundColor = .white
        textView.allowsEditingTextAttributes = false
        textView.isSelectable = false
        textView.isEditable = false
        textView.isUserInteractionEnabled = false
        
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .white
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(nameLabel)
        addSubview(textView)
        addSubview(exitButton)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8),
        ])
        
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            exitButton.heightAnchor.constraint(equalToConstant: 50),
            exitButton.widthAnchor.constraint(equalToConstant: 50),
            exitButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            exitButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        ])
    }
    
    func configure(nameLabel: String, textViewString: String) {
        self.nameLabel.text = nameLabel
        self.textView.text = textViewString
    }
}
