//
//  initialViewController.swift
//  Netflix_clone.mpc
//
//  Created by Matias Peralta Charro on 19/05/2022.
//

import UIKit

class initialViewController: UIViewController {
    
    @IBOutlet weak var mailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var warningLabel: UILabel!
    
    @IBOutlet weak var ingresarButton: UIButton!
    
    @IBOutlet weak var registrarseButton: UIButton!
    
    
    private let viewModel = UserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
    }

 
        
        
    @IBAction func ingresarPressed(_ sender: UIButton) {
        guard let email = mailTextField.text, let password = passwordTextField.text else {
            warningLabel.isHidden = false
            return
        }
            guard email != "" && password != "" else {
                warningLabel.isHidden = false
                return
            }
                viewModel.signIn(email: email, password: password) { error in
                    if let e = error {
                        self.alertError(error: "Error al iniciar sesion", message: e.localizedDescription)
                    } else {
                        self.validateAccess()
                    }
                }
            }
    
    
    @IBAction func registrarsePressed(_ sender: UIButton) {
        guard let email = mailTextField.text, let password = passwordTextField.text else {
            warningLabel.isHidden = false
            return
        }
            guard email != "" && password != "" else {
                warningLabel.isHidden = false
                return
            }
                viewModel.createUser(email: email, password: password) { error in
                    if let e = error {
                        self.alertError(error: "Error al registrarse", message: e.localizedDescription)
                    } else {
                        self.validateAccess()
                    }
                }
            }
    
    }

extension initialViewController {
    
    private func validateAccess() {
        warningLabel.isHidden = true
        let vc = MainViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    
    private func alertError(error: String, message: String) {
        let alert = UIAlertController(title: error, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    
}
    
extension initialViewController {
    
    private func prepare() {
        ingresarButton.layer.cornerRadius = ingresarButton.frame.size.height / 8
        registrarseButton.layer.cornerRadius = registrarseButton.frame.size.height / 8
        warningLabel.isHidden = true
    }
    
}
    




