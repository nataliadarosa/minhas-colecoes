//
//  AppDelegate.swift
//  Minhas Coleções
//
//  Created by Natalia da Rosa on 27/09/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let telaInicial = TelaInicialViewController()
        let navigationController = UINavigationController(rootViewController: telaInicial)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }

}

