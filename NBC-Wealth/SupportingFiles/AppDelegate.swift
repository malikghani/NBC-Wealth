//
//  AppDelegate.swift
//  NBC-Wealth
//
//  Created by Ghani's Mac Mini on 04/09/2024.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupNavigationBar()
    
        return true
    }
}

// MARK: - Global View Configuration
private extension AppDelegate {
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .neo(.surface, color: .default)
        appearance.backgroundColor = .neo(.surface, color: .default)
        appearance.titlePositionAdjustment = UIOffset(
            horizontal: -.greatestFiniteMagnitude,
            vertical: 0
        )
        
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
    }
}
