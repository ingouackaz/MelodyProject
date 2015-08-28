//
//  Artist.swift
//  Melody.Tv
//
//  Created by Roger Ingouacka on 29/10/2014.
//  Copyright (c) 2014 Roger Ingouacka. All rights reserved.
//

import UIKit

class Artist: NSObject {
     var name:String
     var urlVideo:String
     var thumbImage:NSData
    
    init( name:String, urlVideo:String, thumbImageURL:String) {
        self.name = name
        self.urlVideo = urlVideo
        self.thumbImage =    NSData(contentsOfURL: NSURL(string: thumbImageURL)!)!
    }
}
