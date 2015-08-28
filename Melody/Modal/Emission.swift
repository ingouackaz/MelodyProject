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
   
    
    
    
    init( id:String, emissionCategory:String, end:String, start:String, formated_duration:String, date:NSDate,  emissionName:String, artists:Array<JSON>, diffusionDate : NSDate, relatedEmissions: Array<JSON>?,tag : Int ) {
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
    
    
    init( emissionDescription:String, id:String, emissionCategory:String, end:String, start:String, produced:NSDate?, formated_duration:String, url_Video:String, thumb_image:String, date:NSDate, emissionName:String,artists:Array<JSON>, diffusionDate : NSDate, relatedEmissions: Array<JSON>?, tag : Int )  {
        
        
        self.emissionDescription = emissionDescription
        self.diffusion_date = diffusionDate
        self.tag = tag

        
        
        self.relatedEmissions = Array<Emission>()

        var count = Int(emissionDescription.utf16Count)
        var limite = 12
        if(count >  18 ){
            var emissionDescriptionNSString = emissionDescription as NSString
            emissionDescriptionNSString = emissionDescriptionNSString.substringFromIndex(18)
            
            self.emissionDescription = String(emissionDescriptionNSString)
        }

        
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
        if(start.utf16Count == 8){
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
        
        
        
        if (relatedEmissions != nil ){
            for subJson in relatedEmissions! {
                
                if let video = subJson["Video"].dictionaryObject{
                    
                    var programme : Emission = Emission(emissionDescription: subJson["Video"]["description_mobile"].stringValue,
                        id: subJson["id"].stringValue,
                        emissionCategory: subJson["Emission"]["name"].stringValue,
                        end: subJson["end"].stringValue,
                        start: subJson["start"].stringValue,
                        produced: subJson["Video"]["Rush"]["produced"].stringValue.producedFormatNSDate(),
                        formated_duration: subJson["formated_duration"].stringValue,
                        url_Video: subJson["Video"]["Rush"]["url_web_teaser"].stringValue,
                        thumb_image: subJson["Video"]["thumb_url"].stringValue,
                        date: date,
                        emissionName:subJson["Video"]["title"].stringValue,
                        artists:artists,
                        diffusionDate:NSDate(),
                        relatedEmissions:subJson["Video"]["related_video"].arrayValue,
                        tag:0
                    )
                    
                    
                    if (_melody.isUserConnected()){
                        if let url_mobile = subJson["Video"]["Rush"]["url_mobile"].string {
                            programme.url_Video = url_mobile
                        }
                    }
                    
                    self.relatedEmissions.append(programme)
                }
            }
        }
        
    }
}
