//
//  UserViewModel.swift
//  Netflix_clone.mpc
//
//  Created by Matias Peralta Charro on 23/05/2022.
//
import Foundation
import FirebaseAuth


class UserViewModel {
    
    func signIn(email: String, password: String, completionHandler: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            completionHandler(error)
        }
    }
    
    
    func createUser(email: String, password: String, completionHandler: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            completionHandler(error)
        }
    }
    
}
