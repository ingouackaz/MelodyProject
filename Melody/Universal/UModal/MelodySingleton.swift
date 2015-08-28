//
//  MuseumSingleton.swift
//  Melody.Tv
//
//  Created by Roger Ingouacka on 29/10/2014.
//  Copyright (c) 2014 Roger Ingouacka. All rights reserved.
//

import UIKit
import CoreData
import Foundation

private let _MelodySharedInstance = Melody()

enum MuseumItemType : Int {
    case Artist = 0 , Melody = 1 , Theme = 2
    
    static let allValues = [Artist, Melody, Theme]
}



let GRILLE_TV_DAY_BEFORE_LIMIT:Int = -3
let GRILLE_TV_DAY_AFTER_LIMIT:Int = 7





class Melody  {
    
    private let _appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage()

    var _context : NSManagedObjectContext
    //var _artists : NSMutableArray = NSMutableArray()
  //  var _musees : NSMutableArray = NSMutableArray()
    var _themes : NSMutableArray = NSMutableArray()
    var _artistLastUpdate : NSDate?
    var _museeLastUpdate : NSDate?
    var _themeLastUpdate : NSDate?
    
    var _helpTransition : Int = 0
    var _tag : Int = 0
    var _selectedEmission : Emission?
    var _weekDays : Array<NSDate> = []
    var _selectedEmissionDay : String = ""
    var _loadingHUD : MBProgressHUD = MBProgressHUD()
    var _mgr: Manager!
    let _cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage()
    var _isTheFirstPopUp : Bool = true
    var _videoIsFullScreen : Bool = false
    var _storyboad : UIStoryboard?
    var _pfPurchaseInProgress : Bool = false
    var _currentPageIdentifier : String = "actualites"
    
    
    var _emissionCategory :  Array<Dictionary<String, String>> = [ ["1": "Variétés"] , ["24": "Concerts"], ["33": "Films musicaux"],["2": "Melody de star"],["5": "Melody story"]]
    
    
    var _emissionIdToCategory :  Dictionary<String, String> = ["1": "Variétés" ,"24": "Concerts","33": "Films musicaux","2": "Melody de star","5": "Melody story"]

    
    var _emissionCategoryToId :  Dictionary<String, String> = [ "1": "Variétés" , "24": "Concerts", "33": "Films musicaux","2": "Melody de star", "5": "Melody story"]

  //  var _preferredLanguage: String = NSLocale.preferredLanguages()[0].stringValue
    
   var _emissionStaticDescription:Dictionary<String,String> =
    ["Melody Matin": "Le meilleur de la chanson française et internationale des années 60 à 90."   ,
     "Melody Magique": "Le meilleur de la chanson française et internationale des années 60 à 90"  ,
        "Melody Karaoké": "Le meilleur des karaokés pour chanter et s’amuser.",
     "Melody Sélection": "Le meilleur de la chanson française et internationale des années 60 à 90."  ,
        "Melody de Nuit": "Le meilleur de la chanson française et internationale des années 60 à 90."  ,
     "Melody Collector": "Le meilleur de la chanson française et internationale des années 60 à 90."  ,
     "Melody Collector 80": "Le meilleur de la chanson française et internationale des années 80."  ,
     "Melody 70": "Le meilleur des scopitones et clips des années 70, présenté par Christophe DANIEL."  ,
     "Melody 80": "Le meilleur des clips des années 80, présenté par Caroline LOEB et Christophe RENAUD."  ,
     "Melody 90": "Le meilleur des clips des années 90, présenté par Thierry CADET."  ,
     "Melody 2 tubes": "Un tube des années 60 à 90 rencontre sa reprise des années 2000 ou 2010, présenté par Thierry CADET."  ,
        "Concert de nuit": "Le meilleur des concerts des années 2000 et 2010."  ,
     "Télé-Achat": "Les meilleurs produits sélectionnés à travers le monde en collaboration avec Home Shopping Service."  ,
     "Karaoké": "Le meilleur des karaokés pour chanter et s’amuser."  ,
     "Melody Le Mag": "Le magazine sur l’actualité de la chanson et des artistes, présenté par Idil GÜNAY."  ,
     "Melodisco": "Le meilleur du disco des années 60 à 90." ,
        "Générations Melody ou Melody de ma vie":"...",
        "Melody est à vous":"Vous décidez quelle émission de variété sera diffusée sur Melody chaque samedi à 15h. Votez sur le site.",
      "MelodiscoX": "Le meilleur du disco des années 60 à 90.",
        "COncert de nuit" : "Le meilleur des concerts des années 2000 et 2010.",
        "Melody de Star":"Générations Melody ou Melody de ma vie.",
        "Melody d'hier et d'aujourd'hui":"Les derniers clips de vos artistes préférés."
    ]
    
