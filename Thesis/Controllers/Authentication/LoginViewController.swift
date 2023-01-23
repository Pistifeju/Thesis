//
//  LoginViewController.swift
//  Thesis
//
//  Created by István Juhász on 2023. 01. 17..
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private let headerView: AuthHeaderView = AuthHeaderView(title: "Sign In", subtitle: "Sign in to your account")
    
    private let emailField: CustomAuthTextField = CustomAuthTextField(textFieldType: CustomAuthTextFieldType.email)
    private let passwordField: CustomAuthTextField = CustomAuthTextField(textFieldType: CustomAuthTextFieldType.password)
    
    private let signInButton: CustomAuthButton = CustomAuthButton(title: "Sign In", hasBackground: true, fontSize: .big)
    private let newUserButton: CustomAuthButton = CustomAuthButton(title: "New User? Create Account.", fontSize: .medium)
    private let forgotPassword: CustomAuthButton = CustomAuthButton(title: "Forgot password?", fontSize: .small)
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        passwordField.delegate = self
        
        self.signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        self.newUserButton.addTarget(self, action: #selector(didTapNewUser), for: .touchUpInside)
        self.forgotPassword.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
        
        self.setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        
        view.addSubview(headerView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signInButton)
        view.addSubview(newUserButton)
        view.addSubview(forgotPassword)
        
        //Headerview
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 0),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 270),
        ])
        
        //Textfields
        NSLayoutConstraint.activate([
            emailField.topAnchor.constraint(equalToSystemSpacingBelow: headerView.bottomAnchor, multiplier: 2),
            emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailField.heightAnchor.constraint(equalToConstant: 55),
            emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            passwordField.topAnchor.constraint(equalToSystemSpacingBelow: emailField.bottomAnchor, multiplier: 2),
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: 55),
            passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
        ])
        
        //Buttons
        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(equalToSystemSpacingBelow: passwordField.bottomAnchor, multiplier: 2),
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 55),
            signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            newUserButton.topAnchor.constraint(equalToSystemSpacingBelow: signInButton.bottomAnchor, multiplier: 1),
            newUserButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newUserButton.heightAnchor.constraint(equalToConstant: 44),
            newUserButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            forgotPassword.topAnchor.constraint(equalToSystemSpacingBelow: newUserButton.bottomAnchor, multiplier: 1),
            forgotPassword.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            forgotPassword.heightAnchor.constraint(equalToConstant: 22),
            forgotPassword.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
        ])
    }
    
    // MARK: - Selectors
    
    @objc private func didTapSignIn() {
        guard let email = emailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty else {
            AlertManager.showDidntFillTextFieldAlert(on: self)
            return
        }
        
        Validator.validateLogin(email: emailField, password: password, VC: self)
        
        let loginRequest = LoginUserRequest(email: email, password: password)
        
        AuthService.shared.signIn(with: loginRequest) { [weak self] error in
            guard let strongSelf = self else { return }
            if let error = error {
                AlertManager.showSignInErrorAlert(on: strongSelf, with: error)
                return
            }
            
            if let sceneDelegate = strongSelf.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
        }
    }
    
    @objc private func didTapNewUser() {
        let vc = RegistrationViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapForgotPassword() {
        let vc = ForgotPasswordViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
