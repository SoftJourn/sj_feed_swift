//
//  TitleCollectionHeaderView.swift
//  SoftjournFeedSwift
//
//  Created by Maksym Gorodivskyi on 5/18/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit

class TitleCollectionHeaderView: UICollectionReusableView {
  
  typealias TitleHeaderAction = () -> Void
  
  var onPlaySelected    : TitleHeaderAction?
  var onRefreshSelected : TitleHeaderAction?
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var playButton: UIButton!
  @IBOutlet weak var refreshButton: UIButton!
  
  
  @IBAction func playASelected(_ sender: AnyObject) {
    onPlaySelected?();
  }
  
  @IBAction func refreshSelected(_ sender: AnyObject) {
    onRefreshSelected?()
  }
}
