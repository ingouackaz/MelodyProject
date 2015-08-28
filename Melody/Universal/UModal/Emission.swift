//
//  Emission.swift
//  Melody
//
//  Created by Roger Ingouacka on 08/12/14.
//
//

import UIKit

class Emission: NSObject {
    
    var _melody : Melody = Melody.sharedInstance

    
    var  emissionDescription : String
    var id : String
    var emissionCategoryName : String
    var emissionName : String

    var end : String
    var start : String
    var produced : NSDate?

    var formated_duration : String
    var publication : String?

    var url_Video : String
    var url_thumb_image : String
    var artists : Array<JSON>
    var day : String
    var date : NSDate
    var thumb_image : UIImage?
    
    var diffusion_date : NSDate
    
    var relatedEmissions : Array<Emission>
    var tag : Int
    
    var _yesterday = NSDate().addDay(-1)
    var _tomorrow = NSDate().addDay(1)
   
    var publicationMobile : Bool
    
    
    init( id:String, emissionCategory:String, end:String, start:String, formated_duration:String, date:NSDate,  emissionName:String, artists:Array<JSON>, diffusionDate : NSDate, relatedEmissions: Array<JSON>?,tag : Int , publicationMobile:Bool) {
        self.emissionDescription = ""
        self.id = id
        self.emissionCategoryName = emissionCategory
        self.end = end
        self.diffusion_date = diffusionDate
        self.relatedEmissions =  Array<Emission>()
        self.tag = tag
        // self.start = start
        self.url_Video = "http://www.melody.tv/melody/clips//WEB_TEASER_1065074.mp4"
        self.url_thumb_image = ""
        self.artists = artists
        self.emissionName = emissionName
        self.date = date
        self.publicationMobile = publicationMobile
        var myNSString = start as NSString
        myNSString.substringWithRange(NSRange(location: 5, length: 2))
        myNSString =  myNSString.substringToIndex(5)
        self.start =  String(myNSString)
        self.start = self.start.stringByReplacingOccurrencesOfString(":", withString: "H", options:  NSStringCompareOptions.LiteralSearch, range: nil)
        
        //println("Start \(self.start)")
       
        self.formated_duration = formated_duration

        if (date.isSameDayAsDate(NSDate())){
             self.day =  "Aujourd'hui"
        }
        else if(date.isSameDayAsDate(_tomorrow)){
            self.day =  "Demain"
            
        }
        else if(date.isSameDayAsDate(_yesterday)){
             self.day =  "Hier"
            
        }
        else{
             self.day =  date.toGrilleTvDisplayFormatString()
        }
    }
    
    
    init( emissionDescription:String, id:String, emissionCategory:String, end:String, start:String, produced:NSDate?, formated_duration:String, url_Video:String, thumb_image:String, date:NSDate, emissionName:String,artists:Array<JSON>, diffusionDate : NSDate, relatedEmissions: Array<JSON>?, tag : Int  , publicationMobile:Bool)  {
        
        
        self.emissionDescription = emissionDescription
        self.diffusion_date = diffusionDate
        self.tag = tag

        
        
        self.relatedEmissions = Array<Emission>()

        var limite = 12


        
        self.publicationMobile = publicationMobile

        self.id = id
        self.produced = produced
        self.emissionCategoryName = emissionCategory
        self.end = end
        self.url_Video = url_Video
        self.url_thumb_image = thumb_image
        self.artists = artists
        self.day = ""
        self.emissionName = emissionName
        self.start = ""
        // self.start = start
        self.date = date
        
        
        if(count(start) == 8){
            var myNSString = start as NSString
            myNSString.substringWithRange(NSRange(location: 5, length: 2))
            myNSString =  myNSString.substringToIndex(5)
            self.start =  String(myNSString)
            self.start = self.start.stringByReplacingOccurrencesOfString(":", withString: "H", options:  NSStringCompareOptions.LiteralSearch, range: nil)
        }

        
        
        self.formated_duration = formated_duration
        
        self.formated_duration = formated_duration
        
        if (date.isSameDayAsDate(NSDate())){
            self.day =  "Aujourd'hui"
        }
        else if(date.isSameDayAsDate(_tomorrow)){
            self.day =  "Demain"
            
        }
        else if(date.isSameDayAsDate(_yesterday)){
            self.day =  "Hier"
            
        }
        else{
            self.day =  date.toGrilleTvDisplayFormatString()
        }
        
        
        
    }
}
