//
//  MelodyCoreData.swift
//  Melody.Tv
//
//  Created by Roger Ingouacka on 04/11/2014.
//  Copyright (c) 2014 Roger Ingouacka. All rights reserved.
//

import UIKit
import CoreData
import Foundation


@objc(MelodyCoreData)
class MelodyCoreData: NSManagedObject {
    @NSManaged var actuLastUpdate:String
    @NSManaged var replayLastUpdate:String
    @NSManaged var movieLastUpdate:String
    @NSManaged var concertLastUpdate:String
    @NSManaged var starLastUpdate:String
    @NSManaged var varieteLastUpdate:String
    @NSManaged var storyLastUpdate:String


    @NSManaged var streamUrl:String

    var _context : NSManagedObjectContext?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)

        self._context  = context
        self.streamUrl = String()
        self.actuLastUpdate = ""
        self.replayLastUpdate = ""
        self.movieLastUpdate = ""
        self.concertLastUpdate = ""
        self.starLastUpdate = ""
        self.varieteLastUpdate = ""
        self.storyLastUpdate = ""

    }
    
    func clearLastUpdate(){

        
        self.actuLastUpdate = ""
        self.replayLastUpdate = ""
        self.movieLastUpdate = ""
        self.concertLastUpdate = ""
        self.starLastUpdate = ""
        self.varieteLastUpdate = ""
        self.varieteLastUpdate = ""

    }
  
    func getLastUpdate(atIndex index:Int) -> String {
        switch(index){
            
        case 1 :
            return self.concertLastUpdate
        case 2 :
            return self.movieLastUpdate
        case 3 :
            return self.starLastUpdate
        case 4 :
           return self.storyLastUpdate
        default:
            return self.varieteLastUpdate
        }
    }
    
    func setLastUpdate(string: String, atIndex index:Int){
        switch(index){
        
        case 1 :
            self.concertLastUpdate = string
        case 2 :
            self.movieLastUpdate = string
        case 3 :
            self.starLastUpdate = string
        case 4 :
            self.storyLastUpdate = string

        default:
            println("save lupdate artist")

            self.varieteLastUpdate = string
        }
        self._context!.save(nil)
    }
    
}
