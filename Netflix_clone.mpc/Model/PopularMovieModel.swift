//
//  TabBarViewController.swift
//  Netflix_clone.mpc
//
//  Created by Matias Peralta Charro on 19/05/2022.
//

import Foundation

struct ResultDataModel: Decodable {
    let results: [PopularMovieModel]
}

struct PopularMovieModel: Decodable {
    let title: String
    let posterPath: String?
    let id: Int
    }
