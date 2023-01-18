//
//  TestViewController.swift
//  Thesis
//
//  Created by István Juhász on 2022. 12. 23..
//

import UIKit

class TestViewController: UIViewController {

    // MARK: - Properties

    var colorPickerView: ColorPickerView = ColorPickerView(frame: .zero)
    var colorPickerHeight = NSLayoutConstraint()
    
    private let modelInformationView = ModelInformationView(frame: .zero)
    
    private lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .large)
        let largeImage = UIImage(systemName: "gobackward", withConfiguration: largeConfig)
        
        button.setImage(largeImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.isHidden = false
        
        return button
    }()
    
    private lazy var colourButton: UIButton = {
        let button = UIButton(type: .system)
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .large)
        let largeImage = UIImage(systemName: "paintpalette.fill", withConfiguration: largeConfig)
        
        button.setImage(largeImage, for: .normal)
        button.addTarget(self, action: #selector(didTapColours), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.isHidden = false
        
        return button
    }()
    
    // MARK: - LifeCycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
        colorPickerView.pickerDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(resetButton)
        view.addSubview(colourButton)
        
        NSLayoutConstraint.activate([
            resetButton.heightAnchor.constraint(equalToConstant: 50),
            resetButton.widthAnchor.constraint(equalToConstant: 50),
            resetButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            self.view.trailingAnchor.constraint(equalToSystemSpacingAfter: resetButton.trailingAnchor, multiplier: 2),
        ])
        
        NSLayoutConstraint.activate([
            colourButton.heightAnchor.constraint(equalToConstant: 50),
            colourButton.widthAnchor.constraint(equalToConstant: 50),
            colourButton.topAnchor.constraint(equalToSystemSpacingBelow: resetButton.bottomAnchor, multiplier: 4),
            self.view.trailingAnchor.constraint(equalToSystemSpacingAfter: colourButton.trailingAnchor, multiplier: 2),
        ])
                
        view.addSubview(colorPickerView)
        self.colorPickerHeight = colorPickerView.heightAnchor.constraint(equalToConstant: 0)
        self.colorPickerHeight.isActive = true
        colorPickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorPickerView.widthAnchor.constraint(equalToConstant: 50),
            colorPickerView.topAnchor.constraint(equalToSystemSpacingBelow: colourButton.bottomAnchor, multiplier: 2),
            colorPickerView.centerXAnchor.constraint(equalTo: self.colourButton.centerXAnchor),
        ])
        
        self.setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .systemBlue
        view.addSubview(modelInformationView)
        
        modelInformationView.configure(nameLabel: "Phalanx", textViewString: "test")
        modelInformationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            modelInformationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            modelInformationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            modelInformationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    // MARK: - Selectors
    
    @objc private func didTapColours() {
        if(self.colorPickerHeight.constant == 0) {
            self.colorPickerHeight.constant = 300
        } else {
            self.colorPickerHeight.constant = 0
        }
        UIView.animate(withDuration: 0.5) {
            
            // request layout on the *superview*
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - ColorPickerViewDelegate

extension TestViewController: ColorPickerViewDelegate {
    func didSelectColor(withColor: UIColor?) {
        guard withColor != nil else {
            self.colourButton.tintColor = .white
            self.colorPickerHeight.constant = 0
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            return
        }
        
        self.colourButton.tintColor = withColor
    }
}
