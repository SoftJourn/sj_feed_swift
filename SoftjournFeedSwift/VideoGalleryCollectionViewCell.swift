//
//  VideoPreviewCollectionViewCell.swift
//  SoftjournFeedSwift
//
//  Created by Maksym Gorodivskyi on 4/26/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import AVKit
import XCDYouTubeKit

protocol VideoPresenterDelegate: class {
  func presentVideoViewController(_ withUrl : URL)
}

class VideoGalleryCollectionViewCell: BaseGalleryCollectionViewCell {
  
  override class var identifier : String { get { return "VideoGalleryCollectionViewCell" } }
  
  @IBOutlet weak var previewImageView: UIImageView!
  
  weak var delegate : VideoPresenterDelegate?
  
  var youTubeVideoID : String? { didSet {
    previewImageView.image = UIImage(named: "placeholder")
    _ = YouTubeManager.sharedInstance.getYoutubeVideo(youTubeVideoID!, completionHandler: {
      [unowned self] (video, error) in
      if (error == nil){
        self.youTubeVideoItem = video
        self.previewImageView.setImageWithURL(video?.largeThumbnailURL)
      }
      })
    }
  }
  
  fileprivate var youTubeVideoItem : XCDYouTubeVideo?
  
  override func startPlaying() {
    guard (youTubeVideoItem != nil) else {
      print("Attempt to start playing video without source")
      return
    }
    if let highestQualityVideoURL = YouTubeManager.sharedInstance.getHighestQualityURLForVideo(youTubeVideoItem!) {
      self.delegate?.presentVideoViewController(highestQualityVideoURL)
    }
  }
  
  override func playAutomitacally() {
    return
  }
  
  override func isPlaying() -> Bool {
    return false
  }
  
  override func clearPresentationMedia() {
    super.clearPresentationMedia()
    previewImageView.cancelDownloadTask()
    previewImageView.image = nil
  }
  
}
