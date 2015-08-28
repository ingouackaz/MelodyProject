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
    var currentLastUpdateIndex : Int = 0
    
    
    @IBOutlet weak var varieteButton: UIButton!
    @IBOutlet weak var concertButton: UIButton!
    @IBOutlet weak var filmsMusicauxButton: UIButton!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var storyButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        self.navigationController?.navigationBar.tintColor = UIColor.clearColor()
        self.view.backgroundColor = UIColor(hexString: "#FD9A00")
        self._collectionView.backgroundColor = UIColor(hexString: "#E8E8E8")
        
        var storyboard: UIStoryboard = UIStoryboard(name: "iPad", bundle: NSBundle(forClass: self.dynamicType))
        
        if (self.title == "actu"){
            _destVc = storyboard.instantiateViewControllerWithIdentifier("actuPopUp") as UINavigationController!
        }
        else{
            _destVc = storyboard.instantiateViewControllerWithIdentifier("popUp") as UINavigationController!

        }

        _formsheet =  MZFormSheetController(size: CGSize(width: 650, height: 600), viewController: _destVc)
        
        _formsheet!.shouldDismissOnBackgroundViewTap = true
        _formsheet!.shouldCenterVertically = true
        
        MZFormSheetController.sharedBackgroundWindow().formSheetBackgroundWindowDelegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"formSheetDidDismissNotification:", name:MZFormSheetDidDismissNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"formSheetDidPresentNotification:", name:MZFormSheetDidPresentNotification, object: nil)

    }

    
    func loadInformation(){
       // self.deselectAllButton()
        
        println("Calling view will appear")
        _pageControl.currentPage = 0
        _pageIndex = 0
 
        
        if(self.title == "videoClub"){
            self.varieteButton.selected = true
            self._getEmissionRequestUrl = NSURL(string: "http://www.melody.tv/json-new/videos/find_by_emission/1/100000?lang=fre?token=" +  _melody._userToken + "&modified=" + _melody._msmCoreData.getLastUpdate(atIndex: self.currentLastUpdateIndex))
            
            
            self.startGetEmissionsRequest(false)
            
        }else if(self.title == "replay"){
            self._getEmissionRequestUrl = NSURL(string: "http://www.melody.tv/json-new/videos/get_replay/2014_10_23/?lang=eng?token=" +  _melody._userToken)
            self.startGetEmissionsRequest(false)
            
        }
        else{
            
            var urlString : String = "http://www.melody.tv/json-new/actualites/appligetall/36?token=" +  _melody._userToken + "&modified=" + _melody._msmCoreData.actuLastUpdate
            
            println("lastUpdate actu \(_melody._msmCoreData.actuLastUpdate)")

            self._getEmissionRequestUrl = NSURL(string:urlString)
            

            self.startGetEmissionsRequest(true)
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadInformation()
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    func formSheetDidDismissNotification(notification : NSNotification){
        println("FORM SHIT DID DISMISS")
        _isPresentingFormSheet = false
        
        _melody._isTheFirstPopUp = true

        
    }
    
    func formSheetDidPresentNotification(notification : NSNotification){
        println("FORM SHIT DID DISMISS")
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

        if(collectionView.tag == 1){
            println("_melody._emissionCategory.count \(_melody._emissionCategory.count)")

        
            return _melody._emissionCategory.count
        }
        else {
            _pageControl.numberOfPages =  _emissions.count / 12
            return _emissions.count
        }

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
        var button:UIButton = sender as UIButton
        if(button.selected != true){
            self.deselectAllButton()
            _pageControl.currentPage = 0
            _pageIndex = 0
            button.selected = true
            
            var categoryIdString : String =  Array((_melody._emissionCategory[button.tag] as Dictionary).keys)[0]
            println("CategoryId \(categoryIdString)")
            self._currentCategorySelected =  Array((_melody._emissionCategory[button.tag] as Dictionary).values)[0]
            
            println("Current Cat \(self._currentCategorySelected)")
            
            
            self._getEmissionRequestUrl = NSURL(string: "http://www.melody.tv/json/videos/find_by_emission/" + categoryIdString + "/100000?lang=fre?token=xxxxx" +  _melody._userToken + "&modified=" + _melody._msmCoreData.getLastUpdate(atIndex: self.currentLastUpdateIndex))
            
            self.currentLastUpdateIndex = button.tag
            self.startGetEmissionsRequest(false)
        }

    }

    
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        
    }
    
    override func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        _pageIndex = (indexPath.row / 12)

        if (collectionView.tag == 1){
            
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as emissionCategoryVCell

            var name : String =  Array((_melody._emissionCategory[indexPath.row] as Dictionary).values)[0]
            
            
            cell.nameLabel.text = "Salut"
            return cell
        }
        else{
            
            println("CollectionView Tag \(collectionView.tag)")
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as AcceuilCVC
        
        var emission : Emission = _emissions[indexPath.row]
        cell.backgroundColor =  UIColor(hexString: "#E8E8E8")
        cell.titleLabel.text = emission.emissionName
            if (cell.tag == 1){
                cell.addedLabel.text =   emission.publication!.actuPublicationString()
            }
            
   //     _pageIndex = (indexPath.row / 4)
    ///
        

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
                            (cellToUpdate as AcceuilCVC).thumbImageView.image = image
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
    }

     func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("Selected")

      //  _melody._selectedEmission = _emissions[indexPath.row]
        
        
        if(_isPresentingFormSheet == false){
            
            _melody._selectedEmission = _emissions[indexPath.row]
            
            self.mz_presentFormSheetWithViewController(_formsheet, animated: true, completionHandler: {(MZFormSheetController)  in
                println("red box has faded out")
            })
        }
     
    }

    func deselectAllButton(){
    
        varieteButton.selected = false
        concertButton.selected = false
        filmsMusicauxButton.selected = false
        starButton.selected = false
        storyButton.selected = false
    }
    
    func startGetEmissionsRequest(isActu:Bool){
        
        self._melody.displayLoadingView(self.view)
        NSDate().toLastUpdateFormatString()
       //_getEmissionRequestUrl!.URLByAppendingPathComponent("modified=\(lastUStr)")
        
        println("getE URL \(_getEmissionRequestUrl)")
        
        request(.GET, _getEmissionRequestUrl! )
            .responseSwiftyJSON{(request, response, json, error) in
                if (error?.code > -2000)
                {
                    
                    //println("No Internet connection")
                }
                else{
                    // Ajoute un print avant sinon playgr9und renvoie 0 -> bug
                     println(" MELODY CONTENT JSON \(json)")
                    
                    
                    if(json["err_msg"].stringValue.isEmpty == true){
                        if (isActu == false){
                            self.getEmissionsItems(json)
                        }else{
                            self.getActuItems(json)
                        }
                        self._collectionView.reloadData()
                    }
                    else{
                    println("Nothing to update")
                        
                    }
                    

                    // self.getMuseumItems(json)
                    // self._loadingHUD.hide(false)
                    //self._museum._context.save(nil)
                }
                
                self._melody.hideLoadingView()

        }
        
        
    }
    
    
    func getActuItems(json: JSON){
        
        var array = json["results"]
        
        //  //println("ARRAY \(array)")
        _emissions.removeAll(keepCapacity: false)
        
        for (index: String, subJson: JSON) in array {
            //Do something you want
            // joce api
            
            var artists : Array<JSON> = subJson["Video"].arrayValue
            
                var programme : Emission = Emission(emissionDescription: subJson["Actualite"]["description"].stringValue,
                    id: subJson["Actualite"]["id"].stringValue,
                    emissionCategory:subJson["Actualite"]["credit_photo"].stringValue,
                    end: "",
                    start:"",
                    produced:subJson["Video"]["Rush"]["produced"].stringValue.producedFormatNSDate(),
                    formated_duration:"",
                    url_Video:"",
                    thumb_image: subJson["Actualite"]["small_thumb_url"].stringValue,
                    date: NSDate(),
                    emissionName:subJson["Actualite"]["title"].stringValue,
                    artists:artists,
                    diffusionDate:NSDate(),
            relatedEmissions: nil,
            tag:0)

            
            programme.publication =  subJson["Actualite"]["date_publication"].stringValue
                
                if (_melody.isUserConnected() == true){
                    if let url_mobile = subJson["Video"]["url_mobile"].string {
                        programme.url_Video = url_mobile
                    }
                    
                }
                _emissions.append(programme)
        }
        // update LastUpdate
        
        _melody._msmCoreData.actuLastUpdate = String(NSDate().toLastUpdateFormatString())
        
        println(" Actu lastUpdate \(_melody._msmCoreData.actuLastUpdate)")
    }
    
        
    
    func getEmissionsItems(json: JSON){
        var array = json["results"]
        
        //  //println("ARRAY \(array)")
        _emissions.removeAll(keepCapacity: false)
        
        
        
        
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
                tag:0
            )
            
            
            
    
            if (_melody.isUserConnected() == true){
                if let url_mobile = subJson["Video"]["url_mobile"].string {
                    programme.url_Video = url_mobile
                }
                
            }
            _emissions.append(programme)
        }
        
        _melody._msmCoreData.setLastUpdate(String(NSDate().toLastUpdateFormatString()), atIndex: self.currentLastUpdateIndex)
    }
    
    
}
