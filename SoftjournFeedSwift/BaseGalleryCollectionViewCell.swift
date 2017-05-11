//
//  BaseGalleryCollectionViewCell.swift
//  SoftjournFeedSwift
//
//  Created by Maksym Gorodivskyi on 4/27/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit

class BaseGalleryCollectionViewCell: UICollectionViewCell {
  
  class var identifier : String { get { return "BaseGalleryCollectionViewCell" } }
  
  typealias GalleryPresentationCompletion = () -> Void
  
  var onFinishPresentation : GalleryPresentationCompletion?
  
  func setFinishPresentation (_ completion: @escaping () -> Void ) {
    onFinishPresentation = completion
  }
  
  override func prepareForReuse() {
    clearPresentationMedia()
    super.prepareForReuse()
  }
  
  func didEndPlaying() {
    stopPlaying()
    onFinishPresentation?()
  }
  
  func clearPresentationMedia() {
    stopPlaying()
  }
  
  func pause() {}
  
  func playAutomitacally() { startPlaying() }
  
  func startPlaying() {}
  
  func stopPlaying() {}
  
  func isPlaying()-> Bool
  {
    return false
  }
  
  override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
    if (context.nextFocusedView == self){
      self.playAutomitacally()
    }
    else {self.stopPlaying()}
  }
  
  
  override func  awakeFromNib() {
    super.awakeFromNib()
  }
  
  func switchPlayBackState() {
    isPlaying() ? pause() : startPlaying()
  }
}
