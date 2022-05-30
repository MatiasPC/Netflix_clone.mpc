//
//  SelectedMovieViewModel.swift
//  Netflix_clone.mpc
//
//  Created by Matias Peralta Charro on 19/05/2022.
//
import Foundation
import Firebase


class SelectedMovieViewModel {
    
    private var movie = SelectedMovieModel(title: "-", backdropPath: "-", genres: [], releaseDate: "-", overview: "-", posterPath: "-")
    private let movieId: String
    private let apiCaller: APICaller
    private let db = Firestore.firestore()
     
    
    init(movieId: Int) {
        apiCaller = APICaller(movieId: movieId)
        self.movieId = String(movieId)
    }
    
    
    func fetchData(completionHandler: @escaping (Error?) -> Void) {
        
        apiCaller.performCurrentMovieRequest { data, error in
            if let safeData = data {
                self.movie = safeData
            }
            completionHandler(error)
        }
    }
    
    
    private func prepareFavorites(completionHandler: @escaping ([FavoriteMovieModel], Error?) -> Void) {
        db.collection(Auth.auth().currentUser!.email!).getDocuments { querySnapshot, error in
            
            var favoritesMovies: [FavoriteMovieModel] = []
            
            if let e = error {
                return
            } else {
                if let documents = querySnapshot?.documents {
                    for doc in documents {
                        
                        let data = doc.data()
                        
                        let id = data["id"] as! String
                        let title = data["title"] as! String
                        let genre = data["genre"] as! String
                        let releaseDate = data["releaseDate"] as! String
                        let posterPath = data["posterPath"] as! String
                        
                        let movie = FavoriteMovieModel(title: title, genre: genre, releaseDate: releaseDate, posterPath: posterPath, id: id)
                        favoritesMovies.append(movie)
                    }
                }
            }
            
            completionHandler(favoritesMovies,error)
        }
    }
    
    
    func addToFavorites(completionHandler: @escaping (Error?) -> Void) {
        db.collection(Auth.auth().currentUser!.email!).document(movieId).setData([
            "id": movieId,
            "title": getTitle(),
            "genre": getGenre(),
            "releaseDate": getRelease(),
            "posterPath": movie.posterPath!
        ]) { error in
            completionHandler(error)
        }
    }
    
    
    func removeFromFavorites(completionHandler: @escaping (Error?) -> Void) {
        db.collection(Auth.auth().currentUser!.email!).document(movieId).delete { error in
            completionHandler(error)
        }
    }
    
    
    func getTitle() -> String {
        return movie.title
    }
    
    
    func getImageUrl() -> URL? {
        if let safeString = movie.backdropPath {
            let url = URL(string: (apiCaller.getImagesUrl() + safeString))
            return url
        }
        return nil
    }
    
    
    func getGenre() -> String {
        return movie.genres[0].name
    }
    
    
    func getRelease() -> String {
        return movie.releaseDate
    }
    
    
    func getOverview() -> String {
        return movie.overview
    }
    
    
    func isFavorite(completionHandler: @escaping (Bool) -> Void) {
        prepareFavorites { favoritesMovies, error in
            
            var result = false
            
            if let e = error {
                return
            } else {
                for movie in favoritesMovies {
                    if movie.title == self.getTitle() {
                        result = true
                    }
                }
            }
            
            completionHandler(result)
        }
    }
}
