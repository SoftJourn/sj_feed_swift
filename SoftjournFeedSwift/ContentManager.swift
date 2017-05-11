//
//  ContentManager.swift
//  SoftjournFeedSwift
//
//  Created by Maksym Gorodivskyi on 4/22/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import SVProgressHUD

let kContentRefreshedNotification = "kContentRefreshedNotification"

class ContentManager: NSObject {
  
  static let sharedInstance = ContentManager()
  
  
  var feedModel : FeedModel?
  func updateContent() {
    SVProgressHUD.setBackgroundLayerColor(UIColor.white.withAlphaComponent(0.4))
    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.custom)
    SVProgressHUD.show()
    ApiManager.getFeed {
      [unowned self]
      (feedModel, error) in
      SVProgressHUD.dismiss(withDelay: 0.5)
      if (error == nil){
        self.feedModel = feedModel
        NotificationCenter.default.post(name: Notification.Name(rawValue: kContentRefreshedNotification), object: feedModel)
      }
      else {
        AlertManager.showAlert("Error", message: error!.localizedDescription)
      }
    }
  }
  
  func startAutomaticUpdate() {
    //TODO change to timer
    NSObject.cancelPreviousPerformRequests(withTarget: self)
    let refreshInterval = PreferencesManager.contentRefreshPeriod
    if (refreshInterval > 0) {
      let time = Int64(UInt64(refreshInterval * 60) * NSEC_PER_SEC)
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(time) / Double(NSEC_PER_SEC)) {
        [unowned self] in
        self.updateContent()
        self.startAutomaticUpdate()
      }
    }
  }
}
