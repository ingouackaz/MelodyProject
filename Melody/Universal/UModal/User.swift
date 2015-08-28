//
//  User.swift
//  Melody.Tv
//
//  Created by Roger Ingouacka on 29/10/2014.
//  Copyright (c) 2014 Roger Ingouacka. All rights reserved.
//

import UIKit

import CoreData
import Foundation


@objc(User)
class User: NSManagedObject {
    @NSManaged var name:String
    @NSManaged var address:String
    @NSManaged var birthdate:String
    @NSManaged var city:String
    @NSManaged var country:String
    @NSManaged var email:String
    @NSManaged var gender:String
    @NSManaged var phone:String
    @NSManaged var subscribed:String
    @NSManaged var surname:String
    @NSManaged var token:String

    @NSManaged var museeLastUpdate:NSDate?
    @NSManaged var artistLastUpdate:NSDate?
    @NSManaged var themeLastUpdate:NSDate?

    
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?, name:String, address:String, birthdate:String, city:String, country:String, email:String, gender:String, phone:String, subscribed:String, surname:String,token:String) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        self.name = name
        self.address = address
        self.birthdate = birthdate
        self.city = city
        self.country = country
        self.email = email
        self.gender = gender
        self.phone = phone
        self.subscribed = subscribed
        self.surname = surname
        self.token = token
        context?.save(nil)
    }
    

}