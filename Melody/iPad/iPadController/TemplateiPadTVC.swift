//
//  TemplateiPadTVC.swift
//  Melody
//
//  Created by Roger Ingouacka on 28/11/14.
//
//

import UIKit

class TemplateiPadTVC: UITableViewController, UICollectionViewDelegate,UICollectionViewDataSource, MZFormSheetBackgroundWindowDelegate {
    var _melody : Melody = Melody.sharedInstance

    @IBOutlet weak var categoryEmissionCollectionView: UICollectionView!
    @IBOutlet weak var _pageControl: UIPageControl!
    @IBOutlet weak var _collectionView: UICollectionView!
    var _getEmissionRequestUrl : NSURL?
    var _emissions : Array<Emission> = []
    var _formsheet : MZFormSheetController?
    var _isPresentingFormSheet : Bool = false
    var _pageIndex : Int = Int()
    var _destVc : UINavigationController?
    var _currentCategorySelected : String = "Variétés"
    var currentLastUpdateIndex : Int = 1
    var _templateId : Int = 0
    
    var _emissionsList : Array<[Emission]> = Array<[Emission]>(count: 7, repeatedValue:Array<Emission>())
 
    
    @IBOutlet weak var varieteButton: UIButton!
    @IBOutlet weak var concertButton: UIButton!
    @IBOutlet weak var filmsMusicauxButton: UIButton!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var storyButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.deselectAllButton()
        self.navigationController?.navigationBarHidden = true
        self.navigationController?.navigationBar.tintColor = UIColor.clearColor()
        self.view.backgroundColor = UIColor(hexString: "#FD9A00")
        self._collectionView.backgroundColor = UIColor(hexString: "#E8E8E8")
        
        var storyboard: UIStoryboard = UIStoryboard(name: "iPad", bundle: NSBundle(forClass: self.dynamicType))
        
        if (self.title == "actu"){
            _destVc = storyboard.instantiateViewControllerWithIdentifier("actuPopUp") as! UINavigationController!
        }
        else{
            _destVc = storyboard.instantiateViewControllerWithIdentifier("popUp") as! UINavigationController!

        }

        if(self.title == "videoClub"){
            self.concertButton.selected = true
        }
        
        _formsheet =  MZFormSheetController(size: CGSize(width: 650, height: 600), viewController: _destVc)
        
        _formsheet!.shouldDismissOnBackgroundViewTap = true
        _formsheet!.shouldCenterVertically = true
        
