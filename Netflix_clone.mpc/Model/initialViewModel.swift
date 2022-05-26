
import Foundation
import FirebaseAuth


class initialViewModel {
    
    func logIn(email: String, password: String, completionHandler: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            completionHandler(error)
        }
    }
    
    
    func signUp(email: String, password: String, completionHandler: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            completionHandler(error)
        }
    }
    
}
