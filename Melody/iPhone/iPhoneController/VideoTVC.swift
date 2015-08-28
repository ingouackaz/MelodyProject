//
//  VideoTVC.swift
//  Melody
//
//  Created by Roger Ingouacka on 23/01/2015.
//
//

import UIKit
import MediaPlayer


class VideoTVC: UITableViewController {

    var _melody : Melody = Melody.sharedInstance
    
    @IBOutlet var titleEmissionLabel: UILabel!
    @IBOutlet weak var producedLabel: UILabel!
    @IBOutlet weak var producedFixLabel: UILabel!

    @IBOutlet weak var thumbEmissionImage: UIImageView!
    // producedFixLabel
    // producedLabel
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
    
    var thumbImageEmissions : Array<UIImageView> = []
    var titleEmissionLabels : Array<UILabel> = []
    var categoryEmissionLabels : Array<UILabel> = []
    var producedEmissionLabels : Array<UILabel> = []

    
    @IBOutlet var thumb_imageEmission1: UIImageView!
    @IBOutlet var titleEmissionLabel1: UILabel!


    @IBOutlet var thumb_imageEmission2: UIImageView!
    @IBOutlet var titleEmissionLabel2: UILabel!


    @IBOutlet var thumb_imageEmission3: UIImageView!
    @IBOutlet var titleEmissionLabel3: UILabel!


    @IBOutlet var thumb_imageEmission4: UIImageView!
    @IBOutlet var titleEmissionLabel4: UILabel!

    
    
    @IBOutlet var firstTryPicto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        thumbImageEmissions = [thumb_imageEmission1,thumb_imageEmission2,thumb_imageEmission3,thumb_imageEmission4]
        titleEmissionLabels = [titleEmissionLabel1,titleEmissionLabel2,titleEmissionLabel3,titleEmissionLabel4]

        
        
        println("Emission \(_melody._selectedEmission)")
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (_melody._isTheFirstPopUp == true){
            
            self.loadInformation()
            self.updateSeeAlseEmission()
        }
        
        _melody._isTheFirstPopUp = false
      //  self.navigationItem.backBarButtonItem =  UIBarButtonItem(title: "Retour", style: .Plain, target: self, action:nil)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func aboAction(sender: AnyObject) {
        
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
    

    
    func loadInformation(){

        
        
        _selectedEmission = _melody._selectedEmission
        _seeAlsoEmissions = _melody._seeAlsoEmissions
                println("image \(_selectedEmission?.thumb_image ) && url \(_selectedEmission?.url_thumb_image)  ")
        
        
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
        
        //self.relatedEmissionCV.reloadData()
    }
    

    
    
    @IBAction func playTeaserAction(sender: AnyObject) {
        
        println("Play Teaser called \(_selectedEmission!.url_Video)")
        var urlVideo : NSURL =  NSURL(string: _selectedEmission!.url_Video)!
        var playerVC : MPMoviePlayerViewController = MPMoviePlayerViewController(contentURL: urlVideo)
        
        
        NSNotificationCenter.defaultCenter().removeObserver(playerVC, name:MPMoviePlayerPlaybackDidFinishNotification, object: playerVC.moviePlayer)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"movieFinishedCallback:", name:MPMoviePlayerPlaybackDidFinishNotification, object: nil)
        
        
        
        
        playerVC.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        _melody._videoIsFullScreen =  true
        self.presentViewController(playerVC, animated: false, completion: nil)
        playerVC.moviePlayer.prepareToPlay()
        playerVC.moviePlayer.play()
    }
    
    
    
    
    func movieFinishedCallback(notification : NSNotification){
        
        _melody._videoIsFullScreen = false
        var finishReason : NSNumber = notification.userInfo![MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] as! NSNumber
        
        if (finishReason.integerValue != MPMovieFinishReason.PlaybackEnded.rawValue){
            
            //var playerVC : MPMoviePlayerViewController = notification.object
            
            //NSNotificationCenter.defaultCenter().removeObserver(playerVC, name:MPMoviePlayerPlaybackDidFinishNotification, object: playerVC.moviePlayer)
            
            self.dismissViewControllerAnimated(false, completion: nil)
            
            let delay = 1.5 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue(), { () -> Void in
                
                UIApplication.sharedApplication().statusBarHidden = false
            })
            
            
            
            //self.navigationController?.navigationBar.frame = CGRect(x: 20, y: 20, width: 1024, height: 40)
            
            
        }
        
        
    }
    
    
    func updatePopUpContent(){
        self.titleEmissionLabel?.text = _selectedEmission?.emissionName
        self.title = _selectedEmission?.emissionCategoryName
        println("selected emission \(_selectedEmission)")
        
        
       // self.emissionCategoryLabel.text = _selectedEmission?.emissionCategoryName
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

    
    
    func displayPlayButton(canDisplayVideo:Bool){
        if (_melody._user != nil){
            println("Video detail abo mode")
            self.setAboMode()
            
        }
        else{
            println("Video detail non abo mode")

            self.setNonAboMode(canDisplayVideo)
            
        }
    }
    
    func setAboMode(){
        
        aboButton.hidden = true
        playTeaserVideoButton.hidden = true
        firstTryPicto.hidden = true
        //aboTextViewInformation.hidden = true
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
        //aboTextViewInformation.hidden = false
        playFullVideoButton.hidden = true
        
        publicationMobileLabel.hidden = true
        
        
        if (_selectedEmission?.publicationMobile == false){
            playFullVideoButton.hidden = true
            publicationMobileLabel.hidden = false
        }
    }
    
    
    @IBAction func nextAction(sender: AnyObject) {
        
        
        var vc : PopUpTVC
        var storyboard: UIStoryboard = UIStoryboard(name: "iPad", bundle: NSBundle(forClass: self.dynamicType))
        
        vc = storyboard.instantiateViewControllerWithIdentifier("popUpTVC") as! PopUpTVC
        
        
        self.navigationController?.pushViewController(vc, animated: true)
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

    func updateSeeAlseEmission(){
        
        for (index, emission) in enumerate(_seeAlsoEmissions){
        println("Emission \(emission.emissionName)")
            if(index < 4){
                titleEmissionLabels[index].text = emission.emissionName
             //   categoryEmissionLabels[index].text = emission.emissionCategoryName
                var urlString = emission.url_thumb_image
                
                thumbImageEmissions[index].layer.masksToBounds = true
                thumbImageEmissions[index].layer.cornerRadius = 5
                thumbImageEmissions[index].layer.borderColor = UIColor.blackColor().CGColor
                thumbImageEmissions[index].layer.borderWidth = 1
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
                                self.thumbImageEmissions[index].image = image

                            })
                        }
                        else {
                            println("Error: \(error.localizedDescription)")
                        }
                    })
                    
                }
                else {
                    thumbImageEmissions[index].image = emission.thumb_image
                    
                }
            }
          //  thumbImageEmissions[index]
            
            
        }

    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(hexString: "#F99000") //make the background color light blue
        header.textLabel.textColor = UIColor.whiteColor() //make the text white
         header.textLabel.font = UIFont(name: "TeXGyreAdventor-Bold", size: 15)

    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.section == 2){
            
            _melody._selectedEmission = _seeAlsoEmissions[indexPath.row]
            
            
            _melody._isTheFirstPopUp = true
            
            
            var vc : VideoTVC
            
            
            vc = _melody._storyboad!.instantiateViewControllerWithIdentifier("VideoTVC") as! VideoTVC
            
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }


}