        MZFormSheetController.sharedBackgroundWindow().formSheetBackgroundWindowDelegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"formSheetDidDismissNotification:", name:MZFormSheetDidDismissNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"formSheetDidPresentNotification:", name:MZFormSheetDidPresentNotification, object: nil)

    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)


    }
    func updateTemplateId(){
    
        if(self._collectionView.tag == 0){
            _templateId = self._collectionView.tag
        }
        else if(self._collectionView.tag == 6){
         _templateId = self._collectionView.tag
        }
            
        else{
            _templateId = self._collectionView.tag + currentLastUpdateIndex

        }
        
        
        //_emissionsList
    }
    
    func loadInformation(){
        
        self.updateTemplateId()
        //println("Calling view will appear")
        _pageControl.currentPage = 0
        _pageIndex = 0
 
        
        if(self.title == "videoClub"){
            
            self._getEmissionRequestUrl = NSURL(string: kMLDConcertsRequest +  _melody._userToken )
            
            self.startGetEmissionsRequest(false)
            
            // gl analitycs
            var tracker : GAITracker = GAI.sharedInstance().defaultTracker
            tracker.set(kGAIScreenName, value: "Page VOD")
            tracker.send(GAIDictionaryBuilder.createAppView().build() as [NSObject : AnyObject])
            
            
        }else if(self.title == "replay"){
            
            
            self._getEmissionRequestUrl = NSURL(string:kMLDReplaysRequest + NSDate().lastSaturdayDate() + "/?lang=eng&token=" +  _melody._userToken )
            self.startGetEmissionsRequest(false)
            
            
            var tracker : GAITracker = GAI.sharedInstance().defaultTracker
            tracker.set(kGAIScreenName, value: "Page Replay")
            tracker.send(GAIDictionaryBuilder.createAppView().build() as [NSObject : AnyObject])
        }
        else{
            
            
            var tracker : GAITracker = GAI.sharedInstance().defaultTracker
            tracker.set(kGAIScreenName, value: "Page Actualités")
            tracker.send(GAIDictionaryBuilder.createAppView().build() as [NSObject : AnyObject])
            
            var urlString : String = kMLDActualitesRequest +  _melody._userToken
            
            self._getEmissionRequestUrl = NSURL(string:urlString)
            

            self.startGetEmissionsRequest(true)
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self._melody.hideLoadingView()

      //  self.deselectAllButton()

        self.loadInformation()
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    func formSheetDidDismissNotification(notification : NSNotification){
        _isPresentingFormSheet = false
        
        _melody._isTheFirstPopUp = true

        
    }
    
    func formSheetDidPresentNotification(notification : NSNotification){
        _isPresentingFormSheet = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section

            _pageControl.numberOfPages =  _emissionsList[_templateId].count / 12
            if( (_emissionsList[_templateId].count % 12) > 0){
                _pageControl.numberOfPages += 1

            }
            return _emissionsList[_templateId].count

    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
     //   _pageControl.currentPage = _pageIndex
     //   println("Current page \(_pageIndex)")
        
        _pageControl.currentPage = _pageIndex

    }
    
    @IBAction func caterogyButtonPressed(sender: AnyObject) {
        var button:UIButton = sender as! UIButton
        if(button.selected != true){
            self.deselectAllButton()
            _pageControl.currentPage = 0
            _pageIndex = 0
            button.selected = true
            
            var categoryIdString : String =  Array((_melody._emissionCategory[button.tag] as Dictionary).keys)[0]
            self._currentCategorySelected =  Array((_melody._emissionCategory[button.tag] as Dictionary).values)[0]
            
            
            self.currentLastUpdateIndex = button.tag

            self.updateTemplateId()
            
            self._getEmissionRequestUrl = NSURL(string: kMLDEmissionRequest + categoryIdString + "/100000?lang=fre&token=" +  _melody._userToken )
            
            self.startGetEmissionsRequest(false)
            self.updateTemplateId()

        }

    }

    
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        
    }
    
    override func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        self.updateTemplateId()
        
        
        _pageIndex = (indexPath.row / 12)

        // calcule du template Id
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! AcceuilCVC


        var emission : Emission = _emissionsList[_templateId][indexPath.row]
        cell.backgroundColor =  UIColor(hexString: "#E8E8E8")
        cell.titleLabel.text = emission.emissionName
            if (cell.tag == 1){
                cell.addedLabel.text =   emission.publication!.actuPublicationString()
            }
        

        var urlString = emission.url_thumb_image
            cell.thumbImageView.layer.masksToBounds = true
            cell.thumbImageView.layer.cornerRadius = 5
             cell.thumbImageView.layer.borderColor = UIColor.blackColor().CGColor
         cell.thumbImageView.layer.borderWidth = 1
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
                        
                        if let cellToUpdate = collectionView.cellForItemAtIndexPath(indexPath) {
                            //cellToUpdate.imageView?.image = image
                            (cellToUpdate as! AcceuilCVC).thumbImageView.image = image
                            
                            emission.thumb_image = image
                            //self._museum._conte-xt.save(nil)
                            
                        }
                    })
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
            
        }
        else {
            cell.thumbImageView.image = emission.thumb_image
            
        }
        return cell
    }


    func cellEmissionBasedOnIndexPath(indexPath: NSIndexPath) -> Int {
        var row : Int = indexPath.item % 3 + 1
        var column : Int = indexPath.item / 3 + 1
        var itemIndex : Int = row * 3 - (4 - column) - 1

        return itemIndex
    }
    
     func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        
        
        if(_isPresentingFormSheet == false){
            
            _melody._selectedEmission = _emissionsList[_templateId][indexPath.row]
            
            self.mz_presentFormSheetWithViewController(_formsheet, animated: true, completionHandler: {(MZFormSheetController)  in
            })
        }
     
    }


    
    func deselectAllButton(){
    
        
    if(self.title != "replay" && self.title != "actu"){

        self.varieteButton.selected = false
        self.concertButton.selected = false
        self.filmsMusicauxButton.selected = false
        self.starButton.selected = false
        self.storyButton.selected = false
        
        }
    }
    
    func startGetEmissionsRequest(isActu:Bool){
        if( !_melody._msmCoreData.getLastUpdateDate(atIndex:_templateId).isSameDayAsDate(NSDate())){

        self._melody.displayLoadingView(self.view, text:"Chargement du catalogue en cours. Merci de patienter.")

        println("Start request \(_getEmissionRequestUrl)")
            
        request(.GET, _getEmissionRequestUrl! )
            .responseSwiftyJSON{(request, response, json, error) in
                if (error?.code > -2000)
                {
                    
                    //println("No Internet connection")
                }
                else{
                    

                    // Ajoute un print avant sinon playgr9und renvoie 0 -> bug
                    

                    if(json["user"].stringValue ==  "not subscribed" && self._melody._user == nil || json["user"].stringValue ==  "subscribed" && self._melody._user != nil){
                        
                        println("Updating ...   \(self._getEmissionRequestUrl)")
                        
                        if (isActu == false){

                            self.getEmissionsItems(json)
                        }else{
                            self.getActuItems(json)
                        }
                        
                    }
                    else{
                        
                        NSNotificationCenter.defaultCenter().postNotificationName("userDisconnected", object: nil, userInfo:nil)

                    println("Nothing to update")

                    }
                    self._collectionView.reloadData()

                }
                
                self._melody.hideLoadingView()

            }
        }
        self._collectionView.reloadData()

    }
    
    
    func getActuItems(json: JSON){
        
        var array = json["results"]
        
        //  //println("ARRAY \(array)")
        _emissionsList[_templateId].removeAll(keepCapacity: false)
        
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
                _emissionsList[_templateId].append(programme)
        }
        // update LastUpdate
        
        _melody._msmCoreData.actuLastUpdate = String(NSDate().toLastUpdateFormatString())
        
        println(" Actu lastUpdate \(_melody._msmCoreData.actuLastUpdate)")
    }
    
        
    
    func getEmissionsItems(json: JSON){
        self.updateTemplateId()

        var array = json["results"]
        println("JSON \(json)")

        _emissionsList[_templateId].removeAll(keepCapacity: false)
        
        for (index: String, subJson: JSON) in array {
            var artists : Array<JSON> = subJson["Video"]["Artist"].arrayValue
            //Do something you want

            // joce api
            var category : String
            if(self.title == "replay"){
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
                    println("video abo loaded")
                    programme.url_Video = url_mobile
                }
                else{
                    println("video abo not found")

                }
                
            }
            _emissionsList[_templateId].append(programme)
            self._collectionView.reloadData()
        }
        
        _melody._msmCoreData.setLastUpdate(String(NSDate().toLastUpdateFormatString()), atIndex: _templateId)
    }
    
    
}
