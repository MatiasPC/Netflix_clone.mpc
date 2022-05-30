//
//  FavouriteViewModel.swift
//  Netflix_clone.mpc
//
//  Created by Matias Peralta Charro on 24/05/2022.
//

import Foundation
import Firebase


class FavoriteMovieViewModel {
    
    private var favoritesMovies: [FavoriteMovieModel] = []
    private let apiManager = APICaller()
    private let db = Firestore.firestore()
    
    
    func fetchFavoriteMovies(completionHandler: @escaping (Error?) -> Void) {
        loadFavoritesMovies { resultData, error in
            if let e = error {
                completionHandler(e)
            } else {
                self.favoritesMovies = resultData
                completionHandler(nil)
            }
        }
    }
    
    
    private func loadFavoritesMovies(completionHandler: @escaping ([FavoriteMovieModel], Error?) -> Void) {
        db.collection(Auth.auth().currentUser!.email!).getDocuments { querySnapshot, error in
            
            var favoritesMovies: [FavoriteMovieModel] = []
            
            if let e = error {
                print(" Error -> \(e.localizedDescription)")
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
    
    
    func removeFromFavorites(at index: Int, completionHandler: @escaping (Error?) -> Void) {
        db.collection(Auth.auth().currentUser!.email!).document(favoritesMovies[index].id).delete { error1 in
            
            if let e1 = error1 {
                completionHandler(e1)
            } else {
                self.fetchFavoriteMovies { error2 in
                    if let e2 = error2 {
                        completionHandler(e2)
                    } else {
                        completionHandler(nil)
                    }
                }
            }
        }
    }

    
    
    func numberOfMovies() -> Int {
        return favoritesMovies.count
    }
    
    
    func getTitle(at index: Int) -> String {
        return favoritesMovies[index].title
    }
    
    
    func getGenre(at index: Int) -> String {
        return favoritesMovies[index].genre
    }
    
    
    func getRelease(at index: Int) -> String {
        return favoritesMovies[index].releaseDate
    }
    
    
    func getImageUrl(at index: Int) -> URL? {
        let url = URL(string: (apiManager.getImagesUrl() + favoritesMovies[index].posterPath))
        return url
    }
}
