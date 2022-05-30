//
//  MainViewController.swift
//  Netflix_clone.mpc
//
//  Created by Matias Peralta Charro on 19/05/2022.
//

import UIKit

class MainViewController: UIViewController {

    
    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var salir: UIButton!
    
    
    
    private let viewModel = MainViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
        loadMovies()
    }
}

extension MainViewController {
    
    @IBAction func salirPressed(_ sender: Any) {
        if let error = viewModel.logOut() {
            alertError(error: "Error al cerar sesion", message: error.localizedDescription)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}

extension MainViewController: UITabBarDelegate {
    
    private func prepare() {
        tabBar.delegate = self
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        moviesCollectionView.register(UINib(nibName: "OneMovieCell", bundle: nil), forCellWithReuseIdentifier: "OneMovie")
        tabBar.selectedItem = tabBar.items![0]
        titleView.customizeView()
        salir.layer.cornerRadius = salir.frame.size.height / 6
        moviesCollectionView.backgroundColor = .none
    }
}

extension MainViewController {
    
    private func loadMovies() {
        viewModel.fetchMovies { error in
            
            if let e = error {
                self.alertError(error: "Error al cargar peliculas", message: e.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    self.moviesCollectionView.reloadData()
                }
            }
        }
    }
}


extension MainViewController {

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title! == "Favorites" {
            let vc = FavoritesMoviesViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true, completion: nil)
            tabBar.selectedItem = tabBar.items![0]
        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfMovies()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = moviesCollectionView.dequeueReusableCell(withReuseIdentifier: "OneMovie", for: indexPath) as? OneMovieCell
        
        cell?.movieTitle.text = viewModel.getTitle(at: indexPath.row)
        if let url = viewModel.getImageUrl(at: indexPath.row) {
            cell?.moviePosterImage.load(url: url)
        } else {
            cell?.moviePosterImage.image = UIImage(systemName: "exclamationmark.triangle.fill")
            cell?.moviePosterImage.tintColor = .systemRed
            alertError(error: "Error", message: "Error cargando imagen")
        }
        
        return cell!
    }
    
}

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieVC = SelectedMovieViewController(movieId: viewModel.getId(at: indexPath.row))
        present(movieVC, animated: true, completion: nil)
    }    
}
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
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
 
extension MainViewController {
    
    private func alertError(error: String, message: String) {
        let alert = UIAlertController(title: error, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
