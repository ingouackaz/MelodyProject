//
//  String+Extension.swift
//  Ubinect-S
//
//  Created by Roger Ingouacka on 27/09/2014.
//  Copyright (c) 2014 Roger Ingouacka. All rights reserved.
//

import Foundation


extension String {
    
  

    

    func birthDateLetterValue() -> String{
    
        var dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var frLocale =  NSLocale(localeIdentifier: "fr_FR")
        
        dateFormatter.locale = frLocale
        var dateFormatter2: NSDateFormatter = NSDateFormatter()
        dateFormatter2.dateFormat = "dd MMM yyyy"
        dateFormatter2.locale = frLocale

       var date:NSDate = dateFormatter.dateFromString(self)!
        
        var str:String = dateFormatter2.stringFromDate(date)
        
        return str
    
    }
    
    func actuPublicationString() -> String{
        
        var dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var frLocale =  NSLocale(localeIdentifier: "fr_FR")
        
        dateFormatter.locale = frLocale
        var dateFormatter2: NSDateFormatter = NSDateFormatter()
        dateFormatter2.dateFormat = "dd/MM/yy"
        dateFormatter2.locale = frLocale
        
        var date:NSDate = dateFormatter.dateFromString(self)!
        
        var str:String = dateFormatter2.stringFromDate(date)
        
        return str
        
    }
    func ageValueString()->String{
    
        var dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var frLocale =  NSLocale(localeIdentifier: "fr_FR")
        
        dateFormatter.locale = frLocale

        var date:NSDate = dateFormatter.dateFromString(self)!
        var now :NSDate = NSDate()
        var ageComponents : NSDateComponents = NSCalendar.currentCalendar().components( NSCalendarUnit.YearCalendarUnit, fromDate: date, toDate: now, options: nil)
        var age : String
        age = NSNumber(integer: ageComponents.year).stringValue

       //age  =  NSNumber.numberWithInteger(ageComponents.year).stringValue
        
        return age
    }
    
    func lastUpdateDateValue()->NSDate {
        
        var dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var frLocale =  NSLocale(localeIdentifier: "fr_FR")
        dateFormatter.locale = frLocale
        var date:NSDate = dateFormatter.dateFromString(self)!
        return date
    }
    
    func producedFormatNSDate()->NSDate? {
        
        var dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var frLocale =  NSLocale(localeIdentifier: "fr_FR")
        dateFormatter.locale = frLocale
        if(self.isEmpty == true){
            return nil
        }
        
        //println(" self \(self)")
        if(self != "0000-00-00"){
            var date:NSDate = dateFormatter.dateFromString(self)!
            return date
        }
        else{
            return nil
        }
        
        
       
    }
    
    subscript (i: Int) -> String {
        return String(Array(self)[i])
    }
    
    subscript (r: Range<Int>) -> String {
        var start = advance(startIndex, r.startIndex)
            var end = advance(startIndex, r.endIndex)
            return substringWithRange(Range(start: start, end: end))
    }
}