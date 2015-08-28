//
//  CompteVC.swift
//  Melody
//
//  Created by Roger Ingouacka on 11/12/14.
//
//

import UIKit
import StoreKit



class CompteVC: UIViewController, SKPaymentTransactionObserver , SlideNavigationControllerDelegate{

    var _melody : Melody = Melody.sharedInstance

    
    @IBOutlet var viewAboPhone: UIView!
    @IBOutlet var viewAboMulti: UIView!
    @IBOutlet var viewAboPromo: UIView!
    var kbHeight: CGFloat!

    
    
    


    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)

        if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone){
            
            self.loadIphoneView()
        }else
        {
            self.loadiPadView()
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var tracker : GAITracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Page d'Abonnement")
        tracker.send(GAIDictionaryBuilder.createAppView().build() as [NSObject : AnyObject])
        
        
        if(_melody._user == nil){
            self.nonAboMode()
        }
        else{
            self.aboMode()
        }

    }


    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return true
    }
    
    func slideNavigationControllerShouldDisplayRightMenu() -> Bool {
        return false
    }
    func loadIphoneView(){
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
        
    }
    
    func loadiPadView(){
        self.navigationController?.navigationBarHidden = true
        self.navigationController?.navigationBar.tintColor = UIColor.clearColor()
    }
    
    @IBAction func restoreAction(sender: AnyObject) {
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        PFPurchase.restore()

        println("restore called")

    }
    
    

    func paymentQueue(queue: SKPaymentQueue!, removedTransactions transactions: [AnyObject]!) {
        
    }
    
    func paymentQueue(queue: SKPaymentQueue!, restoreCompletedTransactionsFailedWithError error: NSError!) {
        
    }
    

    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
        println("updated transaction \(transactions)")
        
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue!) {
        
        println("Count restore \(queue.transactions.count)")
    }
    
    func aboMode(){
        viewAboPhone.hidden = true
        viewAboMulti.hidden = true
        viewAboPromo.hidden = false
    }
    
    func nonAboMode(){
  
        viewAboPhone.hidden = false
        viewAboMulti.hidden = false
        viewAboPromo.hidden = true

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
                        
                        //println("alerte creation")
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
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }




}
