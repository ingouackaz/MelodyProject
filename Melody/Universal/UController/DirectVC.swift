//
//  DirectVC.swift
//  Melody
//
//  Created by Roger Ingouacka on 16/12/14.
//
//

import UIKit
import Foundation
import CoreData
import MediaPlayer


class DirectVC: UIViewController, SlideNavigationControllerDelegate {

    var _isFullScreen : Bool = false

    
    var _playerVC : MPMoviePlayerController?
    var _melody : Melody = Melody.sharedInstance
    var _urlVideo : NSURL?
    var _streamUrlFetched : Bool = false
    @IBOutlet weak var aboButton: UIButton!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var freeMonthImage: UIImageView!
    @IBOutlet weak var aboDirectLabel: UILabel!

    @IBOutlet var fullScreenButton: UIButton!
    
   
    @IBOutlet weak var descriptionTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]

      //  NSNotificationCenter.defaultCenter().addObserver(self, selector:"movieFinishedCallback:", name:MPMoviePlayerPlaybackDidFinishNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"enterFullScreen:", name:MPMoviePlayerWillEnterFullscreenNotification, object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector:"exitFullScreen:", name:MPMoviePlayerWillExitFullscreenNotification, object: nil)

        self.initMoviePlayer()
        
        if(_melody._user == nil){
            println("No user connected")

            self.nonAboMode()
        }
        else{
            println("User \(_melody._user!.name) connected")
            self.aboMode()
            
            
        }
        self.view.backgroundColor = UIColor(hexString: "#E8E8E8")
        // Do any additional setup after loading the view.
    }
    
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return true
    }
    
    func slideNavigationControllerShouldDisplayRightMenu() -> Bool {
        return false
    }

    func menuClose(notification : NSNotification){
        
        if(_melody._user == nil){
            self.nonAboMode()
        }
        else{
            self.aboMode()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttAction(sender: AnyObject) {
        SCLAlertView().showError("Erreur", subTitle: "Impossible de se connecter, vérifiez votre e-mail et votre mot de passe.", closeButtonTitle: "Fermer", duration: 6.0)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var tracker : GAITracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Page de Direct")
        tracker.send(GAIDictionaryBuilder.createAppView().build() as [NSObject : AnyObject])
        
        
        if(_melody._user == nil){
          //  println("No user connected")

            self.nonAboMode()
        }
        else{
          //  println("User \(_melody._user!.name) connected")

            self.aboMode()
        }
        
        
    }
    

    func initMoviePlayer(){
        _playerVC  = MPMoviePlayerController()
        _playerVC?.controlStyle = MPMovieControlStyle.Embedded
        
        NSNotificationCenter.defaultCenter().removeObserver(_playerVC!, name:MPMoviePlayerPlaybackDidFinishNotification, object: _playerVC)
        

        
        _playerVC!.view.frame = playerView.frame
        
        _playerVC!.prepareToPlay()
        
        self.view.addSubview(_playerVC!.view)
        playerView.hidden = true
 
    }
  
    
 
    
    
    func movieFinishedCallback(notification : NSNotification){
        
        var finishReason : NSNumber = notification.userInfo![MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] as! NSNumber
        
        if (finishReason.integerValue != MPMovieFinishReason.PlaybackEnded.rawValue){
            _melody._videoIsFullScreen =  false

            
            self.dismissViewControllerAnimated(true, completion: nil)
            
            let delay = 1.5 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue(), { () -> Void in
                
                UIApplication.sharedApplication().statusBarHidden = false
            })
 
        }
        
        
    }
    
    func enterFullScreen(notification : NSNotification){
        _melody._videoIsFullScreen =  true

    }
    
    func exitFullScreen(notification : NSNotification){
        _melody._videoIsFullScreen =  false
    }
    
    func iPadMode(){
        descriptionTextView.text = "La vidéo proposée ci-dessus est la bande-annonce du mois. Pour voir le direct de la chaîne Melody vous devez être abonné(e); Vous accéderez en plus, en illimité, à tous nos programmes disponibles à la demande ( Variétés, Concerts...)."
        descriptionTextView.textAlignment = NSTextAlignment.Center
        descriptionTextView.font = UIFont(name: "TeXGyreAdventor-Regular", size: 13)
    }
    
    func iPhoneMode(){
      //  playerView.hidden = true
        //self.view.addSubview(_playerVC!.view)
        self.fullScreenButton.hidden = true
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu-button.png"), style: UIBarButtonItemStyle.Plain, target: self, action: "")
        self.descriptionTextView.text = "La vidéo proposée ci-dessus est la bande-annonce du mois. Pour voir le direct de la chaîne Melody vous devez être abonné(e); Vous accéderez en plus, en illimité, à tous nos programmes disponibles à la demande ( Variétés, Concerts...)."
        self.descriptionTextView.textAlignment = NSTextAlignment.Center
        
       self.descriptionTextView.font = UIFont(name: "TeXGyreAdventor-Regular", size: 14)
        _playerVC!.controlStyle = MPMovieControlStyle.None
        _playerVC!.play()
    }
    
    func nonAboMode(){
        
        self.aboButton.hidden = false
        self.freeMonthImage.hidden = false
        self.aboDirectLabel.hidden = true
        self.descriptionTextView.hidden = false

        _urlVideo = NSURL(string:"http://www.melody.tv/images/stories/showcase/applis/bande-annonce.mp4")!
        _playerVC!.movieSourceType = MPMovieSourceType.File

        _playerVC!.contentURL = _urlVideo
        if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone){
            
            self.iPhoneMode()
        }
        else{
            self.iPadMode()
        }
        

    }

    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //self._playerVC!.stop()

    }
    
    func aboMode(){
        aboButton.hidden = true
        self.freeMonthImage.hidden = true
        self.aboDirectLabel.hidden = false

        self.descriptionTextView.hidden = true
        descriptionTextView.text = "Vous regardez la chaîne Melody en direct."
        //descriptionTextView.textAlignment = NSTextAlignment.Center
        descriptionTextView.font = UIFont(name: "TeXGyreAdventor-Regular", size: 13)
        
        println("MSM CoreData \(self._melody._msmCoreData.streamUrl )")
    
        if (self._melody._msmCoreData.streamUrl.isEmpty == true){
            self.startGetDirectStreamRequest()

        }
        else{
            self._playerVC!.stop()
            self._playerVC!.movieSourceType = MPMovieSourceType.Unknown
            self._playerVC!.controlStyle = MPMovieControlStyle.Embedded
            self._playerVC!.contentURL = NSURL(string: self._melody._msmCoreData.streamUrl)
            
            //xprintln("url video \(_urlVideo) && coredt \(self._melody._msmCoreData.streamUrl)")
            self._playerVC!.play()
        }
        if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone){
            self.fullScreenButton.hidden = false

        }
    }
    
    func playTeaser(){
    
    }
    
    @IBAction func playInFullScreenAction(sender: AnyObject) {
        
        var playerVC : MPMoviePlayerViewController = MPMoviePlayerViewController(contentURL: _urlVideo)
        
        
        NSNotificationCenter.defaultCenter().removeObserver(playerVC, name:MPMoviePlayerPlaybackDidFinishNotification, object: playerVC.moviePlayer)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"movieFinishedCallback:", name:MPMoviePlayerPlaybackDidFinishNotification, object: nil)
        
        
        
        
        playerVC.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        _melody._videoIsFullScreen =  true
        self.presentViewController(playerVC, animated: true, completion: nil)
        playerVC.moviePlayer.prepareToPlay()
        playerVC.moviePlayer.play()
        
        

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
    
    func startGetDirectStreamRequest(){
        
        //   self._melody.displayLoadingView(self.view)
        // _playerVC!.moviePlayer.pause()
        var str =  kMLDStreamUrl + "&token=" +  _melody._userToken
        println("START Direct Request \(str)")
        request(.GET,kMLDStreamUrl + "&token=" +  _melody._userToken)
            .responseSwiftyJSON{(request, response, json, error) in
                if (error?.code > -2000)
                {
                    
                    //println("No Internet connection")
                }
                else{
                    // Ajoute un print avant sinon playgr9und renvoie 0 -> bug
                    println("  JSON DIRECT \(json)")
                    
                    self._urlVideo = NSURL(string:json["results"]["stream"]["url"].stringValue)
                  //  println("Before Print")
                    
                    self._melody._msmCoreData.streamUrl = json["results"]["stream"]["url"].stringValue
                   // println("URL \(self._urlVideo)")
                    
                    self._streamUrlFetched = true
                    self._playerVC!.stop()
                    self._playerVC!.movieSourceType = MPMovieSourceType.Unknown
                    self._playerVC!.controlStyle = MPMovieControlStyle.None
                    self._playerVC!.contentURL = self._urlVideo!
                    if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone){
                        //self._playerVC!.controlStyle = MPMovieControlStyle.None
                        self.fullScreenButton.hidden = false
                    }
                    self._playerVC!.play()
                    
                    
                    // self.getMuseumItems(json)
                    // self._loadingHUD.hide(false)
                    //self._museum._context.save(nil)
                }
                
                // self._melody.hideLoadingView()
                
        }
        
    }

    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().statusBarHidden = false

            //  _playerVC!.moviePlayer.play()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
