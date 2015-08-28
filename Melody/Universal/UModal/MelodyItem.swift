//
//  MelodyItem.swift
//  Melody.Tv
//
//  Created by Roger Ingouacka on 06/11/2014.
//  Copyright (c) 2014 Roger Ingouacka. All rights reserved.
//

import UIKit




import UIKit
import CoreData
import Foundation

@objc(MelodyItem)
class MelodyItem: NSManagedObject {
    @NSManaged var name:String
    @NSManaged var urlVideo:String
    @NSManaged var short_description:String
    @NSManaged var long_description:String

    @NSManaged var thumbImage:NSData
    @NSManaged var type:Int64

    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    
    init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?, name:String, urlVideo:String, thumbImageURL:String,short_description:String, long_description:String, type:Int64) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.name = name
        self.urlVideo = urlVideo
        self.short_description = short_description
        self.long_description = long_description
        self.thumbImage =    NSData(contentsOfURL: NSURL(string: thumbImageURL)!)!
        self.type = type
    }
    
    
    
}