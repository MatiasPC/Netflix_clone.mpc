//
//  SelectedMovieViewController.swift
//  Netflix_clone.mpc
//
//  Created by Matias Peralta Charro on 23/05/2022.
//

import UIKit

class SelectedMovieViewController: UIViewController {
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var movieOverview: UITextView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    private var viewModel: SelectedMovieViewModel
    
    
    init(movieId: Int) {
        viewModel = SelectedMovieViewModel(movieId: movieId)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovie()
    }

}


extension SelectedMovieViewController {
    
    @IBAction func favoritePressed(_ sender: Any) {
        if favoriteButton.currentImage == UIImage(systemName: "star") {
            
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            viewModel.addToFavorites { error in
                if let e = error {
                    self.alertError(error: "Error al agregar a favoritos", message: e.localizedDescription)
                }
            }
            
        } else {
            
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
            viewModel.removeFromFavorites { error in
                
                if let e = error {
                    self.alertError(error: "Error al eliminar de favoritos", message: e.localizedDescription)
                }
            }
        }
    }
}

extension SelectedMovieViewController {
    
    private func getMovie() {
        viewModel.fetchData { error in
            
            if let e = error {
                self.alertError(error: "Error al cargar informacion", message: e.localizedDescription)
            } else {
                self.update()
            }
        }
    }
}


extension SelectedMovieViewController {
    
    private func update() {
        DispatchQueue.main.async {
            
            if let url = self.viewModel.getImageUrl() {
                self.movieImage.load(url: url)
            } else {
                self.movieImage.image = UIImage(systemName: "exclamationmark.triangle.fill")
                self.movieImage.tintColor = .systemRed
                self.alertError(error: "Error", message: "Error al cargar imagen")
            }
            
            self.movieName.text = self.viewModel.getTitle()
            self.movieGenre.text = self.viewModel.getGenre()
            self.movieReleaseDate.text = self.viewModel.getRelease()
            self.movieOverview.text = self.viewModel.getOverview()
            
            self.viewModel.isFavorite { isFavorite in
                self.favoriteButton.setImage(isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star"), for: .normal)
            }
        }
    }
    

    private func alertError(error: String, message: String) {
        let alert = UIAlertController(title: error, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
