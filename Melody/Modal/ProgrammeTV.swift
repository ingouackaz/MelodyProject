//
//  ProgrammeTV.swift
//  Melody
//
//  Created by Roger Ingouacka on 05/12/14.
//
//

import UIKit

class ProgrammeTV: NSObject {
 
    var detail : String
    var id : String
    var name : String
    var end : String
    var start : String
    var formated_duration : String

    init( detail:String, id:String, name:String, end:String, start:String, formated_duration:String) {
        self.detail = detail
        self.id = id
        self.name = name
        self.end = end
       // self.start = start
        

        var myNSString = start as NSString
        myNSString.substringWithRange(NSRange(location: 5, length: 2))
       myNSString =  myNSString.substringToIndex(5)
        self.start =  String(myNSString)
        self.start = self.start.stringByReplacingOccurrencesOfString(":", withString: "H", options:  NSStringCompareOptions.LiteralSearch, range: nil)

       // println("Start \(self.start)")
        
        self.formated_duration = formated_duration
    }
    
}
