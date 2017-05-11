//
//  BasePreviewCollectionViewCell.swift
//  SoftjournFeedSwift
//
//  Created by Maksym Gorodivskyi on 5/25/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit

class BasePreviewCollectionViewCell: UICollectionViewCell {
  
  class var identifier : String { get { return "BasePreviewCollectionViewCell" } }
  
  @IBOutlet weak var feedImageView: UIImageView!
  
  override func prepareForReuse() {
    feedImageView.cancelDownloadTask()
    super.prepareForReuse()
  }
}
