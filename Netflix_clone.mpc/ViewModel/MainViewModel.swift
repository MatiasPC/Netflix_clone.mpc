//
//  MainViewModel.swift
//  Netflix_clone.mpc
//
//  Created by Matias Peralta Charro on 19/05/2022.
//

import Foundation
import FirebaseAuth


class MainViewModel {
    
    private var movies: [PopularMovieModel] = []
    private let apiCaller = APICaller()
    
    
    func logOut() -> Error? {
        do {
            try Auth.auth().signOut()
            return nil
        } catch {
            return error
        }
    }
    
    
    func fetchMovies(completionHandler: @escaping (Error?) -> Void) {
        apiCaller.performPopularMoviesRequest { data, error in
            
            if let safeData = data {
                self.movies = safeData
            }
            
            completionHandler(error)
        }
    }
    
    
    func numberOfMovies() -> Int {
        return movies.count
    }
    
    
    func getId(at index: Int) -> Int {
        return movies[index].id
    }
    
    
    func getTitle(at index: Int) -> String {
        return movies[index].title
    }
    
    
    func getImageUrl(at index: Int) -> URL? {
        if let safeString = movies[index].posterPath {
            let url = URL(string: (apiCaller.getImagesUrl() + safeString))
            
            return url
        }

        return nil
    }    
}
