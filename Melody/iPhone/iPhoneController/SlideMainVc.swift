//
//  SlideMainVc.swift
//  DareForgetS
//
//  Created by Roger Ingouacka on 26/10/2014.
//  Copyright (c) 2014 Roger Ingouacka. All rights reserved.
//


class SlideMainVc: AMSlideMenuMainViewController {
    var _melody : Melody = Melody.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"userConnectedNofication:", name: "userConnected", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"userDisconnectedNofication:", name: "userDisconnected", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"reachabilityChanged:", name:kReachabilityChangedNotification, object: nil)
        
        self.startGetSeeAlsoRequest()
        
        
        var defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if(defaults.objectForKey("firstUse") == nil){
            
            self.performSegueWithIdentifier("goToTuto", sender: nil)
            defaults.setObject("ok", forKey: "firstUse")
            defaults.synchronize()
        }
    }
    
    func startGetSeeAlsoRequest(){
        
        request(.GET,  kMLDSeeAlsoUrl + "?token=" + _melody._userToken)
            .responseSwiftyJSON{(request, response, json, error) in
                if (error?.code > -2000)
                {
                    
                    //println("No Internet connection")
                }
                else{
                    // Ajoute un print avant sinon playgr9und renvoie 0 -> bug
                    println(" SEE ALSO CONTENT JSON \(json)")
                    self.getSeeAlsoEmissionsItems(json)
                    
                }
        }
        
        
    }
    
    func getSeeAlsoEmissionsItems(json: JSON){
        var array = json["results"]
        
        println("See also array \(array)")
        
        _melody._seeAlsoEmissions.removeAll(keepCapacity: false)
        
        
        for (index: String, subJson: JSON) in array {
            var artists : Array<JSON> = subJson["Video"]["Artist"].arrayValue
            //Do something you want
            
            var emissionid : String =  subJson["Video"]["emission_id"].stringValue
            
            var nameCat : String =  Array((_melody._emissionCategory[0] as Dictionary).values)[0]
            
            
            
            // joce api
            var programme : Emission = Emission(emissionDescription: subJson["Video"]["description"].stringValue,
                id: subJson["Video"]["id"].stringValue,
                emissionCategory:_melody._emissionIdToCategory[emissionid]!,
                end: "",
                start: "",
                produced:subJson["Video"]["produced"].stringValue.producedFormatNSDate(),
                formated_duration: subJson["Video"]["duration"].stringValue,
                url_Video: subJson["Video"]["url_mobile_teaser"].stringValue,
                thumb_image: subJson["Video"]["small_thumb_url"].stringValue,
                date: NSDate(),
                emissionName:subJson["Video"]["title"].stringValue,
                artists:artists,
                diffusionDate:NSDate(),
                relatedEmissions:subJson["Video"]["related_video"].arrayValue,
                tag:0,
                 publicationMobile:subJson["Video"]["publication_mobile"].boolValue
            )
    
            
            
            
            
            if (_melody.isUserConnected() == true){
                if let url_mobile = subJson["Video"]["url_mobile"].string {
                    programme.url_Video = url_mobile
                }
                
            }
            _melody._seeAlsoEmissions.append(programme)
        }
    }

    func userConnectedNofication(notification : NSNotification){
        
        
        println("User vient de se connecter")
        // lancer une requête qui vérifie chaque jour si l'utilisateur est toujours abonné
        
        if (notification.name == "userConnected"){
          //  self.selectedIndex = 0
            self._melody.clearLastUpdates()
            self.setAboMode()
            _melody._msmCoreData.clearLastUpdate()

        }
        
    }
    
    func userDisconnectedNofication(notification : NSNotification){
        if (notification.name == "userDisconnected"){
         //   self.selectedIndex = 0
            self._melody.clearLastUpdates()
            self.setUnAboMode()
            _melody._msmCoreData.clearLastUpdate()

        }
    }
    
    func setAboMode(){
     //
        self.startGetSeeAlsoRequest()

    }
    
    func setUnAboMode(){
    //
        
        //        self.viewControllers?.removeLast()
        
    }
    
    
    func reachabilityChanged(notification : NSNotification){
        
        var reach : Reachability = notification.object as! Reachability
        var status : NetworkStatus = reach.currentReachabilityStatus()
        if (status != NetworkStatus.ReachableViaWiFi && status != NetworkStatus.ReachableViaWWAN){
            
            println("NO INTERNET CONNECTION")
            
            println("Internet connection")
            
            
            var vc = _melody._storyboad!.instantiateViewControllerWithIdentifier("noInternet") as! UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
            
        }else{
            
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
    }
    
    
    override func segueIdentifierForIndexPathInLeftMenu(indexPath: NSIndexPath!) -> String! {
        
        self._melody._tag = indexPath.row
//        direct
        
        switch (indexPath.section)
        {
        case 0:
            if(indexPath.row == 0){
                return "actualites"
            }
            else if (indexPath.row  == 1){
                return "direct"
            }
            else{
                return "grilleTV"
            }
            
        case 1:
            if(indexPath.row == 0){
                return "varietes"
            } else if (indexPath.row  == 1){
                return "concerts"
            }
            else if (indexPath.row  == 2){
                return "films"
            }
            else if (indexPath.row  == 3){
                return "stars"
            }
            else if (indexPath.row  == 4){
                return "storys"
            }
            case 2:
                if(indexPath.row == 0){
                    return "replays"
                }
                else if (indexPath.row  == 1){
                    return "compte"
            }
        default:
            return "actualites"

            // do nothing
        }

        return "actualites"
    }
    
    override func segueIdentifierForIndexPathInRightMenu(indexPath: NSIndexPath!) -> String! {
        return ""
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    override func leftMenuWidth() -> CGFloat {
        return 200
    }


    override func configureLeftMenuButton(button: UIButton) {
       // button
        var frame : CGRect = button.frame;

        frame = CGRectMake(0, 0, 25, 13)
        button.frame = frame
        button.backgroundColor = UIColor.clearColor()
        
       // [button setImage:[UIImage imageNamed:@"simpleMenuButton"] forState:UIControlStateNormal];
        
        
       button.setImage(UIImage(named: "liste"), forState: UIControlState.Normal)
        button.tintColor = UIColor.whiteColor()

    }
    
    override func configureSlideLayer(layer: CALayer!) {
        
        layer.shadowColor = UIColor.blackColor().CGColor;
        layer.shadowOpacity = 1;
        layer.shadowOffset = CGSizeMake(0, 0);
        layer.shadowRadius = 5;
        layer.masksToBounds = false;
        
        layer.shadowPath = UIBezierPath(rect: self.view.layer.bounds).CGPath
    }
    
    override func primaryMenu() -> AMPrimaryMenu {
        return AMPrimaryMenuLeft
    }
    
    override func deepnessForLeftMenu() -> Bool {
        return true
    }
}
