 //
//  AppDelegate.swift
//  Melody
//
//  Created by Roger Ingouacka on 26/11/14.
//
//

import UIKit
import CoreData
import MediaPlayer
 import StoreKit

 
 
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SKPaymentTransactionObserver {

    var window: UIWindow?
    var _isFullScreen : Bool = false

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        
        
        var _melody : Melody = Melody.sharedInstance

        self.initializeStoryBoardBasedOnScreenSize()
        
        
        self.rateTheApplication()
        
        
        self.restoreAction()
        let font = UIFont(name: "HelveticaNeue-Light", size:12.0)!

        

        
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName:font,NSForegroundColorAttributeName:UIColor.whiteColor()], forState: UIControlState.Selected)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName:font,NSForegroundColorAttributeName:UIColor.blackColor()], forState: UIControlState.Normal)
      
        
        UITabBarItem.appearance().setTitlePositionAdjustment(UIOffsetMake(0.2, -0.1))
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        GAI.sharedInstance().trackUncaughtExceptions = true
        GAI.sharedInstance().logger.logLevel =  GAILogLevel.Verbose
        GAI.sharedInstance().dispatchInterval = 20
        
        var tracker : GAITracker = GAI.sharedInstance().trackerWithTrackingId("UA-59525926-1")
        
       // PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)

        Parse.setApplicationId("bRTvGfr6wSuNSl9HvkZroYqkGHiAfu42FGgNBTge", clientKey: "N33QHlb29kGSjwvnXE4U4qp31qeaMvbvXTIFqBX6")

        
        PFUser.enableAutomaticUser()
        
        var defaultACL:PFACL = PFACL()
        defaultACL.setPublicReadAccess(true)
        PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser: true)
        
        var installation : PFInstallation = PFInstallation.currentInstallation()
        installation.setValue("fr", forKey: "Language")
        installation.saveInBackgroundWithBlock(nil)
        
        var version:NSString = UIDevice.currentDevice().systemVersion as NSString;
        if  version.doubleValue >= 8 {
            // ios 8 code
            var notificationSettings : UIUserNotificationSettings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Sound, categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
            
        }
        else{
            UIApplication.sharedApplication().registerForRemoteNotificationTypes(UIRemoteNotificationType.Alert  | UIRemoteNotificationType.Sound)
        }
        
        
        if(_melody._user == nil){
            
            println("Aucun utilisateur n'est enregistré")

            PFPurchase.addObserverForProduct("AboMensuel", block: { (transcation:SKPaymentTransaction!) -> Void in
                
                println("Acheté !!!")
                
                let userDefaults = NSUserDefaults.standardUserDefaults()
                
                userDefaults.setBool(true, forKey: "proUser")
                
                userDefaults.synchronize()
                
                var _melody : Melody = Melody.sharedInstance
                
                _melody.autoLoginAboMode()
                // self.autoLoginAboMode()
            })
        }else {
            
            println("Un utilisateur est déjà connecté")
        }
        return true
    }
    
    
    
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> Int {
      
        var _melody : Melody = Melody.sharedInstance
        
        if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone ){
            println("isFullscreen \(_melody._videoIsFullScreen)")
            
            if(_melody._videoIsFullScreen == true){
                return Int(UIInterfaceOrientationMask.Landscape.rawValue)
                
            }
            else{
                return Int(UIInterfaceOrientationMask.Portrait.rawValue)
            }
            
        }
        else{
            return Int(UIInterfaceOrientationMask.Landscape.rawValue)
        }
    }



     func restoreAction() {
        
        var melody : Melody = Melody.sharedInstance

        
        if (melody._user != nil && melody._user!.email == "applis@melody.tv"){
            SKPaymentQueue.defaultQueue().addTransactionObserver(self)
            PFPurchase.restore()
        }
        
        println("restore called")
        
    }
    
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
        println("updated transaction \(transactions)")
        
    }

    
    func paymentQueue(queue: SKPaymentQueue!, restoreCompletedTransactionsFailedWithError error: NSError!) {
          NSNotificationCenter.defaultCenter().postNotificationName("userDisconnectedNofication", object: nil, userInfo:nil)
    }
    
    
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue!) {
        var melody : Melody = Melody.sharedInstance

        println("Count restore \(queue.transactions.count)")
        if(queue.transactions.count == 0 && melody._user != nil){
        
            if (melody._user!.email == "applis@melody.tv"){
                NSNotificationCenter.defaultCenter().postNotificationName("userDisconnectedNofication", object: nil, userInfo:nil)
               // melody.clearUser()
            }
            //
        }
    }
    
    
    func rateTheApplication(){
    
        Appirater.setAppId("605365404")
        Appirater.setDaysUntilPrompt(0)
        Appirater.setUsesUntilPrompt(8)
        Appirater.setTimeBeforeReminding(8)
        Appirater.appLaunched(true)

    }
    func initializeStoryBoardBasedOnScreenSize(){
        var storyboad : UIStoryboard = UIStoryboard(name: "iPhoneAll", bundle: nil)
        var _melody : Melody = Melody.sharedInstance

        if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone){
            
            // initialize slidemenu
            
            var storyboad : UIStoryboard = UIStoryboard(name: "iPhoneAll", bundle: nil)            
            
            _melody._storyboad = storyboad
            
            var initialVC : UIViewController = storyboad.instantiateInitialViewController() as! UIViewController
            
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            self.window?.rootViewController = initialVC
            self.window?.makeKeyAndVisible()
            
            self.initSlideMenu(storyboad)

        }
        else {
            var iOSDeviceScreenSize : CGSize = UIScreen.mainScreen().bounds.size

            println("IOS Device screensize \(iOSDeviceScreenSize)")

            var storyboad : UIStoryboard = UIStoryboard(name: "iPad", bundle: nil)
            var initialVC : UIViewController = storyboad.instantiateInitialViewController() as! UIViewController
            
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            self.window?.rootViewController = initialVC
            self.window?.makeKeyAndVisible()
        }
        
       

    }
    
    
    func initSlideMenu(storyboard:UIStoryboard){

        
        var leftMenu : MenuVc = storyboard.instantiateViewControllerWithIdentifier("MenuVC") as! MenuVc
        

        leftMenu.observeNotification()
        SlideNavigationController.sharedInstance().leftMenu = leftMenu
        SlideNavigationController.sharedInstance().avoidSwitchingToSameClassViewController = false

    }
    
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        
        Appirater.appEnteredForeground(true)
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        
    }
    
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        PFPush.handlePush(userInfo)
        
        
        if (application.applicationState == UIApplicationState.Inactive) {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayloadInBackground(userInfo, block:nil)
        }
    }
    
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        PFPush.storeDeviceToken(deviceToken)
        PFPush.subscribeToChannelInBackground("", target: self, selector: "subscribeFinished:error:")
        
        
        var characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        
        var deviceTokenString: String = ( deviceToken.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        
        println( " Device Token \(deviceTokenString) ")
    }
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.Melody" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Melody", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Melody.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict as [NSObject : AnyObject])
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }

}

