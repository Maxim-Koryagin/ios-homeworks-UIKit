//
//  SceneDelegate.swift
//  Navigation
//
//  Created by Maxim Koryagin on 14.08.2022.

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var rootCoordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
        rootCoordinator = AppCoordinator.init(navigationController)
        rootCoordinator?.start()

        PlanetNetworkManeger.request()
    }
    
}

