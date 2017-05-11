//
//  GalleryCollectionViewLayout.swift
//  SoftjournFeedSwift
//
//  Created by Maksym Gorodivskyi on 5/24/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit

class DefaultCollectionViewLayout: UICollectionViewFlowLayout {
  
  override func prepare() {
    super.prepare()
    minimumLineSpacing = 50
    minimumInteritemSpacing = 50
    itemSize = CGSize(width: 320, height: 180)
    scrollDirection = UICollectionViewScrollDirection.vertical
    sectionInset = UIEdgeInsets(top: 190, left: 50, bottom: 50, right: 50)    
  }
}
