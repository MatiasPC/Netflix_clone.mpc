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

        loadMovie()
    }

}


// MARK: - @IBActions

extension SelectedMovieViewController {
    
    @IBAction func favoritePressed(_ sender: Any) {
        if favoriteButton.currentImage == UIImage(systemName: "star") {
            
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            viewModel.addToFavorites { error in
                if let e = error {
                    self.reportError(error: "Ocurrio un error al intentar agregar a favoritos la pelicula.", message: e.localizedDescription)
                }
            }
            
        } else {
            
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
            viewModel.removeFromFavorites { error in
                
                if let e = error {
                    self.reportError(error: "Ocurrio un error al intentar eliminar de favoritos la pelicula.", message: e.localizedDescription)
                }
            }
        }
    }
    
}


// MARK: - Fetching data

extension SelectedMovieViewController {
    
    private func loadMovie() {
        viewModel.fetchMovieData { error in
            
            if let e = error {
                self.reportError(error: "Ocurrio un error al intentar cargar los datos de la pelicula.", message: e.localizedDescription)
            } else {
                self.updateUI()
            }
            
        }
    }
    
}



// MARK: - Auxiliary UI Methods & Error report

extension SelectedMovieViewController {
    
    private func updateUI() {
        DispatchQueue.main.async {
            
            if let url = self.viewModel.getMovieImageUrl() {
                self.movieImage.load(url: url)
            } else {
                self.movieImage.image = UIImage(systemName: "exclamationmark.triangle.fill")
                self.movieImage.tintColor = .systemRed
                self.reportError(error: "Error", message: "Ocurrio un error al intentar cargar la imagen de la pelicula.")
            }
            
            self.movieName.text = self.viewModel.getMovieTitle()
            self.movieGenre.text = self.viewModel.getMovieGenre()
            self.movieReleaseDate.text = self.viewModel.getMovieReleaseDate()
            self.movieOverview.text = self.viewModel.getMovieOverview()
            
            self.viewModel.isFavorite { isFavorite in
                self.favoriteButton.setImage(isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star"), for: .normal)
            }
        }
    }
    
    
    private func reportError(error: String, message: String) {
        let alert = UIAlertController(title: error, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
