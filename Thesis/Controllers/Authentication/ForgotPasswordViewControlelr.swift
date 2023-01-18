//
//  ForgotPasswordViewControlelr.swift
//  Thesis
//
//  Created by István Juhász on 2023. 01. 17..
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    // MARK: - Properties
    
    private let headerView: AuthHeaderView = AuthHeaderView(title: "Forgot Password?", subtitle: "Reset your password")
    
    private let emailField: CustomAuthTextField = CustomAuthTextField(textFieldType: .email)
    
    private let resetPasswordButton: CustomAuthButton = CustomAuthButton(title: "Reset Password", hasBackground: true, fontSize: .big)
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resetPasswordButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
        
        self.setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = UIColor.systemBackground
        
        view.addSubview(headerView)
        view.addSubview(emailField)
        view.addSubview(resetPasswordButton)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 0),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 270),
        ])
        
        NSLayoutConstraint.activate([
            emailField.topAnchor.constraint(equalToSystemSpacingBelow: headerView.bottomAnchor, multiplier: 2),
            emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailField.heightAnchor.constraint(equalToConstant: 55),
            emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            resetPasswordButton.topAnchor.constraint(equalToSystemSpacingBelow: emailField.bottomAnchor, multiplier: 2),
            resetPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetPasswordButton.heightAnchor.constraint(equalToConstant: 55),
            resetPasswordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
        ])
    }
    
    // MARK: - Selectors
    
    @objc private func didTapForgotPassword() {
        guard let email = self.emailField.text, !email.isEmpty else {
            AlertManager.showDidntFillTextFieldAlert(on: self)
            return
        }
        
        if !Validator.isValidEmail(field: emailField) {
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
        
        AuthService.shared.forgotPassword(with: email) { [weak self] error in
            guard let strongSelf = self else { return }
            if let error = error {
                AlertManager.showForgotPasswordErrorAlert(on: strongSelf, with: error)
                return
            }
            
            AlertManager.showPasswordResetSentAlert(on: strongSelf)
        }
    }
}
