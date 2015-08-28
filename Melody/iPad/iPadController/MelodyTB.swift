//
//  MuseumTB.swift
//  Melody.Tv
//
//  Created by Roger Ingouacka on 28/10/2014.
//  Copyright (c) 2014 Roger Ingouacka. All rights reserved.
//

import UIKit

class MelodyTB: UITabBarController,UITabBarControllerDelegate, UIActionSheetDelegate {

    var _melody : Melody = Melody.sharedInstance
    var _selectedImages  = [UIImage(named: "home-off")!,UIImage(named: "actualites-off")!,UIImage(named: "direct-off")!,UIImage(named: "grille-off")!,UIImage(named: "vod-off")!,UIImage(named: "replay-of")!,UIImage(named: "compte-off")!]

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = UIColor(hexString: "#FD7205")
        self.tabBar.tintColor = UIColor.whiteColor()
        
        var reach : Reachability = Reachability(hostName: "www.google.com")

        
        self.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"userConnectedNofication:", name: "userConnected", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"userDisconnectedNofication:", name: "userDisconnectedNofication", object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector:"reachabilityChanged:", name:kReachabilityChangedNotification, object: nil)

        
        
        // Tell the reachability that we DON'T want to be reachable on 3G/EDGE/CDMA
        reach.reachableOnWWAN = false
        reach.startNotifier()
        // Here we set up a NSNotification observer. The Reachability that caused the notification
        // is passed in the object parameter;
        
        var i : Int = 0
        for item in self.tabBar.items as! [UITabBarItem] {
            //item.
            
            item.image = _selectedImages[i].imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            item.selectedImage =  _selectedImages[i]
            i++
                //UIImage(
        }

        
        
        

        if(_melody._user != nil){
             self.setAboMode()
        }
        

    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        println("Selected \(item.title)")
        
        
    }


    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex{
            
        case 0:
            
            NSNotificationCenter.defaultCenter().postNotificationName("userDisconnected", object: nil, userInfo:nil)

            break;
        case 1:
            NSLog("Default");
        default:
            NSLog("Default");
            break;
        }
    }
    
    
    

    
    func userConnectedNofication(notification : NSNotification){
        
        
        println("User vient de se connecter")
        // lancer une requête qui vérifie chaque jour si l'utilisateur est toujours abonné
        
        if (notification.name == "userConnected"){
            self.selectedIndex = 0
            self._melody.clearLastUpdates()
            self.setAboMode()
            
        }
        
    }
    
    func userDisconnectedNofication(notification : NSNotification){
        if (notification.name == "userDisconnectedNoficationsl"){
            println("User vient de se déconnecter")
            self.selectedIndex = 0
            self._melody.clearUser()
            self.setUnAboMode()
        }
    }
    

    func reachabilityChanged(notification : NSNotification){
    
         var reach : Reachability = notification.object as! Reachability
        var status : NetworkStatus = reach.currentReachabilityStatus()
        if (status != NetworkStatus.ReachableViaWiFi && status != NetworkStatus.ReachableViaWWAN){

            println("NO INTERNET CONNECTION")
            var storyboard: UIStoryboard = UIStoryboard(name: "iPad", bundle: NSBundle(forClass: self.dynamicType))
            
            var vc = storyboard.instantiateViewControllerWithIdentifier("noInternet") as! UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
            
        }
        else{
            self.dismissViewControllerAnimated(true, completion: nil)

        }
        
    }
    
    
    func setAboMode(){
        self.selectedIndex = 0
        // clear lastUpdate
        
        var accountTab : UITabBarItem = self.tabBar.items![6] as! UITabBarItem

        
        accountTab.image =  UIImage(named: "compte-co-off")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)

        accountTab.selectedImage = UIImage(named: "compte-co")!
        // accountTab.image = UIImage(named: "")
        accountTab.title = "Connecté"
        
        _melody._msmCoreData.clearLastUpdate()
    }
    
    func setUnAboMode(){
        self.selectedIndex = 0
        var accountTab : UITabBarItem = self.tabBar.items![6] as! UITabBarItem
        // accountTab.image = UIImage(named: "")
        accountTab.title = "Compte"
        
        _melody._msmCoreData.clearLastUpdate()

    }
    
 

}
