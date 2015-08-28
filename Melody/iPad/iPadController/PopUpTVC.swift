//
//  PopUpTVC.swift
//  Melody
//
//  Created by Roger Ingouacka on 05/12/14.
//
//

import UIKit
import MediaPlayer


class PopUpTVC: UITableViewController , UICollectionViewDelegate,UICollectionViewDataSource{

    var _melody : Melody = Melody.sharedInstance

    @IBOutlet var titleEmissionLabel: UILabel!
    @IBOutlet weak var producedLabel: UILabel!
    @IBOutlet weak var thumbEmissionImage: UIImageView!
    @IBOutlet weak var producedFixLabel: UILabel!

    @IBOutlet var publicationMobileLabel: UILabel!

    @IBOutlet weak var relatedEmissionCV: UICollectionView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var emissionCategoryLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var artistsTextView: UITextView!

    @IBOutlet weak var artistsLabel: UILabel!

    @IBOutlet weak var playFullVideoButton: UIButton!
    @IBOutlet weak var playTeaserVideoButton: UIButton!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var aboButton: UIButton!
    var _playerVC : MPMoviePlayerViewController?
    var _selectedEmission : Emission?
    var _seeAlsoEmissions : Array<Emission> = []

    @IBOutlet var aboTextViewInformation: UITextView!
    @IBOutlet var firstTryPicto: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
         self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        var err: NSError?


        var controller : MZFormSheetController = self.navigationController!.formSheetController
        controller.shouldDismissOnBackgroundViewTap = true
        
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        

        self.googleAnalytics()
        
        if (_melody._isTheFirstPopUp == true){

            self.loadInformation()
        }

