//
//  TemplateIphoeTVC.swift
//  Melody
//
//  Created by Roger Ingouacka on 15/01/2015.
//
//

import UIKit

class TemplateIphoneTVC: UITableViewController, SlideNavigationControllerDelegate {

    var _melody : Melody = Melody.sharedInstance
    var _getEmissionRequestUrl : NSURL?
    var currentLastUpdateIndex : Int = 0
    var _currentCategorySelected : String = "Variétés"
    var _templateId : Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadInformation()

       // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
       // NSNotificationCenter.defaultCenter()
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"userConnectedNofication:", name: "userConnected", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"userDisconnectedNofication:", name: "userDisconnectedNofication", object: nil)
      var defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if(defaults.objectForKey("firstUse") == nil){
            println("1er lancement")
            self.performSegueWithIdentifier("goToTuto", sender: nil)
            defaults.setObject("ok", forKey: "firstUse")
            defaults.synchronize()
        }
        
    }

    
    
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return true
    }
    
    func slideNavigationControllerShouldDisplayRightMenu() -> Bool {
        return false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        _melody._isTheFirstPopUp = true

        if(self.title == kMLDMenuActualitesIdentifier){
            self._melody.hideLoadingView()
        }
        
    }
    func loadInformation(){
        // self.deselectAllButton()


        println("index id template \(self.title!)")
        
        
        
        if(self.title! == kMLDMenuVarieteIdentifier){
            _templateId = 1

            self._currentCategorySelected = "Variétés"

            self._getEmissionRequestUrl = NSURL(string: kMLDVarietesRequest +  _melody._userToken )
            self.startGetEmissionsRequest(false)
            
        }else if(self.title == kMLDMenuConcertsIdentifier){
            _templateId = 2

            self._currentCategorySelected = "Concerts"

            
            self._getEmissionRequestUrl = NSURL(string:kMLDConcertsRequest +  _melody._userToken )
            self.startGetEmissionsRequest(false)
            
        }else if(self.title == kMLDMenuMoviesIdentifier){
            _templateId = 3

            self._currentCategorySelected = "Films musicaux"

            
            self._getEmissionRequestUrl = NSURL(string: kMLDMoviesRequest +  _melody._userToken )
            self.startGetEmissionsRequest(false)
            
        }else if(self.title == kMLDMenuStarsIdentifier){
            _templateId = 4

            self._currentCategorySelected = "Melody de star"

            self._getEmissionRequestUrl = NSURL(string: kMLDStarsRequest +  _melody._userToken )
            self.startGetEmissionsRequest(false)
            
        }else if(self.title == kMLDMenuStorysIdentifier){
            _templateId = 5

            self._currentCategorySelected = "Melody story"

            self._getEmissionRequestUrl = NSURL(string: kMLDStorysRequest +  _melody._userToken)
            self.startGetEmissionsRequest(false)
            
        }
        else if(self.title == kMLDMenuReplaysIdentifier){
            _templateId = 6

            self._getEmissionRequestUrl = NSURL(string:kMLDReplaysRequest + NSDate().lastSaturdayDate() + "/?lang=eng&token=" +  _melody._userToken )
            self.startGetEmissionsRequest(false)
            
        }
        else if (self.title == kMLDMenuActualitesIdentifier){
            _templateId = 0

            var urlString : String = kMLDActualitesRequest +  _melody._userToken

            self._getEmissionRequestUrl = NSURL(string:urlString)
            self.startGetEmissionsRequest(true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        //println("Emissin count \(_melody._emissions.count)")
        return _melody._emissionsList[_templateId].count

//        return _emissions.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var emission : Emission = _melody._emissionsList[_templateId][indexPath.row]

        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ActuTVCell

        cell.titleLabel.text = emission.emissionName
        if(_templateId == 0){
            cell.diffusionDateLabel.text =  emission.publication!.actuPublicationString()
        }else{
            cell.diffusionDateLabel.text = emission.emissionCategoryName
        
        }
        
        var urlString = emission.url_thumb_image
        cell.thumbImage.layer.masksToBounds = true
        cell.thumbImage.layer.cornerRadius = 5
        cell.thumbImage.layer.borderColor = UIColor.blackColor().CGColor
        cell.thumbImage.layer.borderWidth = 1
        if(  emission.thumb_image == nil ) {
            // If the image does not exist, we need to download it
            var imgURL: NSURL = NSURL(string: urlString)!
            
            // Download an NSData representation of the image at the URL
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    var image = UIImage(data: data)
                    
                    // Store the image in to our cache
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        
                        if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                            //cellToUpdate.imageView?.image = image
                            (cellToUpdate as! ActuTVCell).thumbImage.image = image
                            emission.thumb_image = image
                            //self._museum._context.save(nil)
                            
                        }
                    })
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
            
        }
        else {
            cell.thumbImage.image = emission.thumb_image
            
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        _melody._selectedEmission = _melody._emissionsList[_templateId][indexPath.row]

        if(self.title == kMLDMenuActualitesIdentifier){
            self.performSegueWithIdentifier("actuView", sender: nil)
        }
        else{
            var vc : VideoTVC
            vc = _melody._storyboad!.instantiateViewControllerWithIdentifier("VideoTVC") as! VideoTVC

            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func startGetEmissionsRequest(isActu:Bool){
        
        println("Date \(_melody._msmCoreData.getLastUpdateDate(atIndex:_templateId))")
        
        if( !_melody._msmCoreData.getLastUpdateDate(atIndex:_templateId).isSameDayAsDate(NSDate())){
            self._melody.displayLoadingView(self.view, text:"Chargement du catalogue en cours. Merci de patienter.")
            
            println("url request \(_getEmissionRequestUrl!)")
            
            
            request(.GET, _getEmissionRequestUrl!)
                .responseSwiftyJSON{(request, response, json, error) in
                    if (error?.code > -2000)
                    {
                        
                        //println("No Internet connection")
                    }
                    else{
                        // Ajoute un print avant sinon playgr9und renvoie 0 -> bug
                        println(" MELODY CONTENT JSON \(json)")
                        if(json["user"].stringValue ==  "not subscribed" && self._melody._user == nil || json["user"].stringValue ==  "subscribed" && self._melody._user != nil){
    
                            println("Updating ...")
                            
                            if (isActu == false){
                                
                                self.getEmissionsItems(json)
                            }else{
                                self.getActuItems(json)
                            }
                            
                        }
                        else{
                            println("Nothing to update")
                            NSNotificationCenter.defaultCenter().postNotificationName("userDisconnected", object: nil, userInfo:nil)

                        }
                        self.tableView.reloadData()
                    }
                    println("End of get misions")
                    self._melody.hideLoadingView()
            }
        }
    }

    
    func getActuItems(json: JSON){
        
        var array = json["results"]
        
        //  //println("ARRAY \(array)")
        _melody._emissionsList[_templateId].removeAll(keepCapacity: false)
        
        for (index: String, subJson: JSON) in array {
            //Do something you want
            // joce api
            
            var artists : Array<JSON> = subJson["Video"].arrayValue
            
            var programme : Emission = Emission(emissionDescription: subJson["Actualite"]["description"].stringValue,
                id: subJson["Actualite"]["id"].stringValue,
                emissionCategory:subJson["Actualite"]["credit_photo"].stringValue,
                end: "",
                start:"",
                produced:subJson["Video"]["produced"].stringValue.producedFormatNSDate(),
                formated_duration:"",
                url_Video:"",
                thumb_image: subJson["Actualite"]["small_thumb_url"].stringValue,
                date: NSDate(),
                emissionName:subJson["Actualite"]["title"].stringValue,
                artists:artists,
                diffusionDate:NSDate(),
                relatedEmissions: nil,
                tag:7,
                publicationMobile:false)
            
            
            programme.publication =  subJson["Actualite"]["date_publication"].stringValue
            
            if (_melody.isUserConnected() == true){
                if let url_mobile = subJson["Video"]["url_mobile"].string {
                    programme.url_Video = url_mobile
                }
                
            }
            _melody._emissionsList[_templateId].append(programme)
        }
        // update LastUpdate
        
        _melody._msmCoreData.actuLastUpdate = String(NSDate().toLastUpdateFormatString())
        
        println(" Actu lastUpdate \(_melody._msmCoreData.actuLastUpdate)")
    }
    
    
    
    func getEmissionsItems(json: JSON){
        var array = json["results"]
        
        println("#!ARRAY \(array)")
        
        _melody._emissionsList[_templateId].removeAll(keepCapacity: false)
        
        
        for (index: String, subJson: JSON) in array {
            var artists : Array<JSON> = subJson["Video"]["Artist"].arrayValue
            //Do something you want
            
            // joce api
            var category : String
            if(self.title  == kMLDMenuReplaysIdentifier){
                var emissionid : String =  subJson["Video"]["emission_id"].stringValue
                
                category = _melody._emissionIdToCategory[emissionid]!
            }
            else{
                category = _currentCategorySelected
            }
            
            var programme : Emission = Emission(emissionDescription: subJson["Video"]["description"].stringValue,
                id: subJson["Video"]["id"].stringValue,
                emissionCategory:category,
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
            _melody._emissionsList[_templateId].append(programme)
        }
        self.tableView.reloadData()
        _melody._msmCoreData.setLastUpdate(String(NSDate().toLastUpdateFormatString()), atIndex: _templateId)

    }
    
    
    func userConnectedNofication(notification : NSNotification){
        
        
        println("User vient de se connecter")
        // lancer une requête qui vérifie chaque jour si l'utilisateur est toujours abonné
        
        if (notification.name == "userConnected"){
            //  self.selectedIndex = 0
            self._melody.clearLastUpdates()
          //  self.setAboMode()
            _melody._msmCoreData.clearLastUpdate()
            
        }
        
    }
    
    func userDisconnectedNofication(notification : NSNotification){
        if (notification.name == "userDisconnected"){
            //   self.selectedIndex = 0
            self._melody.clearLastUpdates()
           // self.setUnAboMode()
            self._melody.clearUser()
        }
    }
    

}
