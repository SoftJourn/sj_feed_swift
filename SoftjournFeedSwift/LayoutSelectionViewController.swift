//
//  LayoutSelectionViewController.swift
//  SoftjournFeedSwift
//
//  Created by Maksym Gorodivskyi on 6/8/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit

class LayoutSelectionViewController: UIViewController {
  
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var changeLayoutButton: UIButton!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    segmentedControl.selectedSegmentIndex = PreferencesManager.preferredLayout.rawValue
  }
  
  @IBAction func changedPreferredLayout(_ sender: AnyObject) {
    PreferencesManager.preferredLayout = PreferencesManager.LayoutStyle(rawValue: segmentedControl.selectedSegmentIndex)!
    self.presentingViewController?.dismiss(animated: true, completion: nil)
  }
  
}
