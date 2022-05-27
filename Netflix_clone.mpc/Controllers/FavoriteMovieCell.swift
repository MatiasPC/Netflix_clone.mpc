//
//  FavoriteMovieCell.swift
//  
//
//  
//

import UIKit
import SwipeCellKit

class FavoriteMovieCell: SwipeCollectionViewCell {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var moviePosterImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpUI()
    }
    
    
    private func setUpUI() {
        self.layer.cornerRadius = 15.0
        self.layer.masksToBounds = false
        self.viewContainer.layer.cornerRadius = 10
        self.viewContainer.layer.masksToBounds = false
        self.viewContainer.layer.shadowColor = UIColor.black.cgColor
        self.viewContainer.layer.shadowOpacity = 0.4
        self.viewContainer.layer.shadowRadius = 3
        self.viewContainer.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.moviePosterImage.layer.shadowColor = UIColor.black.cgColor
        self.moviePosterImage.layer.shadowOpacity = 0.4
        self.moviePosterImage.layer.shadowRadius = 3
    }

}
