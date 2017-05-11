//
//  PreferencesViewController.swift
//  SoftjournFeedSwift
//
//  Created by Maksym Gorodivskyi on 6/6/16.
//  Copyright © 2016 Softjourn. All rights reserved.
//

import UIKit

class PreferencesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  enum PreferenceType : Int {
    case layoutStyle
    case serverUrl
//    case autoPlay
    case refreshContent
    case refreshRate
    case reset
  }
    @IBOutlet weak var tableView: UITableView!
  
  func attributes(_ forPreference : PreferenceType) -> (title : String, detail : String) {
    switch forPreference {
    case .layoutStyle:
      return ("Preferred Layout style", PreferencesManager.preferredLayout.title())
    case .serverUrl:
      return ("Server URL", PreferencesManager.baseUrl)
//    case .autoPlay:
//      return ("Autoplay Video", PreferencesManager.autoPlay ? "Yes" : "No")
    case .refreshContent:
      return ("Refresh content", "")
    case .refreshRate:
      return ("Content refresh period", PreferencesManager.contentRefreshPeriod > 0 ? String( PreferencesManager.contentRefreshPeriod) + " Minutes" : "Never")
    case .reset:
      return ("Reset to defaults", "")
    }
  }
  
  
  func showLayoutSelectDialog() {
    let layoutSelectVC = self.storyboard?.instantiateViewController(withIdentifier: "LayoutSelectionViewController") as! LayoutSelectionViewController
    self.present(layoutSelectVC, animated: true, completion: nil)
  }
  
  func showSelectAutoRefresh() {
    let actionSheet = UIAlertController(title: "Automatically refresh content period", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
    for minuteVal in PreferencesManager.availableRefreshPeriods {
      let text = minuteVal > 0 ? String(minuteVal) + " Minutes" : "Never"
      let action = UIAlertAction(title: text, style: UIAlertActionStyle.default) { [unowned self] (_) in
        PreferencesManager.contentRefreshPeriod = minuteVal
        self.tableView.reloadData()
      }
      actionSheet.addAction(action)
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
    actionSheet.addAction(cancelAction)
    self.present(actionSheet, animated: true, completion: nil)
  }
  
  func showServerUrlInput() {
    // TODO: Change to textfield
    let alert = UIAlertController(title: "Change server url", message: "", preferredStyle: UIAlertControllerStyle.alert)
    alert.addTextField { (textField) in
      textField.text = PreferencesManager.baseUrl
    }
    let okAction = UIAlertAction(title: "Change", style: UIAlertActionStyle.default) { [unowned self] (_) in
      if let newUrl = alert.textFields?.first?.text {
        if let _ = URL(string: newUrl) , newUrl.characters.count > 0 {
          PreferencesManager.baseUrl = newUrl
          self.tableView.reloadData()
        }
        else {AlertManager.showAlert("Error", message: "Entered url is invalid, please try again")}
      }
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
    alert.addAction(okAction)
    alert.addAction(cancelAction)
    self.present(alert, animated: true, completion: nil)
  }
  
  func resetToDefaults() {
    let alert = UIAlertController(title: "Are you sure that you want to reset preferences to default values?", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
    let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive) {
      [unowned self]
      (_) in
      PreferencesManager.setInitialValues()
      self.tableView.reloadData()
    }
    
    let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil)
    alert.addAction(yesAction)
    alert.addAction(noAction)
    self.present(alert, animated: true, completion: nil)
  }
  
//  func switchAutoPlay () {
//    PreferencesManager.autoPlay = !PreferencesManager.autoPlay
//    self.tableView.reloadRows(at: [IndexPath(row: PreferenceType.autoPlay.rawValue, section: 0)], with: UITableViewRowAnimation.none)
//  }
}

extension PreferencesViewController {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
  @objc(tableView:cellForRowAtIndexPath:) func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCell(withIdentifier: "PreferencesTableViewCell", for: indexPath)
    let attributes = self.attributes(PreferenceType(rawValue: indexPath.row)!)
    cell.textLabel?.text = attributes.title
    cell.detailTextLabel?.text = attributes.detail
    return cell
  }
  
  @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let preferenceOrder = PreferenceType(rawValue: indexPath.row)!
    switch  preferenceOrder{
    case .layoutStyle:
      showLayoutSelectDialog()
    case .serverUrl:
      self.showServerUrlInput()
//    case .autoPlay:
//      switchAutoPlay()
    case .refreshContent:
      ContentManager.sharedInstance.updateContent()
    case .refreshRate:
      self.showSelectAutoRefresh()
    case .reset:
      self.resetToDefaults()
    }
  }
}
