//
//  PhotoPreviewCollectionViewCell.swift
//  SoftjournFeedSwift
//
//  Created by Maksym Gorodivskyi on 4/26/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit

class PhotoGalleryCollectionViewCell: BaseGalleryCollectionViewCell {
  
  override class var identifier : String { get { return "PhotoGalleryCollectionViewCell" } }
  
  var photoURL : URL? { didSet {
    photoImageView.setImageWithURL(photoURL)
    }
  }
  
  var presentationTime = 10 { didSet {
    resetProgress()
    }
  }
  
  var progress : Double = 0 { didSet {
    circularProgressBar.progress = progress
    }
  }
  
  static let updatesPerSecond = 15
  
  fileprivate var timer : Timer?
  
  @IBOutlet weak fileprivate var circularProgressBar: KYCircularProgress!
  @IBOutlet weak fileprivate var photoImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    circularProgressBar.lineWidth = 8.0
    //    circularProgressBar.colors = [UIColor(red:0.88, green:0.85, blue:0.18, alpha:1.0), UIColor(red:0.56, green:0.76, blue:0.10, alpha:1.0), UIColor(red:0.21, green:0.46, blue:0.21, alpha:1.0)]
    circularProgressBar.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2));
    circularProgressBar.isHidden = true
  }
  
  func resetProgress() {
    progress = 0
    timer?.invalidate()
    timer = nil
  }
  
  override func startPlaying() {
    super.startPlaying()
    circularProgressBar.isHidden = false
    if (timer?.isValid ?? false) { timer!.invalidate()}
    
    let interval = 1 / Double (PhotoGalleryCollectionViewCell.updatesPerSecond)
    timer = Timer.scheduledTimer(timeInterval: interval , target: self, selector: #selector(self.updateProgress), userInfo: nil, repeats: true)
  }
  
  override func pause() {
    super.pause()
    
    timer?.invalidate()
    timer = nil
  }
  
  override func stopPlaying() {
    super.stopPlaying()
    circularProgressBar.isHidden = true
    resetProgress()
  }
  
  override func isPlaying() -> Bool {
    return timer?.isValid ?? false
  }
  
  override func clearPresentationMedia() {
    super.clearPresentationMedia()
    
    photoImageView.cancelDownloadTask()
    photoImageView.image = nil
  }
  
  func updateProgress() {
    progress = progress + 1 / Double(PhotoGalleryCollectionViewCell.updatesPerSecond) / Double(presentationTime)
    
    if (progress >= 1){
      didEndPlaying()
      resetProgress()
    }
  }
}
