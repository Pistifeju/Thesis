//
//  CustomAuthTextField.swift
//  Thesis
//
//  Created by István Juhász on 2023. 01. 17..
//

import UIKit

enum CustomAuthTextFieldType {
    case username
    case email
    case password
}

class CustomAuthTextField: UITextField {
    
    // MARK: - Properties
    private let showPasswordButton = UIButton(type: .custom)
    private let authFieldType: CustomAuthTextFieldType
    
    // MARK: - Lifecycle
    init(textFieldType: CustomAuthTextFieldType) {
        self.authFieldType = textFieldType
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .secondarySystemBackground
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 10
        self.returnKeyType = .done
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        
        self.leftViewMode = .always
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 1))
        
        switch authFieldType {
        case .username:
            self.placeholder = "Username"
        case .email:
            self.placeholder = "Email"
            self.keyboardType = .emailAddress
            self.textContentType = .emailAddress
        case .password:
            self.placeholder = "Password"
            self.isSecureTextEntry = true
            setPasswordToggleImage(self.showPasswordButton)
            self.enablePasswordToggle()
        }
    }
    
    // MARK: - Selectors
}

extension CustomAuthTextField {
    @objc func togglePasswordVisibility() {
        self.isSecureTextEntry = !isSecureTextEntry
        setPasswordToggleImage(self.showPasswordButton)
        if let existingText = text, isSecureTextEntry {
            /* When toggling to secure text, all text will be purged if the user
             continues typing unless we intervene. This is prevented by first
             deleting the existing text and then recovering the original text. */
            deleteBackward()

            if let textRange = textRange(from: beginningOfDocument, to: endOfDocument) {
                replace(textRange, withText: existingText)
            }
        }

        /* Reset the selected text range since the cursor can end up in the wrong
         position after a toggle because the text might vary in width */
        if let existingSelectedTextRange = selectedTextRange {
            selectedTextRange = nil
            selectedTextRange = existingSelectedTextRange
        }
    }
    
    func setPasswordToggleImage(_ button: UIButton) {
        if(isSecureTextEntry){
            button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }else{
            button.setImage(UIImage(systemName: "eye"), for: .normal)
        }
    }
    
    func enablePasswordToggle(){
        showPasswordButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        showPasswordButton.frame = CGRect(x: CGFloat(self.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        showPasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        self.rightView = showPasswordButton
        self.rightViewMode = .always
    }
}
