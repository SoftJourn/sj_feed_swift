//
//  YouTubeManager.swift
//  SoftjournFeedSwift
//
//  Created by Maksym Gorodivskyi on 4/27/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//
import Foundation
import XCDYouTubeKit

class YouTubeManager {
  
  static let sharedInstance = YouTubeManager()
  let youtubeVideoQualities = [XCDYouTubeVideoQuality.HD720, XCDYouTubeVideoQuality.medium360, XCDYouTubeVideoQuality.small240]
  var cachedItems = [String : XCDYouTubeVideo]()
  
  func getYoutubeVideo(_ videoID: String, completionHandler: @escaping (XCDYouTubeVideo?, Error?) -> Void) -> XCDYouTubeOperation? {
    if let video = self.cachedItems[videoID] {completionHandler(video, nil)}
    else {
      return XCDYouTubeClient.default().getVideoWithIdentifier(videoID, completionHandler:  {
        [unowned self]
        (video, error) in
        if video != nil && !self.cachedItems.contains( where: { $0.key == videoID }){
          self.cachedItems[videoID] = video
        }
        completionHandler(video, error)
        })
    }
    return nil
  }
  
  func getHighestQualityURLForVideo(_ video: XCDYouTubeVideo) -> URL? {
    let streamURLs = video.streamURLs as NSDictionary
    for quality in youtubeVideoQualities{
      if let streamURL = getVideoURLFromDictionary(streamURLs, forQuality: quality) { return streamURL}
    }
    return nil
  }
  
  func getLowestQualityURLForVideo(_ video: XCDYouTubeVideo) -> URL? {
    let streamURLs = video.streamURLs as NSDictionary
    for quality in youtubeVideoQualities.reversed(){
      if let streamURL = getVideoURLFromDictionary(streamURLs, forQuality: quality) { return streamURL}
    }
    return nil
  }
  
  func getVideoURLFromDictionary(_ dictionary: NSDictionary, forQuality: XCDYouTubeVideoQuality) -> URL? {
    return dictionary[NSNumber(value: forQuality.rawValue as UInt)] as? URL
  }
}
