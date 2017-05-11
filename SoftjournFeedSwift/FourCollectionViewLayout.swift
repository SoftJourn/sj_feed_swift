//
//  FourCollectionViewLayout.swift
//  SoftjournFeedSwift
//
//  Created by Maksym Gorodivskyi on 6/8/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit

class FourCollectionViewLayout: UICollectionViewFlowLayout {
  override func prepare() {
    super.prepare()
    let insetMargin : CGFloat = 100
    let numberOfItemsPerRow = 2
    minimumInteritemSpacing = 80
    minimumLineSpacing = 80
    let screenSize = UIScreen.main.bounds.size
    let itemPartSize = floor(screenSize.height - 100 - CGFloat(insetMargin * 2) - minimumInteritemSpacing * CGFloat(numberOfItemsPerRow - 1)) / CGFloat(numberOfItemsPerRow)
    itemSize = CGSize(width: itemPartSize/9*16, height: itemPartSize)
    scrollDirection = UICollectionViewScrollDirection.horizontal
    sectionInset = UIEdgeInsets(top: 190, left: insetMargin, bottom: insetMargin, right: insetMargin)
    //        headerReferenceSize = CGSize(width: 0, height: 260)
  }
}
