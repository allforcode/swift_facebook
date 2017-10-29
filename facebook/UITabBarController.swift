//
//  UITabBarController.swift
//  facebook
//
//  Created by Paul Dong on 29/10/17.
//  Copyright © 2017 Paul Dong. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        let feedController = FeedController(collectionViewLayout: layout)
        
        let navigationController = createController(controller: feedController, title: "News Feed", imageName: "news_feed_icon")
        
        let friendRequestController = UIViewController()
        let secondNavigationController = createController(controller: friendRequestController, title: "Requests", imageName: "requests_icon")
        
        let messengerController = UIViewController()
        let thirdNavigationController = createController(controller: messengerController, title: "Messenger", imageName: "messenger_icon")
        
        let notifcationsController = UIViewController()
        let notificationsNavigationController = createController(controller: notifcationsController, title: "Notifications", imageName: "globe_icon")
        
        let moreController = UIViewController()
        let moreNavigationController = createController(controller: moreController, title: "More", imageName: "more_icon")
        
        viewControllers = [navigationController, secondNavigationController, thirdNavigationController, notificationsNavigationController, moreNavigationController]
        
        tabBar.isTranslucent = false
        
        let tabBorder = CALayer()
        tabBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
        tabBorder.backgroundColor = UIColor.rgb(red: 229, green: 231, blue: 235).cgColor
        
        tabBar.clipsToBounds = true
        tabBar.layer.addSublayer(tabBorder)
    }
    
    private func createController(controller: UIViewController, title: String, imageName: String) -> UINavigationController {
        controller.navigationItem.title = title
        let navController = UINavigationController(rootViewController: controller)
        navController.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }
}
