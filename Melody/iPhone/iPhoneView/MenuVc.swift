//
//  MenuVc.swift
//  DareForgetS
//
//  Created by Roger Ingouacka on 26/10/2014.
//  Copyright (c) 2014 Roger Ingouacka. All rights reserved.
//

import UIKit

class MenuVc: AMSlideMenuLeftTableViewController {

    var _transitionsNavigationController : UINavigationController?
    var _melody : Melody = Melody.sharedInstance
    var _currentIndexPath : NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    var _compteVcIdentifiers : Array<String> = ["CompteVC4","CompteVC5","CompteVC6","CompteVC6+"]
    var _directVcIdentifiers : Array<String> = ["DirectVC4","DirectVC5","DirectVC6","DirectVC6+"]

    var _indexIdentifier : Int = 0
    
    @IBOutlet var accountLabel: UILabel!
    @IBOutlet var accountImageView: UIImageView!

    
    required init(coder aDecoder: NSCoder) {

        
        super.init(coder: aDecoder)
        

    }
    
    func observeNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"userConnectedNofication:", name: "userConnected", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"userDisconnectedNofication:", name: "userDisconnectedNofication", object: nil)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
        
        self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0), animated: false, scrollPosition: UITableViewScrollPosition.None)


        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"reachabilityChanged:", name:kReachabilityChangedNotification, object: nil)
        
        self.startGetSeeAlsoRequest()
 
        self.multiViewCheck()
    }


    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
//    -(NSString *)segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath;

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.clearColor()
        //make the background color light blue
        header.textLabel.textColor = UIColor.whiteColor() //make the text white
        

     //   header.textLabel.font = UIFont(name: "Helvetica-Bold", size: 15)
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (_melody._user != nil){
            accountImageView.image =  UIImage(named: "compte-co-off")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
                accountLabel.text = "Connecté"
        }
        else{
            accountImageView.image =  UIImage(named: "compte-off")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)

            accountLabel.text = "Compte"
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath == _currentIndexPath){
            SlideNavigationController.sharedInstance().closeMenuWithCompletion(nil)
            return
        }
        
        println("storyboard name \(_melody._storyboad!)")
        
        var vc : UIViewController

        if(indexPath.section == 0 ){
            switch indexPath.row {
            case 1:
                vc = _melody._storyboad!.instantiateViewControllerWithIdentifier(_directVcIdentifiers[_indexIdentifier]) as! UIViewController
                SlideNavigationController.sharedInstance().popToRootAndSwitchToViewController(vc, withCompletion: nil)

            case 2:
                vc = _melody._storyboad!.instantiateViewControllerWithIdentifier("GrilleTvVC") as! UIViewController
                SlideNavigationController.sharedInstance().popToRootAndSwitchToViewController(vc, withCompletion: nil)

            default:
                  vc = _melody._storyboad!.instantiateViewControllerWithIdentifier("ActuVC") as! UIViewController
                  vc.title = kMLDMenuActualitesIdentifier

                  SlideNavigationController.sharedInstance().popToRootAndSwitchToViewController(vc, withCompletion: nil)
                 // SlideNavigationController.sharedInstance().pushViewController(vc, animated: false)
                }

            }
            
        else if(indexPath.section == 1 ){
            vc = _melody._storyboad!.instantiateViewControllerWithIdentifier("TemplateIphone") as! UIViewController

            switch indexPath.row {

                
            case 1:
                vc.title = kMLDMenuConcertsIdentifier
            case 2:
                vc.title = kMLDMenuMoviesIdentifier
            case 3:
                vc.title = kMLDMenuStarsIdentifier

            case 4:
                vc.title = kMLDMenuStorysIdentifier

            default:
                vc.title = kMLDMenuVarieteIdentifier                
            }
            
            SlideNavigationController.sharedInstance().popToRootAndSwitchToViewController(vc, withCompletion: nil)
            

            }
        else {
            switch indexPath.row {
  
               
            case 1:
                // Compte multi view
                vc = _melody._storyboad!.instantiateViewControllerWithIdentifier("compte") as! UIViewController
            default:
                vc = _melody._storyboad!.instantiateViewControllerWithIdentifier("TemplateIphone") as! UIViewController
                vc.title = kMLDMenuReplaysIdentifier

                }
            SlideNavigationController.sharedInstance().popToRootAndSwitchToViewController(vc, withCompletion: nil)

            }
        
            _currentIndexPath = indexPath
        }
    
    
    func multiViewCheck(){
    
        var storyboad : UIStoryboard = UIStoryboard(name: "iPhoneAll", bundle: nil)
        
        var iOSDeviceScreenSize : CGSize = UIScreen.mainScreen().bounds.size
        if (iOSDeviceScreenSize.height == 480){
            _indexIdentifier = 0
        println("iPhone 4 Storyboard loaded")
        }
        else if (iOSDeviceScreenSize.height == 568){
            
            _indexIdentifier = 1
        println("iPhone 5 Storyboard loaded")
        }
        else if (iOSDeviceScreenSize.height == 667){
        println("iPhone 6 Storyboard loaded")
            
            _indexIdentifier = 2
        }
        else if (iOSDeviceScreenSize.height == 736){
        println("iPhone 6 + Storyboard loaded")
            _indexIdentifier = 3

        }
        else{
            _indexIdentifier = 1

        }
        
        

    }
    
    

    func startGetSeeAlsoRequest(){
        
        
        println("Token \(_melody._userToken)")
        
        
        request(.GET, kMLDSeeAlsoUrl + "?token=" + _melody._userToken)
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
        
        if (notification.name == "userDisconnectedNofication"){
            //   self.selectedIndex = 0
            self._melody.clearLastUpdates()
            self.setUnAboMode()
            self._melody.clearUser()            
        }
    }
    
    func setAboMode(){
        //
        self.startGetSeeAlsoRequest()
        accountImageView.image =  UIImage(named: "compte-co-off")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        accountLabel.text = "Connecté"
        self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.None)
    }
    
    func setUnAboMode(){
        
        if (accountImageView != nil){
            accountImageView.image =  UIImage(named: "compte-off")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            accountLabel.text = "Compte"
            self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.None)
        }

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
    
}
