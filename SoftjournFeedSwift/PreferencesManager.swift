//
//  GlobalVariables.swift
//  SoftjournFeedSwift
//
//  Created by Maksym Gorodivskyi on 5/30/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

let kPreferredLayoutChangedNotification = "kPreferredLayoutChangedNotification"

class PreferencesManager: NSObject {
  
  enum LayoutStyle : Int {
    case verticalSmall
    case verticalLarge
    case horizontalMedium
    case horizontalLarge
    
    
    func title() -> String {
      switch self {
      case .verticalSmall:
        return "Small Vertical List"
      case .verticalLarge:
        return "Medium Vertical List"
      case .horizontalMedium:
        return "Large Horizontal List"
      case .horizontalLarge:
        return "Preview Horizontal List"
      }
    }
  }
  
  static let defaultUrl = "https://demo-tv.softjourn.if.ua/playlist.json"//"https://tv.softjourn.if.ua/playlist.json"
  static let availableRefreshPeriods = [0, 2, 5, 10, 30]
  
  class var preferredLayout: LayoutStyle {
    get {
      return LayoutStyle(rawValue: Defaults[.preferredLayout])!
    }
    set (newLayoutStyle) {
      Defaults[.preferredLayout] = newLayoutStyle.rawValue
      NotificationCenter.default.post(name: Notification.Name(rawValue: kPreferredLayoutChangedNotification), object: NSObject())
    }
  }
  
  class var baseUrl: String {
    get {
      return Defaults[.baseUrl]
    }
    set (newUrl) {
      Defaults[.baseUrl] = newUrl
      ContentManager.sharedInstance.updateContent()
    }
  }
  
//  class var autoPlay: Bool {
//    get {
//      return Defaults[.autoPlay]
//    }
//    set(newAutoPlay) {
//      Defaults[.autoPlay] = newAutoPlay
//    }
//  }
  
  class var contentRefreshPeriod: Int {
    get {
      return Defaults[.contentRefreshPeriod]
    }
    set(newPeriod) {
      Defaults[.contentRefreshPeriod] = newPeriod
      ContentManager.sharedInstance.startAutomaticUpdate()
    }
  }
  
  class func setInitialValues() {
    self.baseUrl = PreferencesManager.defaultUrl
//    self.autoPlay = true
    self.contentRefreshPeriod = 30
    self.preferredLayout = .verticalLarge
  }
  
  class func checkFirstRun() -> Bool {
    let firstRun = !Defaults.hasKey(.firstRun)
    if firstRun{
      setInitialValues()
      Defaults[.firstRun] = false
    }
    return firstRun
  }
}

extension DefaultsKeys {
  static let preferredLayout = DefaultsKey<Int>("preferredLayout")
  static let baseUrl = DefaultsKey<String>("baseUrl")
  static let autoPlay = DefaultsKey<Bool>("autoPlay")
  static let contentRefreshPeriod = DefaultsKey<Int>("contentRefreshPeriod")
  static let firstRun = DefaultsKey<Bool?>("firstRun")
}