    var _emissionStaticImages:Dictionary<String,UIImage> =
    ["Melody Matin": UIImage(named: "melody_matin")!   ,
        "Melody Magique":  UIImage(named: "melody_magique")! ,
        "Melody Karaoké":  UIImage(named: "melody_karaoke")!,
        "Melody Sélection": UIImage(named: "melody_selection")!  ,
        "Melody de Nuit":  UIImage(named: "melody_de_nuit")! ,
        "Melody Collector":  UIImage(named: "melody_collector")! ,
        "Melody Collector 80":  UIImage(named: "melody_collector_80")! ,
        "Melody 70": UIImage(named: "melody_70")!  ,
        "Melody 80":  UIImage(named: "melody_80")!  ,
        "Melody 90":  UIImage(named: "melody_90")!  ,
        "Melody 2 tubes":  UIImage(named: "melody_2_tubes")!  ,

        "Concert de nuit":  UIImage(named: "melody_concert_de_nuit")!  ,
        "Télé-Achat":  UIImage(named: "melody_tele_achat")!  ,
        "Karaoké":  UIImage(named: "melody_karaoke")!  ,
        "Melody Le Mag":  UIImage(named: "Melody_Mag")!  ,
        "Melody de Star":  UIImage(named: "melody_de_star")!  ,
        "Melodisco":  UIImage(named: "melodisco")! ,
        "Générations Melody ou Melody de ma vie":  UIImage(named: "melody_karaoke")!,
        "Melody est à vous":  UIImage(named: "melody_est_a_vous")!,
        "Melody d'hier et d'aujourd'hui": UIImage(named: "melody_hier_aujourdhui")!

    ]
    
    // melody_hier_aujourdhui

    

    var _museumUrls :  [String]?

    var _museumItemsType : [MuseumItemType]?
    var _videoClublastUpdates  : Array<String> = Array<String>()
    
    var _msmCoreData : MelodyCoreData
    var _seeAlsoEmissions : Array<Emission> = []
    

    var _emissionsList : Array<[Emission]> = Array<[Emission]>(count: 7, repeatedValue:Array<Emission>())


    var _userToken : String = ""
    
    
    var _user : User?
    
    class var sharedInstance : Melody {
        return _MelodySharedInstance
    }
    
    init(){
        
        //
        self._context = self._appDel.managedObjectContext!
        
        
        var entityMuseum : NSEntityDescription = NSEntityDescription.entityForName("MelodyCoreData", inManagedObjectContext: self._context) as NSEntityDescription!
        
        var msm : MelodyCoreData = MelodyCoreData(entity: entityMuseum, insertIntoManagedObjectContext: self._context)
        _msmCoreData = msm
        
        self.loadCoreDataBase()

    }

    func calculateWeekDays(){
        let today = NSDate()
        
        GRILLE_TV_DAY_BEFORE_LIMIT
        for var i = GRILLE_TV_DAY_BEFORE_LIMIT; i < GRILLE_TV_DAY_AFTER_LIMIT ; i++
        {
            var day =  today.addDay(i)
            
            
            _weekDays.append(day)
        }
        
        
    }
    
    func setLanguage(){
    
    }
    
    func displayLoadingView(view:UIView, text:String){
        _loadingHUD = MBProgressHUD.showHUDAddedTo(view, animated: true)
        
    //_loadingHUD.delegate = vc
        
        _loadingHUD.detailsLabelText = text
        _loadingHUD.show(true)
    }
    
    func hideLoadingView(){
        _loadingHUD.hide(false)
        
    }
    

    func clearTheme(){
        _themes.removeAllObjects()
    }
    
   func createNewUserWithName(name:String, address:String, birthdate:String, city:String, country:String, email:String, gender:String, phone:String, subscribed:String, surname:String,token:String){
        
        self.clearUser()
    
        // Creation du nouvelle utilisateur
        var entityUser : NSEntityDescription = NSEntityDescription.entityForName("User", inManagedObjectContext: self._context) as NSEntityDescription!

    var newUser = User(entity: entityUser, insertIntoManagedObjectContext: self._context, name:name, address:address, birthdate:birthdate, city:city, country:country, email:email, gender:gender , phone: phone, subscribed:subscribed, surname:surname, token:token)

        self._user = newUser
        _context.save(nil)
    
    println("New User \(self._user)")
    
    }
    

    
    func loadCoreDataBase() {
        self.loadMelodyCoreData()
        self.loadUserCoreData()

    }
    
    func loadUserCoreData(){
        var request = NSFetchRequest(entityName: "User")
        request.returnsObjectsAsFaults = false
        var result:NSArray = _context.executeFetchRequest(request, error: nil)!
        
        if(result.count > 0)
        {
            
           // println( result)
            
            // on récupère l'entite User
            var user = result[0] as! User
            self._user = user
            
            println("User loaded [\(  self._user?.token)]")
            
            _userToken = self._user!.token
        }
    }
    func loadMelodyCoreData(){

        
        var request = NSFetchRequest(entityName: "MelodyCoreData")
        request.returnsObjectsAsFaults = false
        var result:NSArray = _context.executeFetchRequest(request, error: nil)!

        if(result.count > 0)
        {
            var msm : MelodyCoreData = result[0] as! MelodyCoreData
            _msmCoreData = msm
        }
        
    }
    
