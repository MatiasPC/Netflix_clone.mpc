import Foundation
import UIKit


extension UIView {
    
    func customizeView() {
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 7
    }
}
