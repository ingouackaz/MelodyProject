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


class DirectVC: UIViewController {

    
    
    var _playerVC : MPMoviePlayerController?
    var _melody : Melody = Melody.sharedInstance
    var _urlVideo : NSURL?
    var _streamUrlFetched : Bool = false
    @IBOutlet weak var aboButton: UIButton!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var freeMonthImage: UIImageView!

    @IBOutlet weak var descriptionTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if(_melody._user == nil){
            println("No user connected")

            self.nonAboMode()
        }
        else{
            println("User \(_melody._user!.name) connected")

            self.aboMode()
        }
    }
    
    func initMoviePlayer(){
        _playerVC  = MPMoviePlayerController()
        _playerVC?.controlStyle = MPMovieControlStyle.Embedded
        
        NSNotificationCenter.defaultCenter().removeObserver(_playerVC!, name:MPMoviePlayerPlaybackDidFinishNotification, object: _playerVC)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"moviePlayerWillExitFullScreen:", name:MPMoviePlayerWillExitFullscreenNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"moviePlayerDidEnterFullScreen:", name:MPMoviePlayerWillEnterFullscreenNotification, object: nil)
        
        _playerVC!.view.frame = playerView.frame
        self.navigationController?.navigationBar.tintColor = UIColor.clearColor()
        
        //println("Frame \(playerView.frame)")
        _playerVC!.prepareToPlay()
        
        playerView.addSubview(_playerVC!.view)
        
 
    }
    func iPhoneMode(){
        descriptionTextView.text = "La vidéo proposée ci-dessus est la bande-annonce du mois."
        descriptionTextView.font = UIFont(name: "TeXGyreAdventor-Regular", size: 15)
    }
    
    func iPadMode(){
        descriptionTextView.text = "La vidéo proposée ci-dessus est la bande-annonce du mois. Pour voir le direct de la chaine Melody vous devez être abonné(e); Vous accéderez en plus, en illimité, à tous nos programmes disponibles à la demande ( Variétés, Concerts )"
        descriptionTextView.textAlignment = NSTextAlignment.Center
        descriptionTextView.font = UIFont(name: "TeXGyreAdventor-Regular", size: 15)
    }
    
    func nonAboMode(){
        
        self.aboButton.hidden = false
        self.freeMonthImage.hidden = false
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
    
    func aboMode(){
        aboButton.hidden = true
        self.freeMonthImage.hidden = true


         descriptionTextView.text = "Vous regardez la chaine Melody en direct"
        descriptionTextView.textAlignment = NSTextAlignment.Center
        descriptionTextView.font = UIFont(name: "TeXGyreAdventor-Regular", size: 15)
        
        println("MSM CoreData \(self._melody._msmCoreData.streamUrl )")
    
        if (self._melody._msmCoreData.streamUrl.isEmpty == true){
            self.startGetDirectStreamRequest()

        }
        else{
            self._playerVC!.stop()
            self._playerVC!.movieSourceType = MPMovieSourceType.Unknown
            self._playerVC!.controlStyle = MPMovieControlStyle.Embedded
            self._playerVC!.contentURL = self._urlVideo!
            
            self._playerVC!.play()
        }
    }
    
    @IBAction func aboAction(sender: AnyObject) {
        self._melody.displayLoadingView(self.view)
        
        if( _melody._pfPurchaseInProgress == false){
            _melody._pfPurchaseInProgress = true
            
            
            PFPurchase.buyProduct("abonnement1mois", block: { (error:NSError?) -> Void in
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
        println("START REQUEST")
        request(.GET, _melody._getStreamUrl + "?token=xxxxx" +  _melody._userToken)
            .responseSwiftyJSON{(request, response, json, error) in
                if (error?.code > -2000)
                {
                    
                    //println("No Internet connection")
                }
                else{
                    // Ajoute un print avant sinon playgr9und renvoie 0 -> bug
                    println(" MELODY CONTENT JSON \(json)")
                    
                    self._urlVideo = NSURL(string:json["results"]["stream"]["url"].stringValue)
                    println("Before Print")
                    
                    self._melody._msmCoreData.streamUrl = json["results"]["stream"]["url"].stringValue
                    println("URL \(self._urlVideo)")
                    
                    self._streamUrlFetched = true
                    self._playerVC!.stop()
                    self._playerVC!.movieSourceType = MPMovieSourceType.Unknown
                    self._playerVC!.controlStyle = MPMovieControlStyle.Embedded
                    self._playerVC!.contentURL = self._urlVideo!
                    
                    self._playerVC!.play()
                    
                    
                    // self.getMuseumItems(json)
                    // self._loadingHUD.hide(false)
                    //self._museum._context.save(nil)
                }
                
                // self._melody.hideLoadingView()
                
        }
        
    }
    
    func movieFinishedCallback(notification : NSNotification){
        println("DONE")
        
    }
    
    func moviePlayerWillExitFullScreen(notification : NSNotification){
        // self.navigationController!.navigationBar.hidden = false
        //self._playerVC?.moviePlayer.controlStyle = MPMovieControlStyle.Embedded

    }
    
    func moviePlayerDidEnterFullScreen(notification : NSNotification){
        //self._playerVC?.moviePlayer.controlStyle = MPMovieControlStyle.Fullscreen

        //  self.navigationController!.navigationBar.hidden = true
        
    }

    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
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
