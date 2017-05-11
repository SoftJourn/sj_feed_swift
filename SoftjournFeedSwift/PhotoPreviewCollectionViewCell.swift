//
//  PhotoPreviewCollectionViewCell.swift
//  SoftjournFeedSwift
//
//  Created by Maksym Gorodivskyi on 5/25/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit

class PhotoPreviewCollectionViewCell: BasePreviewCollectionViewCell {
  
  override class var identifier : String { get { return "PhotoPreviewCollectionViewCell" } }
  
  var photoImageURL : URL? { didSet {
    feedImageView.setImageWithURL(photoImageURL)
    }
  }
}
