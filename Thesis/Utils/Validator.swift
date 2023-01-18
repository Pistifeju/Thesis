//
//  Validator.swift
//  Thesis
//
//  Created by István Juhász on 2023. 01. 17..
//
import UIKit

final class Validator {
    static func validateLogin(email: UITextField, password: String, VC: UIViewController) {
        if(!isValidEmail(field: email)) {
            AlertManager.showInvalidEmailAlert(on: VC)
            return
        }
        
        if(!isPasswordValid(for: password)) {
            AlertManager.showInvalidPasswordAlert(on: VC)
            return
        }
    }
    
    static func validateRegistration(email: UITextField, password: String, passwordAgain: String, VC: UIViewController) {
        
        if(!isValidEmail(field: email)) {
            AlertManager.showInvalidEmailAlert(on: VC)
            return
        }
        
        if(!isPasswordValid(for: password)) {
            AlertManager.showInvalidPasswordAlert(on: VC)
            return
        }
        
        if(password != passwordAgain) {
            AlertManager.showPasswordDontMatchAlert(on: VC)
            return
        }
    }
    
    static func isValidEmail(field: UITextField) -> Bool {
        guard let trimmedText = field.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return false
        }
        
        guard let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return false
        }
        
        let range = NSMakeRange(0, NSString(string: trimmedText).length)
        let allMatches = dataDetector.matches(in: trimmedText,
                                              options: [],
                                              range: range)
        
        if allMatches.count == 1,
           allMatches.first?.url?.absoluteString.contains("mailto:") == true
        {
            return true
        }
        
        return false
    }
    
    static func isPasswordValid(for password: String) -> Bool {
        let password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[$@$#!%*?&]).{6,32}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
}
