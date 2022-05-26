//
//  TabBarViewController.swift
//  Netflix_clone.mpc
//
//  Created by Matias Peralta Charro on 19/05/2022.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //first tab
        let firstTabTitle = "Movies"
        let firstTabImage = UIImage(systemName: "play")
        let firstTabImageSelected = UIImage(systemName: "play.fill")
        
        let firstTabViewController = MainViewController(nibName: "MainViewController", bundle: nil)
        firstTabViewController.title = firstTabTitle
        
        let firstTabNavigationController = UINavigationController(rootViewController: firstTabViewController)
        
        firstTabNavigationController.tabBarItem = UITabBarItem(title: firstTabTitle, image: firstTabImage, selectedImage: firstTabImageSelected)
        
        //second tab
        let secondTabTitle = "Favourites"
        let secondTabImage = UIImage(systemName: "heart")
        let secondTabImageSelected = UIImage(systemName: "heart.fill")
        
        let secondTabViewController = FavoritesMoviesViewController(nibName: "FavouriteViewController", bundle: nil)
        secondTabViewController.title = secondTabTitle
        
        let secondTabNavigationController = UINavigationController(rootViewController: secondTabViewController)
        
        secondTabNavigationController.tabBarItem = UITabBarItem(title: secondTabTitle, image: secondTabImage, selectedImage: secondTabImageSelected)
        
        
                
        
        viewControllers = [firstTabNavigationController,secondTabNavigationController]
        
    }
    



}
