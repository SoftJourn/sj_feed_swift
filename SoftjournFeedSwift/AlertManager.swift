//
//  AlertManager.swift
//  SoftjournFeedSwift
//
//  Created by Maksym Gorodivskyi on 6/9/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit

class AlertManager: NSObject {
  class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    // TODO : Refactor
    if let nav = base as? UINavigationController {
      return topViewController(nav.visibleViewController)
    }
    if let tab = base as? UITabBarController {
      if let selected = tab.selectedViewController {
        return topViewController(selected)
      }
    }
    if let presented = base?.presentedViewController {
      return topViewController(presented)
    }
    return base
  }
  
  class func showAlert(_ title: String, message: String) {
    let topVC = self.topViewController()
    if let presentedAlert = topVC as? UIAlertController {
      presentedAlert.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
    alert.addAction(cancelAction)
    topVC!.present(alert, animated: true, completion: nil)
  }
}
