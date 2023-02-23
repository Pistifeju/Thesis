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
        
        if(password.count < 6) {
            AlertManager.showInvalidPasswordAlert(on: VC)
            return
        }
    }
    
    static func validateRegistration(email: UITextField, password: String, passwordAgain: String, VC: UIViewController) -> Bool {
        
        if(!isValidEmail(field: email)) {
            AlertManager.showInvalidEmailAlert(on: VC)
            return false
        }
        
        if(password.count < 6) {
            AlertManager.showInvalidPasswordAlert(on: VC)
            return false
        }
        
        if(password != passwordAgain) {
            AlertManager.showPasswordDontMatchAlert(on: VC)
            return false
        }
        
        return true
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
}
