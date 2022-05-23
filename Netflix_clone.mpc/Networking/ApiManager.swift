//
//  ApiManager.swift
//  Netflix_clone.mpc
//
//  Created by Matias Peralta Charro on 19/05/2022.
//

import Foundation
import Alamofire


class ApiManager {
    
    private let apiKey = "1f5274e12ce0f317806d2553ad020f60"
    private let imagesUrl = "https://image.tmdb.org/t/p/w500"
    private var popularMoviesUrl = "https://api.themoviedb.org/3/movie/popular?language=es&page=1"
    private var currentMovieUrl = "https://api.themoviedb.org/3/movie/"
    
    
    init() {
        self.popularMoviesUrl = popularMoviesUrl + "&api_key=\(apiKey)"
    }
    
    init(movieId: Int) {
        self.currentMovieUrl = currentMovieUrl + "\(movieId)?language=es" + "&api_key=\(apiKey)"
    }
    
    
    func performPopularMoviesRequest(completionHandler: @escaping ([PopularMovieModel]?, Error?) -> Void) {
        
        AF.request(popularMoviesUrl).response { response in
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                if let responseData = response.data {
                    let safeData = try decoder.decode(ResultDataModel.self, from: responseData)
                    completionHandler(safeData.results,response.error)
                }
            } catch {
                completionHandler(nil,error)
            }
        }
    }
    
    
    func performCurrentMovieRequest(completionHandler: @escaping (SelectedMovieModel?, Error?) -> Void) {
        
        AF.request(currentMovieUrl).response { response in
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                if let responseData = response.data {
                    let safeData = try decoder.decode(SelectedMovieModel.self, from: responseData)
                    completionHandler(safeData,response.error)
                }
            } catch {
                completionHandler(nil,error)
            }
        }
    }
    
    
    func getImagesUrl() -> String {
        return imagesUrl
    }
    
}