        _melody._isTheFirstPopUp = false
        self.navigationItem.backBarButtonItem =  UIBarButtonItem(title: "Retour", style: .Plain, target: self, action:nil)


    }
    
    func googleAnalytics(){
        var tracker : GAITracker = GAI.sharedInstance().defaultTracker
        
        
        if(_selectedEmission?.emissionName == nil){
            
            tracker.set(kGAIScreenName, value: "Pop Up Video ")
        }
        else{
            tracker.set(kGAIScreenName, value: "Pop Up Video - " + _selectedEmission!.emissionName)
        }
        tracker.send(GAIDictionaryBuilder.createAppView().build() as [NSObject : AnyObject])
    }
    
    func loadInformation(){
        
        _selectedEmission = _melody._selectedEmission
        _seeAlsoEmissions = _melody._seeAlsoEmissions
        
        for (index, emission) in enumerate(_seeAlsoEmissions){
            if(_selectedEmission?.id == emission.id){
                _seeAlsoEmissions.removeAtIndex(index)
            }            
        }
        
        if (_selectedEmission!.tag == 0){
        }

        if ((_selectedEmission!.thumb_image ) == nil  && _selectedEmission!.url_thumb_image.isEmpty == false){
            
            self.thumbEmissionImage.image = UIImage(contentsOfFile: "melody_cover")
            self.downloadImage()
        }
        else if ((_selectedEmission!.thumb_image ) != nil){
            self.thumbEmissionImage.image = _selectedEmission!.thumb_image
            
        }
        else{
            self.thumbEmissionImage.image = UIImage(contentsOfFile: "melody_cover")
        }
        
        
        self.updatePopUpContent()
       
        self.relatedEmissionCV.reloadData()
    }
    

    
    @IBAction func closePopUpAction(sender: AnyObject) {
        self.mz_dismissFormSheetControllerAnimated(true, completionHandler: nil)
       // var controller : MZFormSheetController = self.navigationController!.for/mSheetController

    }
    
    
    @IBAction func playTeaserAction(sender: AnyObject) {
        
        var urlVideo : NSURL =  NSURL(string: _selectedEmission!.url_Video)!
        var playerVC : MPMoviePlayerViewController = MPMoviePlayerViewController(contentURL: urlVideo)
        
        
        NSNotificationCenter.defaultCenter().removeObserver(playerVC, name:MPMoviePlayerPlaybackDidFinishNotification, object: playerVC.moviePlayer)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"movieFinishedCallback:", name:MPMoviePlayerPlaybackDidFinishNotification, object: nil)


        
        
        playerVC.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        
        self.presentViewController(playerVC, animated: true, completion: nil)
        playerVC.moviePlayer.prepareToPlay()
        playerVC.moviePlayer.play()
    }
    


    
    func movieFinishedCallback(notification : NSNotification){
        
        var finishReason : NSNumber = notification.userInfo![MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] as! NSNumber
        
        if (finishReason.integerValue != MPMovieFinishReason.PlaybackEnded.rawValue){
            

            self.dismissViewControllerAnimated(true, completion: nil)

            let delay = 1.5 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue(), { () -> Void in
                
                UIApplication.sharedApplication().statusBarHidden = false
            })


        }
        
        
    }
    
    
    func updatePopUpContent(){
        self.titleEmissionLabel?.text = _selectedEmission?.emissionName
        self.title = _selectedEmission?.emissionCategoryName
        self.emissionCategoryLabel.text = _selectedEmission?.emissionCategoryName
        self.producedLabel.text = "Inconnu"
        if(_selectedEmission?.produced != nil){
            self.producedLabel.text = _selectedEmission!.produced!.toProducedFormatString()
        }
        
        self.displayEmissionDescription()
        
        // Emission possède des vidéos
        
        if(_selectedEmission?.emissionCategoryName == "Variétés" || _selectedEmission?.emissionCategoryName == "Concerts" || _selectedEmission?.emissionCategoryName == "Films musicaux" || _selectedEmission?.emissionCategoryName == "Melody de Star" || _selectedEmission?.emissionCategoryName == "Melody story"){
            // video
            
            self.displayPlayButton(true)
            self.displayArtistAndProducedDate()
            //
        }
        else{
            self.displayPlayButton(false)
            self.artistsTextView.hidden = true
            self.producedLabel.hidden = true
            self.producedFixLabel.hidden = true
        }


    }
    
    func displayEmissionDescription(){
        
        // emission description
        var   myDescriptionMutableString = NSMutableAttributedString(string:"Description : " + _selectedEmission!.emissionDescription.stringByConvertingHTMLToPlainText(), attributes: [NSFontAttributeName:UIFont(name: "TeXGyreAdventor-Regular", size: 14.0)!])
        myDescriptionMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "TeXGyreAdventor-Bold", size: 14.0)!, range: NSRange(location: 0,length: 11))
        
        self.descriptionTextView.attributedText = myDescriptionMutableString
    }
    
    func displayArtistAndProducedDate(){
        
        
        if(_selectedEmission?.emissionCategoryName != "Melody de Star" && _selectedEmission?.emissionCategoryName != "Melody story"){
            
        
        var artistList : String = "Artistes : "
        
        for obj in _selectedEmission!.artists{
            
            var dic : Dictionary = obj.dictionaryValue
            
            artistList += dic["firstname"]!.stringValue + " " + dic["lastname"]!.stringValue +  ", "
        }
        self.artistsTextView.text = artistList
        
        if ( _selectedEmission!.artists.count == 0){
            self.artistsTextView.text = "Non renseigné"
        }
        self.artistsTextView.hidden = false
        self.producedLabel.hidden = false
        self.producedFixLabel.hidden = false
        var   myMutableString = NSMutableAttributedString(string:artistList, attributes: [NSFontAttributeName:UIFont(name: "TeXGyreAdventor-Regular", size: 14.0)!])
        myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "TeXGyreAdventor-Bold", size: 14.0)!, range: NSRange(location: 0,length: 11))
        
        self.artistsTextView.attributedText = myMutableString
        }
        else{
        
            self.artistsTextView.hidden = true
            self.producedLabel.hidden = true
            self.producedFixLabel.hidden = true
        }
    }

    @IBAction func nextAction(sender: AnyObject) {
        
        
        var vc : PopUpTVC
        var storyboard: UIStoryboard = UIStoryboard(name: "iPad", bundle: NSBundle(forClass: self.dynamicType))
        
        vc = storyboard.instantiateViewControllerWithIdentifier("popUpTVC") as! PopUpTVC
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func displayPlayButton(canDisplayVideo:Bool){
        if (_melody._user != nil){
            
            self.setAboMode()
        }
        else{
            self.setNonAboMode(canDisplayVideo)
        }
    }
    
    func setAboMode(){
    
        aboButton.hidden = true
        playTeaserVideoButton.hidden = true
        firstTryPicto.hidden = true
        aboTextViewInformation.hidden = true
        playFullVideoButton.hidden = false

        publicationMobileLabel.hidden = true

        
        if (_selectedEmission?.publicationMobile == false){
            playFullVideoButton.hidden = true
            publicationMobileLabel.hidden = false
        }
    }
    
    func setNonAboMode(canDisplayVideo:Bool){
        
        if (canDisplayVideo == true){
            playTeaserVideoButton.hidden = false
        }
        else{
            playTeaserVideoButton.hidden = true

        }
        
        aboButton.hidden = false
        firstTryPicto.hidden = false
        aboTextViewInformation.hidden = false
        playFullVideoButton.hidden = true

        publicationMobileLabel.hidden = true
        
        
        if (_selectedEmission?.publicationMobile == false){
            playFullVideoButton.hidden = true
            publicationMobileLabel.hidden = false
        }
    }
    
    
    func downloadImage(){
        var imgUrl: NSURL = NSURL(string: _selectedEmission!.url_thumb_image)!
        // Download an NSData representation of the image at the URL
        let request: NSURLRequest = NSURLRequest(URL: imgUrl)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
            if error == nil {
                
                self._selectedEmission!.thumb_image =  UIImage(data: data)
                self.thumbEmissionImage.image = self._selectedEmission?.thumb_image
                println("img downloaded")
            }
            else {
                println("Error: \(error.localizedDescription)")
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    @IBAction func aboAction(sender: AnyObject) {
        
        
        var tracker : GAITracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Pop Up Video Action - " + _selectedEmission!.emissionName)
        
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("UX", action: "abonnement", label: "Abo", value: nil).build() as [NSObject : AnyObject])
        
        
        
    //    tracker.send(GAIDictionaryBuilder.createAppView().build())
        
        self._melody.displayLoadingView(self.view, text:"")
        
        if( _melody._pfPurchaseInProgress == false){
            _melody._pfPurchaseInProgress = true
            
            
            PFPurchase.buyProduct("AboMensuel", block: { (error:NSError?) -> Void in
                self._melody.hideLoadingView()
                self._melody._pfPurchaseInProgress = false
                
                if error != nil{
                    
                    if let gotModernAlert: AnyClass = NSClassFromString("UIAlertController") {
                        
                        println("alerte creation")
                        let alert = UIAlertController(title: "Erreur", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        
                        self.presentViewController(alert, animated: true, completion: nil)
                        //make and use a UIAlertController
                        
                    }
                    else {
                        
                        let alert = UIAlertView()
                        alert.title = "Erreur"
                        alert.message =  error?.localizedDescription
                        alert.addButtonWithTitle("OK")
                        alert.show()
                        //make and use a UIAlertView
                    }
                    
                }
            })
        }
    }
    

    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor =  UIColor(hexString: "#E8E8E8")

    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        

        return _seeAlsoEmissions.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! PopUpCVCell
        
        
        
        var emission : Emission =  _seeAlsoEmissions[indexPath.row]
        
        
        
        cell.titleEmission.text = emission.emissionName
        
        
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
                            (cellToUpdate as! PopUpCVCell).thumbImageView.image = image
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


    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        _melody._selectedEmission = _seeAlsoEmissions[indexPath.row]
        
        
        _melody._isTheFirstPopUp = true

        
        var vc : PopUpTVC
        var storyboard: UIStoryboard = UIStoryboard(name: "iPad", bundle: NSBundle(forClass: self.dynamicType))
        
        vc = storyboard.instantiateViewControllerWithIdentifier("popUpTVC") as! PopUpTVC
        
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    

}
