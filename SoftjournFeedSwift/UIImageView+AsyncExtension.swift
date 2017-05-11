//
//  UIIMageViewAsyncExtension.swift
//  SoftjournFeedSwift
//
//  Created by Maksym Gorodivskyi on 4/27/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
  func setImageWithURL(_ imageURL : URL?) {
    let placeholderImage = UIImage(named: "placeholder")
    image = placeholderImage
    if let finalImageURL = imageURL {
      kf.setImage(with: finalImageURL, placeholder: placeholderImage, options: nil, progressBlock: nil, completionHandler: nil)
    }
  }
  
  func cancelDownloadTask() {
    self.kf.cancelDownloadTask()
  }
}
