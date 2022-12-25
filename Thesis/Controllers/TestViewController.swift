//
//  TestViewController.swift
//  Thesis
//
//  Created by István Juhász on 2022. 12. 23..
//

import Foundation
import UIKit
import LoremSwiftum
import IGColorPicker

class TestViewController: UIViewController {

    // MARK: - Properties

    var colorPickerView: ColorPickerView = ColorPickerView(frame: .zero)
    var colorPickerHeight: NSLayoutConstraint!
    
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorPickerView.delegate = self
        colorPickerView.layoutDelegate = self
        colorPickerView.colors = [UIColor.red, UIColor.yellow, UIColor.green, UIColor.magenta, UIColor.orange]
        
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
        
        modelInformationView.configure(nameLabel: "Phalanx", textViewString: LoremSwiftum.Lorem.tweet)
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


extension TestViewController: ColorPickerViewDelegate {

  func colorPickerView(_ colorPickerView: ColorPickerView, didSelectItemAt indexPath: IndexPath) {
    // A color has been selected
  }

  // This is an optional method
  func colorPickerView(_ colorPickerView: ColorPickerView, didDeselectItemAt indexPath: IndexPath) {
    // A color has been deselected
  }

}

extension TestViewController: ColorPickerViewDelegateFlowLayout {

  // ------------------------------------------------------------------
  // All these methods are optionals, your are not to implement them 🖖🏻
  // ------------------------------------------------------------------
    
  func colorPickerView(_ colorPickerView: ColorPickerView, sizeForItemAt indexPath: IndexPath) -> CGSize {
    // The size for each cell
    // 👉🏻 WIDTH AND HEIGHT MUST BE EQUALS!
    return CGSize(width: 50, height: 50)
  }

  func colorPickerView(_ colorPickerView: ColorPickerView, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    // Space between cells
    return 0
  }

  func colorPickerView(_ colorPickerView: ColorPickerView, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    // Space between rows
    return 5
  }

  func colorPickerView(_ colorPickerView: ColorPickerView, insetForSectionAt section: Int) -> UIEdgeInsets {
    // Inset used aroud the view
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }

}
