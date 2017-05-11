//
//  VideoPreviewCollectionViewCell.swift
//  SoftjournFeedSwift
//
//  Created by Maksym Gorodivskyi on 5/25/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import AVKit
import XCDYouTubeKit

class VideoPreviewCollectionViewCell: BasePreviewCollectionViewCell {
  
  override class var identifier : String { get { return "VideoPreviewCollectionViewCell" } }
  
  var youTubeVideoID : String? { didSet {
    feedImageView.image = UIImage(named: "placeholder")
    _ = YouTubeManager.sharedInstance.getYoutubeVideo(youTubeVideoID!, completionHandler: {
      [weak self] (video, error) in
      guard (self != nil) else {return}
      if (error == nil){
        self?.feedImageView.setImageWithURL(video?.largeThumbnailURL)
      }
      })
    }
  }
}
