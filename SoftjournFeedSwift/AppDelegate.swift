//
//  AppDelegate.swift
//  SoftjournFeedSwift
//
//  Created by Maksym Gorodivskyi on 4/22/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    _ = PreferencesManager.checkFirstRun()
    ContentManager.sharedInstance.updateContent()
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let tabBarController = UITabBarController()
    var controllers = [UIViewController]()
    
    for type in GalleryContentType.allValues {
      let feedViewController = storyboard.instantiateViewController(withIdentifier: "MainColectionController") as! PreviewViewController
      feedViewController.contentType = type
      feedViewController.tabBarItem = UITabBarItem(title: type.rawValue, image: nil, selectedImage: nil)
      controllers.append(feedViewController)
    }
    
    let preferencesViewController = storyboard.instantiateViewController(withIdentifier: "PreferencesViewController")
    preferencesViewController.tabBarItem = UITabBarItem(title: "Preferences", image: nil, selectedImage: nil)
    controllers.append(preferencesViewController)
    
    tabBarController.viewControllers = controllers
    
    self.window?.rootViewController = tabBarController
    self.window?.makeKeyAndVisible()
    
    return true
  }
}

