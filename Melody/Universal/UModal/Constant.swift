//
//  Constant.swift
//  Melody
//
//  Created by Ingouackaz on 2015-08-17.
//
//

import UIKit

// Type values
let kMLDInAppIdentifier       = "abomensuelmuseum";


var kSMSEmailInAppPurchase = "applis@themuseumchannel.tv"
var kSMSPasswordInAppPurchase =  "rogerroger"

let kPAPActivityTypeDislike    = "dislike";

let kPAPActivityTypeFollow     = "follow";
let kPAPActivityTypeComment    = "comment";
let kPAPActivityTypeJoined     = "joined";

// image per default

let kMLDMuseeImageNamePerDefault      = "musee2";

let kMLDNavigationBarImageName      = "bandeau-noir3";



// Url images

let kMLDAboUrlImage      = NSURL(string: "kMLDAboImageUrl");
let kMLDTutosUrlImage   = "http://www.melody.tv/images/stories/showcase/applis/\(NSLocale.preferredLanguages()[0])/"
let kMLDSlideshowUrlImage   = "http://www.melody.tv/images/stories/showcase/applis/"


// Url json

let kMLDStreamUrl = kMLDBaseUrl + "livetv/getallstream/iphone?lang=fre&token="

let kMLDALaUneUrlJson = "http://www.museum-hd.com/json-new/videos/voiraussimob?lang=\(NSLocale.preferredLanguages()[0])&token="
let kMLDExpoUrlJson = "http://www.museum-hd.com/json-new/get/exhibition/?lang=\(NSLocale.preferredLanguages()[0])&platform=tablet_ios_small&token="

var kMLDGrilleTVUrl:String = kMLDBaseUrl + "grids/view/"
var kMLDLastActusUrl:String = kMLDBaseUrl + "actualites/appligetall/12"
var kMLDSeeAlsoUrl:String =  kMLDBaseUrl  + "videos/voiraussimob"



// http://www.museum-hd.com/json-new/get/exhibition/?lang=\(NSLocale.preferredLanguages()[0])&platform=tablet_ios_small&token=
// Url video

let kMLDBandeAnnonceEnUrlVideo = "http://www.museum-hd.com/museum-hd/clips/M3G_TEASER_tmc_live_fr.mp4"
let kMLDBandeAnnonceFrUrlVideo = "http://www.museum-hd.com/museum-hd/clips/M3G_TEASER_tmc_live_fr.mp4"


// Request


let kMLDBaseUrl = "http://www.melody.tv/json-new/"
let kMLDActualitesRequest = kMLDBaseUrl + "actualites/appligetall/36?token="
let kMLDLoginRequest = kMLDBaseUrl + "users/authenticate/"
let kMLDEmissionRequest = kMLDBaseUrl + "videos/find_by_emission/"

let kMLDVarietesRequest = kMLDBaseUrl + "videos/find_by_emission/1/100000?lang=fre&token="

let kMLDConcertsRequest = kMLDBaseUrl + "videos/find_by_emission/24/100000?lang=fre&token="
let kMLDMoviesRequest = kMLDBaseUrl + "videos/find_by_emission/33/100000?lang=fre&token="
let kMLDStarsRequest = kMLDBaseUrl + "videos/find_by_emission/2/100000?lang=fre&token="
let kMLDStorysRequest = kMLDBaseUrl + "videos/find_by_emission/5/100000?lang=fre&token="
let kMLDReplaysRequest = kMLDBaseUrl + "videos/get_replay/"





let kMLDMenuVarieteIdentifier = "Variétés"
let kMLDMenuConcertsIdentifier = "Concerts"
let kMLDMenuMoviesIdentifier = "Films musicaux"
let kMLDMenuStarsIdentifier = "Melody de star"
let kMLDMenuStorysIdentifier = "Melody story"
let kMLDMenuReplaysIdentifier = "Replay"
let kMLDMenuActualitesIdentifier = "Actualités"