    func clearMuseumsItemWithType(type:Int){
        
        var request = NSFetchRequest(entityName: "MelodyItem")
        request.returnsObjectsAsFaults = false
        var predicate : NSPredicate = NSPredicate(format:"%K == %d","type",type)
        request.predicate = predicate
        var results:NSArray = _context.executeFetchRequest(request, error: nil)!
        
        // var res:NSManagedObject
        
        for (index, res) in enumerate(results)
        {
            _context.deleteObject(res as! NSManagedObject)
        }
        _context.save(nil)
    }
    
    func clearUser(){
        var request = NSFetchRequest(entityName: "User")
        request.returnsObjectsAsFaults = false
        var results:NSArray = _context.executeFetchRequest(request, error: nil)!
        
        // var res:NSManagedObject
        
        for (index, res) in enumerate(results)
        {
            _context.deleteObject(res as! NSManagedObject)
        }
        _context.save(nil)
        _userToken = ""
        self._user = nil
        self.clearLastUpdates()
    }
    
    func clearArtists(){
        var request = NSFetchRequest(entityName: "MelodyItem")
        request.returnsObjectsAsFaults = false
        var predicate : NSPredicate = NSPredicate(format:"%K == %d","type",0)
        request.predicate = predicate
        var results:NSArray = _context.executeFetchRequest(request, error: nil)!
        
        // var res:NSManagedObject
        
        for (index, res) in enumerate(results)
        {            
            _context.deleteObject(res as! NSManagedObject)
        }
        _context.save(nil)
    }
    
    func clearMusee(){
    
        var request = NSFetchRequest(entityName: "MelodyItem")
        request.returnsObjectsAsFaults = false
        var predicate : NSPredicate = NSPredicate(format:"%K == %d","type",1)
        request.predicate = predicate
        var results:NSArray = _context.executeFetchRequest(request, error: nil)!
        // var res:NSManagedObject
        
        for (index, res) in enumerate(results)
        {
            _context.deleteObject(res as! NSManagedObject)
        }
        _context.save(nil)
    }
    
    func clearLastUpdates(){
        
        self._msmCoreData.clearLastUpdate()

        _context.save(nil)
    }
    
    func isUserConnected() -> Bool {
        if (self._user == nil)
        {
            return false
        }
        else{
            _userToken = self._user!.token
            return true
        }
    
    }


    func getLastWeekDate() -> String {
        let lastWeekDate = NSCalendar.currentCalendar().dateByAddingUnit(.WeekOfYearCalendarUnit, value: -1, toDate: NSDate(), options: nil)!
        let styler = NSDateFormatter()
        styler.dateFormat = "yyyy_MM_dd"
        let lastWeekDateString = styler.stringFromDate(lastWeekDate)
    
    return lastWeekDateString
    }
    
    
    func autoLoginAboMode(){

        
        var email = "applis@melody.tv"
        var pass =  "applismelody"
        
        
        
        request(.GET, kMLDLoginRequest + email + "/" + pass )
            .responseSwiftyJSON{(request, response, json, error) in
                if (error?.code > -2000)
                {
                    
                    //println("No Internet connection")
                    
                }
                else{
                    if (json["status"].boolValue == true){
                        // println("JSON \(json)")
                        
                        //  println(self.cookies.cookiesForURL(NSURL(string: "http://www.Melody-hd.com/json/users/authenticate/\(self.emailTextFIeld.text)/\(self.passTextField.text)")!))
                        
                        println("Connexion succeed")
                        
                        var entityUser : NSEntityDescription = NSEntityDescription.entityForName("User", inManagedObjectContext: self._context)!
                        
                        
                        self.createNewUserWithName(json["results"]["User"]["name"].stringValue,
                            address: json["results"]["User"]["address"].stringValue,
                            birthdate: json["results"]["User"]["birthdate"].stringValue,
                            city: json["results"]["User"]["city"].stringValue,
                            country: json["results"]["User"]["country"].stringValue,
                            email: json["results"]["User"]["email"].stringValue,
                            gender: json["results"]["User"]["gender"].stringValue,
                            phone: json["results"]["User"]["phone"].stringValue,
                            subscribed: json["results"]["User"]["subscribed"].stringValue,
                            surname: json["results"]["User"]["surname"].stringValue,
                            token:json["results"]["User"]["token"].stringValue)
                        
                        
                        //self._melody.clearLastUpdates()
                        
                        self._context.save(nil)
                        
                        
                        NSNotificationCenter.defaultCenter().postNotificationName("userConnected", object: nil, userInfo:nil)
                        
                        
                    }else{
                        println("Connexion failed")
                    }
                    
                }
            }
    }
    
    
    func lastUpdateAtIndexExist(index:Int) -> Bool {
        /*
        self._lastUpdates = [self._msmCoreData!.artistLastUpdate, self._msmCoreData!.museeLastUpdate, self._msmCoreData!.themeLastUpdate]

        println("The index [\(index)] \(self._lastUpdates![index])")
        if (self._lastUpdates![index] == nil){
            return false
        }
        else
        {
            return true
        }*/
        
        return true
    }
    
    
}
