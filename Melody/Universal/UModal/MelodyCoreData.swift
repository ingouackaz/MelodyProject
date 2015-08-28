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
        self.storyLastUpdate = ""
    }
  
    func getLastUpdate(atIndex index:Int) -> String {
        switch(index){
            
        case 0 :
            return self.actuLastUpdate

        case 1 :
            return self.varieteLastUpdate
        case 2 :
            return self.concertLastUpdate
        case 3 :
            return self.movieLastUpdate
        case 4 :
           return self.starLastUpdate
        case 5 :
            return self.storyLastUpdate
        case 6 :
            return self.replayLastUpdate
        default:
            return ""
        }
    }
    
    
    func getLastUpdateDate(atIndex index:Int) -> NSDate {
        switch(index){

        case 1 :
            return (self.varieteLastUpdate as NSString).tolastUpdateFormatNSDate()
        case 2 :
            return (self.concertLastUpdate as NSString).tolastUpdateFormatNSDate()
        case 3 :
            return (self.movieLastUpdate as NSString).tolastUpdateFormatNSDate()
        case 4 :
            return (self.starLastUpdate as NSString).tolastUpdateFormatNSDate()
        case 5 :
            return (self.storyLastUpdate as NSString).tolastUpdateFormatNSDate()
        case 6 :
            return (self.replayLastUpdate as NSString).tolastUpdateFormatNSDate()
        default:
            return (self.actuLastUpdate as NSString).tolastUpdateFormatNSDate()
        }
    }
    
    func setLastUpdate(string: String, atIndex index:Int){
        switch(index){
        case 0:
            self.actuLastUpdate = string
        case 1 :
            self.varieteLastUpdate = string
        case 2 :
            self.concertLastUpdate = string
        case 3 :
            self.movieLastUpdate = string
        case 4 :
            self.starLastUpdate = string
        case 5 :
            self.storyLastUpdate = string
        case 6 :
            self.replayLastUpdate = string


        default:
            self.actuLastUpdate = string
        self._context!.save(nil)
        }
    }
    
}
