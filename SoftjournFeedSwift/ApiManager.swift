//
//  ApiManager.swift
//  SoftjournFeedSwift
//
//  Created by Maksym Gorodivskyi on 4/22/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import Alamofire

class ApiManager: NSObject {
  
  typealias FeedResultCallback = (_ result: FeedModel?, _ error: Error?)->()
  
  class func getFeed(_ completion: @escaping FeedResultCallback) {
    Alamofire.request(PreferencesManager.baseUrl)
      .responseJSON { response in
        let feedModel = FeedModel(object: response.result.value as AnyObject)
        let error = response.result.error
        completion(feedModel, error)
    }
  }
}
