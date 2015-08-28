//
//  AccueilVC.swift
//  Melody.Tv
//
//  Created by Roger Ingouacka on 28/10/2014.
//  Copyright (c) 2014 Roger Ingouacka. All rights reserved.
//

import UIKit

class AccueilVC: UITableViewController, UICollectionViewDelegate,UICollectionViewDataSource, KASlideShowDelegate, MZFormSheetBackgroundWindowDelegate{
    var _melody : Melody = Melody.sharedInstance

    @IBOutlet weak var _pageControl: UIPageControl!
    @IBOutlet var _slideShowView: KASlideShow!
    @IBOutlet weak var _collectionView: UICollectionView!
    var _isPresentingFormSheet : Bool = false

    var _images : NSMutableArray = [UIImage(named: "melody_cover")!,UIImage(named: "melody_cover")!,UIImage(named: "melody_cover")!,UIImage(named: "melody_cover")!,UIImage(named: "melody_cover")!]
    
    var _pageIndex : Int = Int()
    var _countImage : Int = 0

    var _actualites : Array<Emission> = []

    var _formsheet : MZFormSheetController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        self.navigationController?.navigationBar.tintColor = UIColor.clearColor()
        self.view.backgroundColor = UIColor(hexString: "#FD9A00")
        

        
        var storyboard: UIStoryboard = UIStoryboard(name: "iPad", bundle: NSBundle(forClass: self.dynamicType))
        var vc : UINavigationController
        vc = storyboard.instantiateViewControllerWithIdentifier("actuPopUp") as! UINavigationController

        _formsheet =  MZFormSheetController(size: CGSize(width: 650, height: 600), viewController: vc)
        
        _formsheet!.shouldDismissOnBackgroundViewTap = true
        _formsheet!.shouldCenterVertically = true
        
        MZFormSheetController.sharedBackgroundWindow().formSheetBackgroundWindowDelegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"formSheetDidDismissNotification:", name:MZFormSheetDidDismissNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"formSheetDidPresentNotification:", name:MZFormSheetDidPresentNotification, object: nil)
        

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadSlideSHowImages()
        self.startGetLastActuRequest()
        self.startGetSeeAlsoRequest()
        self._melody.hideLoadingView()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var tracker : GAITracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Page d'Accueil")
        tracker.send(GAIDictionaryBuilder.createAppView().build() as [NSObject : AnyObject])
        
        var defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if(defaults.objectForKey("firstUse") == nil){

            self.performSegueWithIdentifier("goToTuto", sender: nil)
            defaults.setObject("ok", forKey: "firstUse")
            defaults.synchronize()
        }
        
    }
    
    func loadSlideSHowImages(){
        for (index, obj) in enumerate(_images)
        {
            
            if let checkedUrl = NSURL(string:kMLDSlideshowUrlImage + "1024_" + String(index+1) + ".png") {
                downloadImage(checkedUrl, index: index)
            }
        }
    }
    
    func formSheetDidDismissNotification(notification : NSNotification){
        _isPresentingFormSheet = false
        
    }
    
    func formSheetDidPresentNotification(notification : NSNotification){
        _isPresentingFormSheet = true
        
    }
   
    
    

    
    func startGetLastActuRequest(){
        
        self._melody.displayLoadingView(self.view, text:"")
        
        
        request(.GET, kMLDLastActusUrl)
            .responseSwiftyJSON{(request, response, json, error) in
                if (error?.code > -2000)
                {
                    
                    //println("No Internet connection")
                }
                else{

                    self.getActuItems(json)
                    self._collectionView.reloadData()
                }
                
                self._melody.hideLoadingView()
                
        }
    }
    
    func startGetSeeAlsoRequest(){
        
        request(.GET, kMLDSeeAlsoUrl + "?token=" + _melody._userToken )
            .responseSwiftyJSON{(request, response, json, error) in
                if (error?.code > -2000)
                {
                    
                    //println("No Internet connection")
                }
                else{
                    // Ajoute un print avant sinon playgr9und renvoie 0 -> bug
                    self.getSeeAlsoEmissionsItems(json)
                    self._collectionView.reloadData()
                    
                }
                
              //  self._melody.hideLoadingView()
              
        }
        
        
    }
    
    func getSeeAlsoEmissionsItems(json: JSON){
        var array = json["results"]
        
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
    
    func downloadImage(url:NSURL, index:Int){
        

        getDataFromUrl(url) { data in
            dispatch_async(dispatch_get_main_queue()) {
                self._countImage++
                if(data != nil){
                    self._images[index] = UIImage(data: data!)!
                    if(self._countImage == self._images.count){
                        self._slideShowView.delay = 8
                        self._slideShowView.transitionDuration = 2
                        self._slideShowView.transitionType = KASlideShowTransitionType.Fade
                        self._slideShowView.imagesContentMode = UIViewContentMode.ScaleAspectFill
                        self._slideShowView.images = self._images
                        self._slideShowView.start()

                        self._countImage = 0
                    }
                }
              
            }
        }
    }
    func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: NSData(data: data))
            }.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor =  UIColor(hexString: "#E8E8E8")

    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        
        return _actualites.count
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        _pageControl.currentPage = _pageIndex
    }
    
    
    func getActuItems(json: JSON){
        
        var array = json["results"]
        
        //  //println("ARRAY \(array)")
        self._actualites.removeAll(keepCapacity: false)
        
        for (index: String, subJson: JSON) in array {
            //Do something you want
            // joce api
            
            var artists : Array<JSON> = subJson["Video"].arrayValue
            
            var programme : Emission = Emission(emissionDescription: subJson["Actualite"]["description"].stringValue,
                id: subJson["Actualite"]["id"].stringValue,
                emissionCategory:subJson["Actualite"]["credit_photo"].stringValue,
                end: "",
                start:"",
                produced:nil,
                formated_duration:"",
                url_Video:"",
                thumb_image: subJson["Actualite"]["small_thumb_url"].stringValue,
                date: NSDate(),
                emissionName:subJson["Actualite"]["title"].stringValue,
                artists:artists,
                diffusionDate:NSDate(),
                relatedEmissions: nil,
                tag:7,
             publicationMobile:true)
            
            
            programme.publication =  subJson["Actualite"]["date_publication"].stringValue
            var text = subJson["Actualite"]["description"].stringValue

            
            
            
            if (_melody.isUserConnected() == true){
                if let url_mobile = subJson["Video"]["url_mobile"].string {
                    programme.url_Video = url_mobile
                }
                
            }
            self._actualites.append(programme)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        _melody._selectedEmission = _actualites[indexPath.row]
        
        
        
        if(_isPresentingFormSheet == false){
            self.mz_presentFormSheetWithViewController(_formsheet, animated: true, completionHandler: {(MZFormSheetController)  in
            })
        }
        
    }
    
     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {


        _pageIndex = (indexPath.row / 4)

        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! AcceuilCVC
        
        var emission : Emission = _actualites[indexPath.row]
        cell.backgroundColor =  UIColor(hexString: "#E8E8E8")
        cell.titleLabel.text = emission.emissionName
        cell.addedLabel.text =   emission.publication!.actuPublicationString()

        
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
                    
                   // println("Before get image")
                    var image = UIImage(data: data)
                    
                    // Store the image in to our cache
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        if let cellToUpdate = collectionView.cellForItemAtIndexPath(indexPath) {
                            //cellToUpdate.imageView?.image = image
                            (cellToUpdate as! AcceuilCVC).thumbImageView.image = image
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
            cell.thumbImageView.image = emission.thumb_image
            
        }
        return cell
    }


}
