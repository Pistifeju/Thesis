//
//  RegistrationViewController.swift
//  Thesis
//
//  Created by István Juhász on 2023. 01. 17..
//

import UIKit

class RegistrationViewController: UIViewController {
    
    // MARK: - Properties
    
    private let headerView: AuthHeaderView = AuthHeaderView(title: "Sign Up", subtitle: "Create your account")
    
    private let usernameField: CustomAuthTextField = CustomAuthTextField(textFieldType: CustomAuthTextFieldType.username)
    private let emailField: CustomAuthTextField = CustomAuthTextField(textFieldType: CustomAuthTextFieldType.email)
    private let passwordField: CustomAuthTextField = CustomAuthTextField(textFieldType: CustomAuthTextFieldType.password)
    private let passwordAgainField: CustomAuthTextField = CustomAuthTextField(textFieldType: CustomAuthTextFieldType.password)
    
    private let signUpButton: CustomAuthButton = CustomAuthButton(title: "Sign Up", hasBackground: true, fontSize: .big)
    private let signInButton: CustomAuthButton = CustomAuthButton(title: "Already have an account? Sign In.", fontSize: .medium)
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        self.signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        
        self.passwordAgainField.placeholder = "Password Again"
        
        self.setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        
        view.addSubview(headerView)
        view.addSubview(usernameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(passwordAgainField)
        view.addSubview(signUpButton)
        view.addSubview(signInButton)
        
        //Headerview
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 0),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 270),
        ])
        
        //Textfields
        NSLayoutConstraint.activate([
            usernameField.topAnchor.constraint(equalToSystemSpacingBelow: headerView.bottomAnchor, multiplier: 2),
            usernameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameField.heightAnchor.constraint(equalToConstant: 55),
            usernameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            emailField.topAnchor.constraint(equalToSystemSpacingBelow: usernameField.bottomAnchor, multiplier: 2),
            emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailField.heightAnchor.constraint(equalToConstant: 55),
            emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            passwordField.topAnchor.constraint(equalToSystemSpacingBelow: emailField.bottomAnchor, multiplier: 2),
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: 55),
            passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            passwordAgainField.topAnchor.constraint(equalToSystemSpacingBelow: passwordField.bottomAnchor, multiplier: 2),
            passwordAgainField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordAgainField.heightAnchor.constraint(equalToConstant: 55),
            passwordAgainField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
        ])
        
        //Buttons
        NSLayoutConstraint.activate([
            signUpButton.topAnchor.constraint(equalToSystemSpacingBelow: passwordAgainField.bottomAnchor, multiplier: 2),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 55),
            signUpButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            signInButton.topAnchor.constraint(equalToSystemSpacingBelow: signUpButton.bottomAnchor, multiplier: 1),
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 33),
            signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
        ])
    }
    
    // MARK: - Selectors
    
    @objc private func didTapSignIn() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapSignUp() {
        guard let username = usernameField.text, let email = emailField.text, let password = passwordField.text, let passwordAgain = passwordAgainField.text, !username.isEmpty, !email.isEmpty, !password.isEmpty, !passwordAgain.isEmpty else {
            AlertManager.showDidntFillTextFieldAlert(on: self)
            return
        }
        
        Validator.validateRegistration(email: emailField, password: password, passwordAgain: passwordAgain, VC: self)
        
        let registerUserRequest = RegisterUserRequest(username: username, password: password, email: email)
        
        AuthService.shared.registerUser(with: registerUserRequest) { [weak self] wasRegistered, error in
            guard let strongSelf = self else { return }
            
            if let error = error {
                AlertManager.showRegistrationErrorAlert(on: strongSelf, with: error)
                return
            }
            
            if wasRegistered {
                if let sceneDelegate = strongSelf.view.window?.windowScene?.delegate as? SceneDelegate {
                    sceneDelegate.checkAuthentication(registered: true)
                }
            } else {
                AlertManager.showRegistrationErrorAlert(on: strongSelf)
                return
            }
        }
    }
    
    @objc private func didTapForgotPassword() {
        let vc = ForgotPasswordViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
