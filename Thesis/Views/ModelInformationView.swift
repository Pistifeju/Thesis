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
    func didTapIsolate()
}

class ModelInformationView: UIView {

    var delegate: ModelInformationViewDelegate?
    
    private let synth = AVSpeechSynthesizer()
    private var textViewHeightConstraint: NSLayoutConstraint?
    
    private var closeButton: ModelInformationButton = ModelInformationButton(title: "Exit")
    private var moreButton: ModelInformationButton = ModelInformationButton(title: "More")
    private var fadeButton: ModelInformationButton = ModelInformationButton(title: "Fade")
    private var fadeOthersButton: ModelInformationButton = ModelInformationButton(title: "Fade\nOthers")
    private var notesButton: ModelInformationButton = ModelInformationButton(title: "Notes")
    private var isolateButton: ModelInformationButton = ModelInformationButton(title: "Isolate")
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(Float(textView.frame.height + 135)))
    }
    
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
        let stackview = UIStackView(arrangedSubviews: [isolateButton, fadeButton, fadeOthersButton, moreButton, notesButton])
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.spacing = 10
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.distribution = .fillEqually
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
        textView.textColor = .white
        textView.font = .systemFont(ofSize: 16)
        textView.backgroundColor = .clear
        textView.allowsEditingTextAttributes = false
        textView.isSelectable = false
        textView.isEditable = false
        textView.isUserInteractionEnabled = true
        textView.isHidden = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.showsHorizontalScrollIndicator = false
        textView.showsVerticalScrollIndicator = true
        
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
        isolateButton.addTarget(self, action: #selector(didTapIsolateButton), for: .touchUpInside)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor?.withAlphaComponent(0.5)
        backgroundColor = .clear
        self.layer.cornerRadius = 24
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively
        self.layer.masksToBounds = true
        createBlurEffect()
        
        fadeOthersButton.titleLabel?.lineBreakMode = .byWordWrapping
        fadeOthersButton.titleLabel?.textAlignment = .center
        
        addSubview(nameLabel)
        addSubview(closeButton)
        addSubview(nameToSpeechButton)
        addSubview(optionButtons)
        addSubview(textView)
        
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

        textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: 0)
        textViewHeightConstraint?.isActive = true
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalToSystemSpacingBelow: nameLabel.bottomAnchor, multiplier: 1),
            textView.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 2),
            self.trailingAnchor.constraint(equalToSystemSpacingAfter: textView.trailingAnchor, multiplier: 2),
            textView.bottomAnchor.constraint(equalToSystemSpacingBelow: optionButtons.topAnchor, multiplier: -2),
        ])
    }
    
    func configure(nameLabel: String, textViewString: String) {
        self.nameLabel.text = nameLabel
        self.textView.text = textViewString + textViewString + textViewString + textViewString
    }
    
    func updateBottomButtons(entity: AREntity) {
        UIView.performWithoutAnimation {
            self.fadeButton.setTitle(entity.isFaded ? "Unfade" : "Fade", for: .normal)
            self.fadeButton.layoutIfNeeded()
        }
    }
    
    private func createBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.8
        blurEffectView.frame = bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
    
    // MARK: - Selectors
    
    @objc private func didTapCloseButton() {
        delegate?.didTapClose()
    }
    
    @objc private func didTapMoreButton() {
        if(textView.isHidden) {
            textView.isHidden = false
            self.textViewHeightConstraint?.constant = 200
        } else {
            self.textViewHeightConstraint?.constant = 0
            textView.isHidden = true
        }
    }
    
    @objc private func didTapIsolateButton() {
        
    }
    
    @objc private func didTapFadeButton() {
        delegate?.didTapFade()
    }
    
    @objc private func didTapFadeOthersButton() {
        
    }
    
    @objc private func didTapNameToSpeechButton() {
        guard let text = nameLabel.text else {return}
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")

        synth.speak(utterance)
    }
    
    @objc private func didTapNotesButton() {
        
    }
}
