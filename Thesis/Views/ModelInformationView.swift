//
//  ModelInformationView.swift
//  BasicARApp
//
//  Created by István Juhász on 2022. 09. 28..
//

import UIKit
import LoremSwiftum
import AVFoundation

protocol ModelInformationViewDelegate: AnyObject {
    func didTapClose()
    func didTapFade()
    func didTapFadeOthers()
}

class ModelInformationView: UIView {

    public var height: Float = 50
    
    var delegate: ModelInformationViewDelegate?
        
    private var closeButton: ModelInformationButton = ModelInformationButton(title: "Exit")
    private var moreButton: ModelInformationButton = ModelInformationButton(title: "More")
    private var fadeButton: ModelInformationButton = ModelInformationButton(title: "Fade")
    private var fadeOthersButton: ModelInformationButton = ModelInformationButton(title: "Fade\nOthers")
    private var notesButton: ModelInformationButton = ModelInformationButton(title: "Notes")
    
    private var nameToSpeechButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.layer.opacity = 0.7
        button.translatesAutoresizingMaskIntoConstraints = false
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .large)
        let largeBoldDoc = UIImage(systemName: "speaker.wave.2", withConfiguration: largeConfig)
        button.setImage(largeBoldDoc, for: .normal)
        
        return button
    }()
    
    private lazy var optionButtons: UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [notesButton, fadeButton, fadeOthersButton, moreButton])
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.spacing = 10
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.distribution = .equalSpacing
        return stackview
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textColor = .white
        label.text = "Phalanx"
        label.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        fadeButton.addTarget(self, action: #selector(didTapFadeButton), for: .touchUpInside)
        fadeOthersButton.addTarget(self, action: #selector(didTapFadeOthersButton), for: .touchUpInside)
        moreButton.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
        nameToSpeechButton.addTarget(self, action: #selector(didTapNameToSpeechButton), for: .touchUpInside)
        notesButton.addTarget(self, action: #selector(didTapNotesButton), for: .touchUpInside)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor?.withAlphaComponent(0.5)
        backgroundColor = .clear
        self.layer.cornerRadius = 24
        self.layer.masksToBounds = true
        createBlurEffect()
        
        fadeOthersButton.titleLabel?.lineBreakMode = .byWordWrapping
        fadeOthersButton.titleLabel?.textAlignment = .center
        
        addSubview(nameLabel)
        addSubview(closeButton)
        addSubview(nameToSpeechButton)
        addSubview(optionButtons)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalToSystemSpacingBelow: self.topAnchor, multiplier: 1),
            self.trailingAnchor.constraint(equalToSystemSpacingAfter: closeButton.trailingAnchor, multiplier: 2),
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            nameToSpeechButton.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            nameToSpeechButton.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 2),
        ])
        
        NSLayoutConstraint.activate([
            self.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: optionButtons.bottomAnchor, multiplier: 0),
            optionButtons.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 2),
            self.trailingAnchor.constraint(equalToSystemSpacingAfter: optionButtons.trailingAnchor, multiplier: 2),
        ])
//
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            textView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
//            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
//            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8),
//            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8),
//        ])
//
    }
    
    func configure(nameLabel: String, textViewString: String) {
        self.nameLabel.text = nameLabel
        self.textView.text = textViewString
    }
    
    private func createBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.prominent)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.8
        blurEffectView.frame = bounds
        
//        let gradient = createGradientBackground()
//        blurEffectView.layer.addSublayer(gradient)
//        gradient.frame = blurEffectView.frame
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
    
    private func createGradientBackground() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemPurple.cgColor, UIColor.systemBlue.cgColor]
        gradient.locations = [0, 1]
        return gradient
    }
    
    // MARK: - Selectors
    
    @objc private func didTapCloseButton() {
        delegate?.didTapClose()
    }
    
    @objc private func didTapMoreButton() {
        
    }
    
    @objc private func didTapFadeButton() {
        
    }
    
    @objc private func didTapFadeOthersButton() {
        
    }
    
    @objc private func didTapNameToSpeechButton() {
        
    }
    
    @objc private func didTapNotesButton() {
        
    }
}
