//
//  FavouriteViewController.swift
//  Netflix_clone.mpc
//
//  Created by Matias Peralta Charro on 19/05/2022.
//

import UIKit
import SwipeCellKit


class FavoritesMoviesViewController: UIViewController {
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var favoritesMoviesCollectionView: UICollectionView!
    @IBOutlet weak var tabBar: UITabBar!
    
    private let viewModel = FavoriteMovieViewModel()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
        setUpUI()
        
        loadFavoritesMovies()
    }

}

// MARK: - SetUp

extension FavoritesMoviesViewController {
    
    private func setUp() {
        tabBar.delegate = self
        favoritesMoviesCollectionView.dataSource = self
        favoritesMoviesCollectionView.register(UINib(nibName: "FavoriteMovieCell", bundle: nil), forCellWithReuseIdentifier: "FavoriteMovie")
    }
    
    
    private func setUpUI() {
        titleView.customizeView()
        tabBar.selectedItem = tabBar.items![1]
        favoritesMoviesCollectionView.backgroundColor = .none
    }
    
}


// MARK: - Fetching data

extension FavoritesMoviesViewController {
    
    private func loadFavoritesMovies() {
        viewModel.fetchFavoriteMovies { error in
            if let e = error {
                self.reportError(error: "Ocurrio un error al intentar cargar las peliculas favoritas.", message: e.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    self.favoritesMoviesCollectionView.reloadData()
                }
            }
        }
    }
    
}


// MARK: - UITabBarDelegate

extension FavoritesMoviesViewController: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title! == "Inicio" {
            dismiss(animated: true, completion: nil)
        }
    }
    
}


// MARK: - UICollectionViewDataSource

extension FavoritesMoviesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfMovies()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteMovie", for: indexPath) as! FavoriteMovieCell
                
        cell.delegate = self

        cell.movieTitle.text = viewModel.getMovieTitle(at: indexPath.row)
        cell.movieGenre.text = viewModel.getMovieGenre(at: indexPath.row)
        cell.movieReleaseDate.text = viewModel.getMovieReleaseDate(at: indexPath.row)

        if let url = viewModel.getMovieImageUrl(at: indexPath.row) {
            cell.moviePosterImage.load(url: url)
        } else {
            cell.moviePosterImage.image = UIImage(systemName: "exclamationmark.triangle.fill")
            cell.moviePosterImage.tintColor = .systemRed
            reportError(error: "Error", message: "Ocurrio un error al intentar cargar las imagenes de las peliculas.")
        }

        return cell
    }
    
}


// MARK: - SwipeCollectionViewCellDelegate

extension FavoritesMoviesViewController: SwipeCollectionViewCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in

            self.viewModel.removeFromFavorites(at: indexPath.row) { error in
                if let e = error {
                    self.reportError(error: "Ocurrio un error al intentar remover de favoritos la pelicula.", message: e.localizedDescription)
                } else {
                    self.favoritesMoviesCollectionView.deleteItems(at: [indexPath])
                }
            }
        }

        deleteAction.image = UIImage(systemName: "trash.fill")?.withTintColor(.white)
        deleteAction.backgroundColor = .red

        return [deleteAction]
    }
    
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
 
        return options
    }
    
}


// MARK: - Error report

extension FavoritesMoviesViewController {

    private func reportError(error: String, message: String) {
        let alert = UIAlertController(title: error, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

}
