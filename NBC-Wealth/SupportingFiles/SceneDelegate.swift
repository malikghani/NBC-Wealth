//
//  SceneDelegate.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 04/09/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { 
            return
        }
        
        window = UIWindow(windowScene: windowScene)
        let viewController = WealthViewController(viewModel: .init())
        let navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
