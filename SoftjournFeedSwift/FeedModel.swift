//
//  NSObject.swift
//
//  Created by Maksym Gorodivskyi on 4/22/16
//  Copyright (c) Softjourn. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper

open class FeedModel: NSObject, Mappable, NSCoding {
  
  // MARK: Declaration for string constants to be used to decode and also serialize.
  internal let kNSObjectOrderKey: String = "order"
  internal let kNSObjectDefaultDurationKey: String = "defaultDuration"
  internal let kNSObjectItemsKey: String = "items"
  
  
  // MARK: Properties
  open var order: String?
  open var defaultDuration: Int?
  open var items: [FeedItemModel] = []
  
  
  // MARK: SwiftyJSON Initalizers
  /**
   Initates the class based on the object
   - parameter object: The object of either Dictionary or Array kind that was passed.
   - returns: An initalized instance of the class.
   */
  convenience public init(object: AnyObject) {
    self.init(json: JSON(object))
  }
  
  /**
   Initates the class based on the JSON that was passed.
   - parameter json: JSON object from SwiftyJSON.
   - returns: An initalized instance of the class.
   */
  public init(json: JSON) {
    order = json[kNSObjectOrderKey].string
    defaultDuration = json[kNSObjectDefaultDurationKey].int
    if let parsedItems = json[kNSObjectItemsKey].array {
      for item in parsedItems {
        items.append(FeedItemModel(json: item))
      }
    }
    
  }
  
  // MARK: ObjectMapper Initalizers
  /**
   Map a JSON object to this class using ObjectMapper
   - parameter map: A mapping from ObjectMapper
   */
  required public init?(map: Map){
    
  }
  
  /**
   Map a JSON object to this class using ObjectMapper
   - parameter map: A mapping from ObjectMapper
   */
  open func mapping(map: Map) {
    order <- map[kNSObjectOrderKey]
    defaultDuration <- map[kNSObjectDefaultDurationKey]
    items <- map[kNSObjectItemsKey]
    
  }
  
  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
   */
  open func dictionaryRepresentation() -> [String : AnyObject ] {
    
    var dictionary: [String : AnyObject ] = [ : ]
    if order != nil {
      dictionary.updateValue(order! as AnyObject, forKey: kNSObjectOrderKey)
    }
    if defaultDuration != nil {
      dictionary.updateValue(defaultDuration! as AnyObject, forKey: kNSObjectDefaultDurationKey)
    }
    if items.count > 0 {
      var temp: [AnyObject] = []
      for item in items {
        temp.append(item.dictionaryRepresentation() as AnyObject)
      }
      dictionary.updateValue(temp as AnyObject, forKey: kNSObjectItemsKey)
    }
    
    return dictionary
  }
  
  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.order = aDecoder.decodeObject(forKey: kNSObjectOrderKey) as? String
    self.defaultDuration = aDecoder.decodeObject(forKey: kNSObjectDefaultDurationKey) as? Int
    self.items = aDecoder.decodeObject(forKey: kNSObjectItemsKey) as! [FeedItemModel]
    
  }
  
  open func encode(with aCoder: NSCoder) {
    aCoder.encode(order, forKey: kNSObjectOrderKey)
    aCoder.encode(defaultDuration, forKey: kNSObjectDefaultDurationKey)
    aCoder.encode(items, forKey: kNSObjectItemsKey)
    
  }
  
}
