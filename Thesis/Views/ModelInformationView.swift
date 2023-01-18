//
//  ModelInformationView.swift
//  BasicARApp
//
//  Created by István Juhász on 2022. 09. 28..
//

import UIKit
import AVFoundation

private enum ViewState {
    case moreTextView
    case notesTextView
}

protocol ModelInformationViewDelegate: AnyObject {
    func didTapClose()
    func didTapFade()
    func didTapFadeOthers()
    func didTapIsolate()
}

class ModelInformationView: UIView {

    var delegate: ModelInformationViewDelegate?
    
    private let synth = AVSpeechSynthesizer()
    private var containerViewHeightConstraint: NSLayoutConstraint?
    
    private var closeButton: ModelInformationButton = ModelInformationButton(title: "Close")
    private var moreButton: ModelInformationButton = ModelInformationButton(title: "More")
    private var fadeButton: ModelInformationButton = ModelInformationButton(title: "Fade")
    private var fadeOthersButton: ModelInformationButton = ModelInformationButton(title: "Fade\nOthers")
    private var notesButton: ModelInformationButton = ModelInformationButton(title: "Notes")
    private var isolateButton: ModelInformationButton = ModelInformationButton(title: "Isolate")
    
    private var containerViewState: ViewState? {
        didSet {
            guard let state = containerViewState else { return }
            
            // Remove previously added view
            containerViewForTextView.subviews.forEach({ $0.removeFromSuperview() })
            
            var contentView: UIView
            
            switch state {
            case .moreTextView:
                informationTextView.isHidden = false
                contentView = informationTextView
            case .notesTextView:
                notesTextView.isHidden = false
                contentView = notesTextView
            }
            
            containerViewForTextView.addSubview(contentView)
            
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: containerViewForTextView.topAnchor),
                contentView.leadingAnchor.constraint(equalTo: containerViewForTextView.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: containerViewForTextView.trailingAnchor),
                contentView.bottomAnchor.constraint(equalTo: containerViewForTextView.bottomAnchor)
            ])
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(Float(informationTextView.frame.height + 135)))
    }
    
    private var containerViewForTextView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .clear
        containerView.isHidden = true
        
        return containerView
    }()
    
    private var nameToSpeechButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.layer.opacity = 0.7
        button.translatesAutoresizingMaskIntoConstraints = false
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium, scale: .large)
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
    
    private var latinNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = .white
        label.text = "latin name"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let informationTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.textColor = .white
        textView.font = UIFont.preferredFont(forTextStyle: .body, compatibleWith: .none)
        textView.backgroundColor = .clear
        textView.allowsEditingTextAttributes = false
        textView.isSelectable = false
        textView.isEditable = false
        textView.isUserInteractionEnabled = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.showsHorizontalScrollIndicator = false
        textView.showsVerticalScrollIndicator = true
        textView.textAlignment = .justified
        
        return textView
    }()
    
    public let notesTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body, compatibleWith: .none)
        textView.tintColor = .white
        textView.backgroundColor = .clear
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.showsVerticalScrollIndicator = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.allowsEditingTextAttributes = true
        textView.autocorrectionType = .no
        
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
        
        addSubview(nameLabel)
        addSubview(closeButton)
        addSubview(nameToSpeechButton)
        addSubview(optionButtons)
        addSubview(containerViewForTextView)
        containerViewForTextView.addSubview(informationTextView)
        containerViewForTextView.addSubview(notesTextView)
        addSubview(latinNameLabel)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalToSystemSpacingBelow: self.topAnchor, multiplier: 1),
            self.trailingAnchor.constraint(equalToSystemSpacingAfter: closeButton.trailingAnchor, multiplier: 2),
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            latinNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            latinNameLabel.topAnchor.constraint(equalToSystemSpacingBelow: nameLabel.bottomAnchor, multiplier: 0),
        ])
        
        NSLayoutConstraint.activate([
            nameToSpeechButton.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            nameToSpeechButton.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 2),
        ])
        
        NSLayoutConstraint.activate([
            self.bottomAnchor.constraint(equalToSystemSpacingBelow: optionButtons.bottomAnchor, multiplier: 2),
            optionButtons.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 2),
            self.trailingAnchor.constraint(equalToSystemSpacingAfter: optionButtons.trailingAnchor, multiplier: 2),
        ])

        containerViewHeightConstraint = containerViewForTextView.heightAnchor.constraint(equalToConstant: 0)
        containerViewHeightConstraint?.isActive = true
        NSLayoutConstraint.activate([
            containerViewForTextView.topAnchor.constraint(equalToSystemSpacingBelow: latinNameLabel.bottomAnchor, multiplier: 1),
            containerViewForTextView.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 2),
            self.trailingAnchor.constraint(equalToSystemSpacingAfter: containerViewForTextView.trailingAnchor, multiplier: 2),
            containerViewForTextView.bottomAnchor.constraint(equalToSystemSpacingBelow: optionButtons.topAnchor, multiplier: -2),
        ])
    }
    
    func configure(nameLabel: String, textViewString: String) {
        self.nameLabel.text = nameLabel
        self.informationTextView.text = textViewString
        //TODO: - set latinNameLabel
    }
    
    func updateBottomButtons(entity: AREntity) {
        UIView.performWithoutAnimation {
            self.fadeButton.setTitle(entity.isFaded ? "Unfade" : "Fade", for: .normal)
            self.fadeOthersButton.setTitle(entity.isFadedOthers ? "Unfade\nOthers" : "Fade\nOthers", for: .normal)
            self.isolateButton.setTitle(entity.isIsolated ? "Unisolate" : "Isolate", for: .normal)
            self.fadeButton.layoutIfNeeded()
            self.fadeOthersButton.layoutIfNeeded()
            self.isolateButton.layoutIfNeeded()
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
        notesTextView.endEditing(true)
    }
    
    @objc private func didTapMoreButton() {
        UIView.performWithoutAnimation {
            if(containerViewForTextView.isHidden || (containerViewForTextView.isHidden == false && containerViewState == .notesTextView)) {
                containerViewForTextView.isHidden = false
                containerViewState = .moreTextView
                self.containerViewHeightConstraint?.constant = 200
                self.moreButton.setTitle("Hide\nMore", for: .normal)
                self.notesButton.setTitle("Notes", for: .normal)
            } else {
                self.containerViewHeightConstraint?.constant = 0
                containerViewForTextView.isHidden = true
                self.moreButton.setTitle("More", for: .normal)
            }
            
            notesButton.layoutIfNeeded()
            moreButton.layoutIfNeeded()
        }
    }
    
    @objc private func didTapNotesButton() {
        UIView.performWithoutAnimation {
            if(containerViewForTextView.isHidden || (containerViewForTextView.isHidden == false && containerViewState == .moreTextView)) {
                containerViewForTextView.isHidden = false
                containerViewState = .notesTextView
                self.containerViewHeightConstraint?.constant = 200
                self.notesButton.setTitle("Hide\nNotes", for: .normal)
                self.moreButton.setTitle("More", for: .normal)
            } else {
                self.containerViewHeightConstraint?.constant = 0
                containerViewForTextView.isHidden = true
                notesTextView.endEditing(true)
                self.notesButton.setTitle("Notes", for: .normal)
            }
            
            notesButton.layoutIfNeeded()
            moreButton.layoutIfNeeded()
        }
    }
    
    @objc private func didTapIsolateButton() {
        delegate?.didTapIsolate()
    }
    
    @objc private func didTapFadeButton() {
        delegate?.didTapFade()
    }
    
    @objc private func didTapFadeOthersButton() {
        delegate?.didTapFadeOthers()
    }
    
    @objc private func didTapNameToSpeechButton() {
        guard let text = nameLabel.text else {return}
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")

        synth.speak(utterance)
    }
}
