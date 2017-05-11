//
//  GalleryViewController.swift
//  SoftjournFeedSwift
//
//  Created by Maksym Gorodivskyi on 4/26/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import AVKit

protocol GalleryPresenterDelegate: class {
  func displayingItem(_ itemIndex : Int)
}

class GalleryViewController: UIViewController, VideoPresenterDelegate {
  
  @IBOutlet weak var collectionView: UICollectionView?
  
  weak var delegate: GalleryPresenterDelegate?
  var pauseGestureRecognizer : UITapGestureRecognizer?
  
  var selectedItemIndex : Int { get {
    return visibleItemIndex
    }
    set (value) {
      selectItem(value, animated: true)
    }
  }
  
  var items : [FeedItemModel] = []
  
  fileprivate var firstAppearance = true
  fileprivate var visibleItemIndex = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView?.remembersLastFocusedIndexPath = false
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    pauseGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.switchPlayBackState))
    pauseGestureRecognizer!.allowedPressTypes = [NSNumber(value: UIPressType.playPause.rawValue as Int)];
    self.view.addGestureRecognizer(pauseGestureRecognizer!)
    UIApplication.shared.beginReceivingRemoteControlEvents()
    
    if (firstAppearance){
      firstAppearance = false
      if (PreferencesManager.autoPlay){
      let selectedIndexPath = IndexPath(row: selectedItemIndex, section: 0)
      if let selectedCell = collectionView?.cellForItem(at: selectedIndexPath) as? VideoGalleryCollectionViewCell {
        selectedCell.startPlaying()
      }
    }
  }
}

override func viewDidLayoutSubviews() {
  super.viewDidLayoutSubviews()
  if (firstAppearance){
    selectItem(selectedItemIndex, animated: false)
  }
}

override func viewWillDisappear(_ animated: Bool) {
  if let selectedCell = collectionView?.cellForItem(at: IndexPath(row: visibleItemIndex, section: 0)) as? BaseGalleryCollectionViewCell {
    selectedCell.stopPlaying()
    delegate?.displayingItem(selectedItemIndex)
  }
  super.viewWillDisappear(animated)
}

func presentVideoViewController(_ withUrl : URL) {
  NotificationCenter.default.addObserver(self, selector: #selector(self.finishVideoPresentation), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
  
  let playerViewController = AVPlayerViewController()
  playerViewController.player = AVPlayer(url: withUrl)
  self.present(playerViewController, animated: true, completion: {
    [unowned playerViewController] in
    playerViewController.player?.play()
    })
}

func finishVideoPresentation () {
  NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
  self.dismiss(animated: true , completion: {[unowned self] in self.selectNextItem()})
  
}

func switchPlayBackState() {
  if let visibleCell = self.collectionView?.cellForItem(at: IndexPath(row: visibleItemIndex, section: 0)) as? BaseGalleryCollectionViewCell
  { visibleCell.switchPlayBackState() }
}

func finishedScrolling() {
  updateSelectedItem()
  if (PreferencesManager.autoPlay){
    let selectedIndexPath = IndexPath(row: visibleItemIndex, section: 0)
    if let selectedCell = collectionView!.cellForItem(at: selectedIndexPath) as? BaseGalleryCollectionViewCell {
      selectedCell.startPlaying()
    }
  }
}
}

extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
  @objc(collectionView:layout:sizeForItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return view.bounds.size
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }
  
  @objc(collectionView:cellForItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let item = items[indexPath.row] as FeedItemModel
    var cell : BaseGalleryCollectionViewCell
    switch item.type! {
    case .youtube:
      cell = createYoutubeCell(item.internalIdentifier, collectionView: collectionView, indexPath: indexPath)
    case .image:
      let duration = item.duration ?? ContentManager.sharedInstance.feedModel?.defaultDuration ?? 10
      cell = createPhotoCell(item.url, duration: duration, collectionView: collectionView, indexPath: indexPath)
    }
    cell.setFinishPresentation({
      [weak self] in
      self?.selectNextItem()
      })
    return cell
  }
  
  //MARK UICollectionViewDelegate methods
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    finishedScrolling()
  }
  
  @objc(indexPathForPreferredFocusedViewInCollectionView:) func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
    return IndexPath(row: visibleItemIndex, section: 0)
  }
  
  @objc(collectionView:didSelectItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    if let cell = collectionView.cellForItem(at: indexPath) as? BaseGalleryCollectionViewCell {
      cell.switchPlayBackState()
    }
  }
  
  //MARK Helper methods
  
  func updateSelectedItem () {
    let center = view.convert(collectionView!.center, to: collectionView)
    if let centerIndexPath = collectionView?.indexPathForItem(at: center) {
      visibleItemIndex = centerIndexPath.row
    }
  }
  
  func selectNextItem() {
    let nextItem = (selectedItemIndex + 1) % (self.items.count)
    selectItem(nextItem, animated: true)
  }
  
  fileprivate func selectItem(_ atIndex: Int, animated: Bool) {
    visibleItemIndex = atIndex
    let selectedIndexPath = IndexPath(row: atIndex, section: 0)
      self.collectionView?.scrollToItem(at: selectedIndexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: animated)
      self.collectionView?.setNeedsFocusUpdate()
      self.collectionView?.updateFocusIfNeeded()
  }
  
  func createYoutubeCell(_ youTubeID: String?, collectionView: UICollectionView, indexPath: IndexPath) -> VideoGalleryCollectionViewCell {
    let videoCell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoGalleryCollectionViewCell.identifier, for: indexPath) as! VideoGalleryCollectionViewCell
    videoCell.delegate = self
    if (youTubeID?.characters.count)! > 0 { videoCell.youTubeVideoID = youTubeID }
    return videoCell
  }
  
  func createPhotoCell(_ imageString: String?, duration: Int, collectionView: UICollectionView, indexPath: IndexPath) -> PhotoGalleryCollectionViewCell {
    let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoGalleryCollectionViewCell.identifier, for: indexPath) as! PhotoGalleryCollectionViewCell
    photoCell.presentationTime = duration
    if let imageURL = URL(string: imageString!) {
      photoCell.photoURL = imageURL
    }
    return photoCell
  }
}
