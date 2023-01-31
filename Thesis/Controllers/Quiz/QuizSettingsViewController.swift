//
//  QuizSettingsViewController.swift
//  Thesis
//
//  Created by István Juhász on 2023. 01. 30..
//

import UIKit
import BEMCheckBox

class QuizSettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let settingsTitle: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .headline).bold()
        label.text = "Test Settings"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel = QuizSettingsCustomLabel(with: "Test Name")
    private let codeLabel = QuizSettingsCustomLabel(with: "Test Code")
    private let completionTimeLabel = QuizSettingsCustomLabel(with: "Completion Time (Minutes)")
    private let allowARModeLabel = QuizSettingsCustomLabel(with: "Enable AR Mode During Test")
    private let allowViewCompletedTestLabel = QuizSettingsCustomLabel(with: "Allow Users to view the completed Test")
    
    private let testNameTextField = NewQuestionCustomTextField(with: "Test Name")
    private let testCodeTextField = NewQuestionCustomTextField(with: "A678GH-76DFRT")
    private let completionTimeTextField = NewQuestionCustomTextField(with: "20")
    private let allowARModeCheckBox = BEMCheckBox()
    private let allowViewCompletedTestCheckbox = BEMCheckBox()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        view.backgroundColor = .white
        
        let generateCodeButton = UIButton(type: .system)
        generateCodeButton.setImage(UIImage(systemName: "goforward.plus"), for: .normal)
        generateCodeButton.tintColor = .black
        generateCodeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        generateCodeButton.addTarget(self, action: #selector(didPressGenerateCodeButton), for: .touchUpInside)
        testCodeTextField.rightView = generateCodeButton
        testCodeTextField.rightViewMode = .always
        
        title = "Test Settings"
        completionTimeTextField.text = "20"
        completionTimeTextField.leftViewMode = .never
        completionTimeTextField.textAlignment = .center
        completionTimeTextField.delegate = self
        
        createCheckBoxes()
        
        //Labels
        view.addSubview(settingsTitle)
        view.addSubview(nameLabel)
        view.addSubview(codeLabel)
        view.addSubview(completionTimeLabel)
        view.addSubview(allowARModeLabel)
        view.addSubview(allowViewCompletedTestLabel)
        
        //Textfields
        view.addSubview(testNameTextField)
        view.addSubview(testCodeTextField)
        view.addSubview(completionTimeTextField)
        
        //Checkboxes
        view.addSubview(allowARModeCheckBox)
        view.addSubview(allowViewCompletedTestCheckbox)
        
        NSLayoutConstraint.activate([
            settingsTitle.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1),
            settingsTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            nameLabel.topAnchor.constraint(equalToSystemSpacingBelow: settingsTitle.bottomAnchor, multiplier: 2),
            
            testNameTextField.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: testNameTextField.trailingAnchor, multiplier: 2),
            testNameTextField.topAnchor.constraint(equalToSystemSpacingBelow: nameLabel.bottomAnchor, multiplier: 0.5),
            testNameTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07),
            
            codeLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            codeLabel.topAnchor.constraint(equalToSystemSpacingBelow: testNameTextField.bottomAnchor, multiplier: 1),
            
            testCodeTextField.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: testCodeTextField.trailingAnchor, multiplier: 2),
            testCodeTextField.topAnchor.constraint(equalToSystemSpacingBelow: codeLabel.bottomAnchor, multiplier: 0.5),
            testCodeTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07),
            
            completionTimeLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            completionTimeLabel.topAnchor.constraint(equalToSystemSpacingBelow: testCodeTextField.bottomAnchor, multiplier: 1),
            
            completionTimeTextField.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            completionTimeTextField.topAnchor.constraint(equalToSystemSpacingBelow: completionTimeLabel.bottomAnchor, multiplier: 0.5),
            completionTimeTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07),
            completionTimeTextField.trailingAnchor.constraint(equalTo: codeLabel.trailingAnchor),
            
            allowARModeLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            allowARModeLabel.topAnchor.constraint(equalToSystemSpacingBelow: completionTimeTextField.bottomAnchor, multiplier: 4),
            
            allowARModeCheckBox.leadingAnchor.constraint(equalToSystemSpacingAfter: allowARModeLabel.trailingAnchor, multiplier: 2),
            allowARModeCheckBox.centerYAnchor.constraint(equalTo: allowARModeLabel.centerYAnchor),
            allowARModeCheckBox.heightAnchor.constraint(equalTo: allowARModeLabel.heightAnchor, multiplier: 1.25),
            allowARModeCheckBox.widthAnchor.constraint(equalTo: allowARModeLabel.widthAnchor, multiplier: 1.25),
            
            allowViewCompletedTestLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            allowViewCompletedTestLabel.topAnchor.constraint(equalToSystemSpacingBelow: allowARModeCheckBox.bottomAnchor, multiplier: 2),
            
            allowViewCompletedTestCheckbox.leadingAnchor.constraint(equalToSystemSpacingAfter: allowViewCompletedTestLabel.trailingAnchor, multiplier: 2),
            allowViewCompletedTestCheckbox.centerYAnchor.constraint(equalTo: allowViewCompletedTestLabel.centerYAnchor),
            allowViewCompletedTestCheckbox.heightAnchor.constraint(equalTo: allowViewCompletedTestLabel.heightAnchor, multiplier: 1.25),
            allowViewCompletedTestCheckbox.widthAnchor.constraint(equalTo: allowViewCompletedTestLabel.widthAnchor, multiplier: 1.25),
        ])
    }

    private func createCheckBoxes() {
        let checkboxes: [BEMCheckBox] = [allowARModeCheckBox, allowViewCompletedTestCheckbox]
        
        for checkbox in checkboxes {
            checkbox.translatesAutoresizingMaskIntoConstraints = false
            checkbox.onAnimationType = .fade
            checkbox.offAnimationType = .fade
            checkbox.onTintColor = UIColor(red: 1/255, green: 130/255, blue: 110/255, alpha: 1)
            checkbox.tintColor = UIColor(red: 1/255, green: 130/255, blue: 110/255, alpha: 1)
            checkbox.onFillColor = UIColor(red: 1/255, green: 130/255, blue: 110/255, alpha: 1)
            checkbox.onCheckColor = .white
        }
    }
    
    // MARK: - Selectors
    
    @objc private func didPressGenerateCodeButton() {
        // TODO: - Create code generation for test
        //GENERATE CODE
        //CHECK IF IT EXISTS IN FIREBASE
    }
}

// MARK: - UITextFieldDelegate

extension QuizSettingsViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        guard !text.starts(with: "0") else {
            textField.text = ""
            return
        }
        
        guard !(text.count > 3) else {
            textField.text = String(text.prefix(3))
            return
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
