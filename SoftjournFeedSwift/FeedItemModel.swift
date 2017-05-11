//
//  Items.swift
//
//  Created by Maksym Gorodivskyi on 4/22/16
//  Copyright (c) Softjourn. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper

public enum ItemType : String {
  case youtube = "youtube"
  case image = "image"
}

open class FeedItemModel: NSObject, Mappable, NSCoding {
  
  // MARK: Declaration for string constants to be used to decode and also serialize.
  internal let kItemsOwnerKey: String = "owner"
  internal let kItemsInternalIdentifierKey: String = "id"
  internal let kItemsCreatedKey: String = "created"
  internal let kItemsDurationKey: String = "duration"
  internal let kItemsThumbnailKey: String = "thumbnail"
  internal let kItemsUrlKey: String = "url"
  internal let kItemsTypeKey: String = "type"
  
  
  // MARK: Properties
  open var owner: String?
  open var internalIdentifier: String?
  open var created: Int?
  open var duration: Int?
  open var thumbnail: String?
  open var url: String?
  open var type: ItemType?
  
  
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
    owner = json[kItemsOwnerKey].string
    internalIdentifier = json[kItemsInternalIdentifierKey].string
    created = json[kItemsCreatedKey].int
    duration = json[kItemsDurationKey].int
    thumbnail = json[kItemsThumbnailKey].string
    url = json[kItemsUrlKey].string
    type = ItemType(rawValue: json[kItemsTypeKey].string!)
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
    owner <- map[kItemsOwnerKey]
    internalIdentifier <- map[kItemsInternalIdentifierKey]
    created <- map[kItemsCreatedKey]
    duration <- map[kItemsDurationKey]
    thumbnail <- map[kItemsThumbnailKey]
    url <- map[kItemsUrlKey]
    type <- map[kItemsTypeKey]
    
  }
  
  /**
   Generates description of the object in the form of a NSDictionary.
   - returns: A Key value pair containing all valid values in the object.
   */
  open func dictionaryRepresentation() -> [String : AnyObject ] {
    
    var dictionary: [String : AnyObject ] = [ : ]
    if owner != nil {
      dictionary.updateValue(owner! as AnyObject, forKey: kItemsOwnerKey)
    }
    if internalIdentifier != nil {
      dictionary.updateValue(internalIdentifier! as AnyObject, forKey: kItemsInternalIdentifierKey)
    }
    if created != nil {
      dictionary.updateValue(created! as AnyObject, forKey: kItemsCreatedKey)
    }
    if duration != nil {
      dictionary.updateValue(duration! as AnyObject, forKey: kItemsDurationKey)
    }
    if thumbnail != nil {
      dictionary.updateValue(thumbnail! as AnyObject, forKey: kItemsThumbnailKey)
    }
    if url != nil {
      dictionary.updateValue(url! as AnyObject, forKey: kItemsUrlKey)
    }
    if type != nil {
      dictionary.updateValue(type!.rawValue as AnyObject , forKey: kItemsTypeKey)
    }
    
    return dictionary
  }
  
  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.owner = aDecoder.decodeObject(forKey: kItemsOwnerKey) as? String
    self.internalIdentifier = aDecoder.decodeObject(forKey: kItemsInternalIdentifierKey) as? String
    self.created = aDecoder.decodeObject(forKey: kItemsCreatedKey) as? Int
    self.duration = aDecoder.decodeObject(forKey: kItemsDurationKey) as? Int
    self.thumbnail = aDecoder.decodeObject(forKey: kItemsThumbnailKey) as? String
    self.url = aDecoder.decodeObject(forKey: kItemsUrlKey) as? String
    self.type = ItemType(rawValue: aDecoder.decodeObject(forKey: kItemsTypeKey) as! String)
    
  }
  
  open func encode(with aCoder: NSCoder) {
    aCoder.encode(owner, forKey: kItemsOwnerKey)
    aCoder.encode(internalIdentifier, forKey: kItemsInternalIdentifierKey)
    aCoder.encode(created, forKey: kItemsCreatedKey)
    aCoder.encode(duration, forKey: kItemsDurationKey)
    aCoder.encode(thumbnail, forKey: kItemsThumbnailKey)
    aCoder.encode(url, forKey: kItemsUrlKey)
    aCoder.encode(type?.rawValue, forKey: kItemsTypeKey)
    
  }
  
}
