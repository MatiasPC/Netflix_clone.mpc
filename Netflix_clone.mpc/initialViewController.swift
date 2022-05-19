//
//  initialViewController.swift
//  Netflix_clone.mpc
//
//  Created by Matias Peralta Charro on 19/05/2022.
//

import UIKit

class initialViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func ingresarPressed(_ sender: UIButton) {
        presentTabBarController()
        
    }
    
    private func presentTabBarController() { // Presenta nuestro tabBarController
        let tabBarController = TabBarViewController()
        tabBarController.modalPresentationStyle = .overFullScreen
        self.present(tabBarController, animated: true)

    }

}
