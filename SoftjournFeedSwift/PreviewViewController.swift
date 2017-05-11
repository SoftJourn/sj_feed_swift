//
//  PreviewViewController.swift
//  SoftjournFeedSwift
//
//  Created by Maksym Gorodivskyi on 4/26/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import XCDYouTubeKit
import SVProgressHUD


enum GalleryContentType : String {
  case all    = "All"
  case photos = "Photos"
  case videos = "Videos"
  
  static let allValues = [all,photos,videos]
}

class PreviewViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, GalleryPresenterDelegate {
  
  var contentType : GalleryContentType = GalleryContentType.all
  fileprivate var items : [FeedItemModel] = []
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.remembersLastFocusedIndexPath = false
    
    setItemsForType()
    updateLayout()
    NotificationCenter.default.addObserver(self, selector: #selector(updateContent), name: NSNotification.Name(rawValue: kContentRefreshedNotification), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(updateLayout), name: NSNotification.Name(rawValue: kPreferredLayoutChangedNotification), object: nil)
  }
  
  override weak var preferredFocusedView: UIView? {
    return collectionView
  }
  
  fileprivate func setItemsForType() {
    if let feedModel = ContentManager.sharedInstance.feedModel{
      items = feedModel.items
      switch contentType {
      case .videos:
        items = items.filter({ (feedItem) -> Bool in
          feedItem.type == ItemType.youtube
        })
      case .photos:
        items = items.filter({ (feedItem) -> Bool in
          feedItem.type == ItemType.image
        })
      default : return;
      }
    }
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kContentRefreshedNotification), object: nil)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kPreferredLayoutChangedNotification), object: nil)
  }
  
  func updateContent() {
    self.setItemsForType()
    self.collectionView!.reloadData()
  }
  
  func updateLayout()
  {
    var layout : UICollectionViewLayout
    switch PreferencesManager.preferredLayout {
    case .verticalSmall:
      layout = DefaultCollectionViewLayout()
    case .verticalLarge:
      layout = LargeCollectionViewLayout()
    case .horizontalMedium:
      layout = FourCollectionViewLayout()
    case .horizontalLarge:
      layout = LGHorizontalLinearFlowLayout.configureLayout(collectionView: self.collectionView, itemSize: CGSize(width: 1200, height: 675), minimumLineSpacing: 0)
    }
    self.collectionView.collectionViewLayout.invalidateLayout()
    self.collectionView.setCollectionViewLayout(layout, animated: false)
    self.collectionView.setContentOffset(CGPoint.zero, animated: false)
    
    
  }
  
  func displayingItem(_ itemIndex : Int) {
    let selectedIndexPath = IndexPath(row: itemIndex, section: 0)
    collectionView(collectionView, selectedItemIndexIndexPath: selectedIndexPath)
  }
  
  func showGallery (_ selectedItemIndexIndex : Int) {
    let gallery = self.storyboard?.instantiateViewController(withIdentifier: "GalleryViewController") as! GalleryViewController
    gallery.items = self.items
    gallery.selectedItemIndex = selectedItemIndexIndex
    gallery.delegate = self
    self.present(gallery, animated: true, completion: nil)
  }
  
  func playClicked() {
    showGallery(0)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    //Weird workaround to update focus
    DispatchQueue.main.async {
      self.collectionView.collectionViewLayout.invalidateLayout()
      self.setNeedsFocusUpdate()
      self.updateFocusIfNeeded()
    }
  }
}

extension PreviewViewController {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.items.count
  }
  
  
  @objc(collectionView:cellForItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let item = items[indexPath.row % self.items.count] as FeedItemModel
    var cell : BasePreviewCollectionViewCell
    switch item.type! {
    case .youtube:
      cell =   self.createYoutubeCell(item.internalIdentifier, collectionView: collectionView, indexPath: indexPath)
    case .image:
      cell =  self.createPhotoCell(item.url, collectionView: collectionView, indexPath: indexPath)
    }
    
    return cell
  }
  
  
  @objc(collectionView:willDisplayCell:forItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    cell.alpha = 0.5
    //                cell.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
    UIView.animate(withDuration: 0.4, animations: { () -> Void in
      cell.alpha = 1
      //                        cell.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
    })
  }
  
  //    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
  //        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "TitleCollectionHeaderView", forIndexPath: indexPath) as! TitleCollectionHeaderView
  //        headerView.titleLabel.text = contentType.rawValue
  //        headerView.onRefreshSelected = { ContentManager.updateContent() }
  //        headerView.onPlaySelected = { [unowned self] in self.playClicked() }
  //        return headerView
  //    }
  
  @objc(indexPathForPreferredFocusedViewInCollectionView:) func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
    return collectionView.indexPathsForSelectedItems?.first
  }
  
  @objc(collectionView:didSelectItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    showGallery(collectionView.indexPathsForSelectedItems!.first!.row)
  }
  
  func collectionView(_ collectionView : UICollectionView, selectedItemIndexIndexPath : IndexPath) {
    collectionView.selectItem(at: selectedItemIndexIndexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
    collectionView.scrollToItem(at: selectedItemIndexIndexPath, at: UICollectionViewScrollPosition(), animated: true)
    setNeedsFocusUpdate()
  }
  
  func createYoutubeCell(_ youTubeID: String?, collectionView: UICollectionView, indexPath: IndexPath) -> VideoPreviewCollectionViewCell {
    let videoCell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoPreviewCollectionViewCell.identifier, for: indexPath) as! VideoPreviewCollectionViewCell
    if (youTubeID?.characters.count)! > 0 { videoCell.youTubeVideoID = youTubeID }
    return videoCell
  }
  
  func createPhotoCell(_ imageString: String?, collectionView: UICollectionView, indexPath: IndexPath) -> PhotoPreviewCollectionViewCell {
    let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoPreviewCollectionViewCell.identifier, for: indexPath) as! PhotoPreviewCollectionViewCell
    if let imageURL = URL(string: imageString!) {
      photoCell.photoImageURL = imageURL
    }
    return photoCell
  } 
}
