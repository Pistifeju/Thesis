//
//  AuthService.swift
//  Thesis
//
//  Created by István Juhász on 2023. 01. 18..
//

import FirebaseAuth
import FirebaseFirestore

class AuthService {
    
    public static let shared = AuthService()
    private init() {}
    private let db = Firestore.firestore()
    
    /// A method to register the user.
    /// - Parameters:
    ///   - userRequest: The users information (email, password, username)
    ///   - completion: A completion with two values (Bool, Error?)
    ///   - Bool: Determines if the user was registered and saved in the database correctly.
    ///   - Error?: An optional error from firebase.
    public func registerUser(with userRequest: RegisterUserRequest, completion: @escaping(Bool, Error?) -> Void) {
        
        let username = userRequest.username
        let email = userRequest.email
        let password = userRequest.password
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard let resultUser = result?.user else {
                completion(false, nil)
                return
            }
            
            self.db.collection("users").document(resultUser.uid).setData([
                "username": username,
                "email": email,
            ]) { error in
                if let error = error {
                    completion(false, error)
                    return
                }
                
                completion(true, nil)
            }
        }
    }
    
    /// A method to sign in the user.
    /// - Parameters:
    ///   - userRequest: The users information (email, password)
    ///   - completion: A completion with one value (Error?)
    ///   - Error?: An optional error from firebase.
    public func signIn(with userRequest: LoginUserRequest, completion: @escaping(Error?) -> Void) {
        
        let email = userRequest.email
        let password = userRequest.password
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(error)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    /// A method to sign out the user.
    /// - Parameter completion: A completion with one value (Error?)
    /// - Error?: An optional error from firebase.
    public func signOut(completion: @escaping(Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
    
    /// A method to send a password reset if the user forgot their password.
    /// - Parameters:
    ///   - email: The user email.
    ///   - completion: A completion with one value (Error?)
    ///   - Error?:  An optional error from firebase.
    public func forgotPassword(with email: String, completion: @escaping(Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
    
    /// A method to fetch the signed in user.
    /// - Parameter completion: A completion with two values (User?, Error?)
    /// - User?: An optinal user model, with the currently signed in user's information.
    /// - Error?: An optional error from firebase.
    public func fetchUser(completion: @escaping(User?, Error?) -> Void) {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        
        self.db.collection("users").document(userUID).getDocument { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = snapshot?.data() else { return }
            
            let user = User(dictionary: data)
            
            completion(user, nil)
        }
    }
}
