//
//  TabBarViewController.swift
//  Netflix_clone.mpc
//
//  Created by Matias Peralta Charro on 19/05/2022.
//

import Foundation


struct SelectedMovieModel: Decodable {
    let title: String
    let backdropPath: String?
    let genres: [GenresModel]
    let releaseDate: String
    let overview: String
    let posterPath: String?
}


struct GenresModel: Decodable {
    let id: Int
    let name: String
}
