//
//  LargeCollectionViewLayout.swift
//  SoftjournFeedSwift
//
//  Created by Maksym Gorodivskyi on 6/8/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit

class LargeCollectionViewLayout: UICollectionViewFlowLayout {
  override func prepare() {
    super.prepare()
    let insetMargin : CGFloat = 100
    let numberOfItemsPerRow = 3
    minimumInteritemSpacing = 80
    minimumLineSpacing = minimumInteritemSpacing
    let screenSize = UIScreen.main.bounds.size
    let itemPartSize = floor(screenSize.width - CGFloat(insetMargin * 2) - minimumInteritemSpacing * CGFloat(numberOfItemsPerRow - 1)) / CGFloat(numberOfItemsPerRow)
    itemSize = CGSize(width: itemPartSize, height: itemPartSize/16*9)
    scrollDirection = UICollectionViewScrollDirection.vertical
    sectionInset = UIEdgeInsets(top: 190, left: insetMargin, bottom: insetMargin, right: insetMargin)
    //        headerReferenceSize = CGSize(width: 0, height: 260)
  }
  
}
