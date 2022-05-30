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
        prepare()
        prepareFavorites()
    }
}

extension FavoritesMoviesViewController {
    
    private func prepare() {
        tabBar.delegate = self
        favoritesMoviesCollectionView.dataSource = self
        favoritesMoviesCollectionView.register(UINib(nibName: "FavoriteMovieCell", bundle: nil), forCellWithReuseIdentifier: "FavoriteMovie")
        titleView.customizeView()
        tabBar.selectedItem = tabBar.items![1]
        favoritesMoviesCollectionView.backgroundColor = .none
    }
}

extension FavoritesMoviesViewController {
    
    private func prepareFavorites() {
        viewModel.fetchFavoriteMovies { error in
            if let e = error {
                self.alertError(error: "Error al cargar favoritos", message: e.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    self.favoritesMoviesCollectionView.reloadData()
                }
            }
        }
    }
}

extension FavoritesMoviesViewController: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title! == "Inicio" {
            dismiss(animated: true, completion: nil)
        }
    }
}

extension FavoritesMoviesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfMovies()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteMovie", for: indexPath) as! FavoriteMovieCell
                
        cell.delegate = self

        cell.movieTitle.text = viewModel.getTitle(at: indexPath.row)
        cell.movieGenre.text = viewModel.getGenre(at: indexPath.row)
        cell.movieReleaseDate.text = viewModel.getRelease(at: indexPath.row)

        if let url = viewModel.getImageUrl(at: indexPath.row) {
            cell.moviePosterImage.load(url: url)
        } else {
            cell.moviePosterImage.image = UIImage(systemName: "exclamationmark.triangle.fill")
            cell.moviePosterImage.tintColor = .systemRed
            alertError(error: "Error", message: "Error al cargar imagen")
        }

        return cell
    }
}

extension FavoritesMoviesViewController: SwipeCollectionViewCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in

            self.viewModel.removeFromFavorites(at: indexPath.row) { error in
                if let e = error {
                    self.alertError(error: "Error al borrar pelicula", message: e.localizedDescription)
                } else {
                    self.favoritesMoviesCollectionView.deleteItems(at: [indexPath])
                }
            }
        }

        deleteAction.image = UIImage(systemName: "trash")?.withTintColor(.white)
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


extension FavoritesMoviesViewController {

    private func alertError(error: String, message: String) {
        let alert = UIAlertController(title: error, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

}
