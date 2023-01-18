//
//  AlertManager.swift
//  Thesis
//
//  Created by István Juhász on 2023. 01. 17..
//

import UIKit

/// A singleton class for alerts.
class AlertManager {
    private static func showBasicAlert(on VC: UIViewController, with title: String, and message: String?) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
            VC.present(alert, animated: true)
        }
    }
}

// MARK: - Show Validation Alerts
extension AlertManager {
    public static func showInvalidEmailAlert(on VC: UIViewController) {
        self.showBasicAlert(on: VC, with: "Invalid Email", and: "Please enter a valid email.")
    }
    
    public static func showInvalidPasswordAlert(on VC: UIViewController) {
        self.showBasicAlert(on: VC, with: "Invalid Password", and: "Please enter a valid password.")
    }
    
    public static func showDidntFillTextFieldAlert(on VC: UIViewController) {
        self.showBasicAlert(on: VC, with: "Please fill in every field.", and: nil)
    }
    
    public static func showPasswordDontMatchAlert(on VC: UIViewController) {
        self.showBasicAlert(on: VC, with: "The passwords do not match.", and: "Please try again.")
    }
}

// MARK: - Registration Errors
extension AlertManager {
    public static func showRegistrationErrorAlert(on VC: UIViewController, with error: Error) {
        self.showBasicAlert(on: VC, with: "Registration Error", and: (error.localizedDescription)) //Error is passed from Firebase
    }
    
    public static func showRegistrationErrorAlert(on VC: UIViewController) {
        self.showBasicAlert(on: VC, with: "Unknown Registration Error", and: nil)
    }
}

// MARK: - Log In Errors
extension AlertManager {
    public static func showSignInErrorAlert(on VC: UIViewController) {
        self.showBasicAlert(on: VC, with: "Unknown Sign In Error", and: nil)
    }
    
    public static func showSignInErrorAlert(on VC: UIViewController, with error: Error) {
        self.showBasicAlert(on: VC, with: "Sign In Error", and: (error.localizedDescription)) //Error is passed from Firebase
    }
}

// MARK: - Logout Errors
extension AlertManager {
    public static func showLogoutErrorAlert(on VC: UIViewController, with error: Error) {
        self.showBasicAlert(on: VC, with: "Log Out Error", and: (error.localizedDescription)) //Error is passed from Firebase
    }
}

// MARK: - Forgot Password Error
extension AlertManager {
    public static func showPasswordResetSentAlert(on VC: UIViewController) {
        self.showBasicAlert(on: VC, with: "Password Reset Sent!", and: "Check your emails.")
    }
    
    public static func showForgotPasswordErrorAlert(on VC: UIViewController, with error: Error) {
        self.showBasicAlert(on: VC, with: "Reset Password Error", and: (error.localizedDescription)) //Error is passed from Firebase
    }
}

//MARK: - Fetching User Errors
extension AlertManager {
    public static func showFetchingUserErrorAlert(on VC: UIViewController) {
        self.showBasicAlert(on: VC, with: "Unkown User Fetching Error", and: nil)
    }
    
    public static func showFetchingUserErrorAlert(on VC: UIViewController, with error: Error) {
        self.showBasicAlert(on: VC, with: "User Fetching Error", and: (error.localizedDescription)) //Error is passed from Firebase
    }
    
    public static func showFetchingAllUsersErrorAlert(on VC: UIViewController, with error: Error) {
        self.showBasicAlert(on: VC, with: "User Fetching Error", and: (error.localizedDescription)) //Error is passed from Firebase
    }
}
