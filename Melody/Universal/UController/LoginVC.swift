//
//  LoginVC.swift
//  Melody.Tv
//
//  Created by Roger Ingouacka on 30/10/2014.
//  Copyright (c) 2014 Roger Ingouacka. All rights reserved.
//

import UIKit

import Foundation
import CoreData

class LoginVC: UIViewController,UITextFieldDelegate {

    var _melody : Melody = Melody.sharedInstance

    @IBOutlet var emailTextFIeld: UITextField!
    @IBOutlet var passTextField: UITextField!
    var mgr: Manager!
    let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage()
    
    @IBOutlet var loginView: UIView!
    var loginViewIsUp : Bool = false
    var kbHeight: CGFloat!

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        var tracker : GAITracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Page de connexion")
        tracker.send(GAIDictionaryBuilder.createAppView().build() as [NSObject : AnyObject])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
        NSNotificationCenter.defaultCenter()
       // mgr = configureManager()

        // Do any additional setup after loading the vi ew.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func cancelAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        emailTextFIeld.resignFirstResponder()
        passTextField.resignFirstResponder()
        self.startLoginRequest()
     //   setCookies()

    }
    @IBAction func signUpButtonPressed(sender: AnyObject) {
    }
    
 
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField.tag == 1){
            self.startLoginRequest()
            textField.resignFirstResponder()
        }
        return true
    }
    
    func startLoginRequest() {
    
        
        var url = "http://httpbin.org/get"
        var arr_parameters = [
            "foo": "bar"
        ]
        
        request(.GET, url, parameters: arr_parameters)
            .responseJSON { (req, res, json, error) in
                if(error != nil) {
                    NSLog("Error: \(error)")
                    println(req)
                    println(res)
                }
                else {
                    NSLog("Success: \(url)")
                    var json = JSON(json!)
                }
        }
        
        
        request(.GET,kMLDLoginRequest + emailTextFIeld.text + "/" + passTextField.text)
            .responseSwiftyJSON{(request, response, json, error) in
                
                if (error?.code > -2000)
                {
                    
                         println("No Internet connection \(json)")
                    
                }else{
                if (json["status"].boolValue == true){
                    
                    var user = json["results"]["User"]

                    println("Connexion succeed User \(user)")
                    
                    var entityUser : NSEntityDescription = NSEntityDescription.entityForName("User", inManagedObjectContext: self._melody._context)!
                    
                    
                    self._melody.createNewUserWithName(json["results"]["User"]["name"].stringValue, address: json["results"]["User"]["address"].stringValue, birthdate: json["results"]["User"]["birthdate"].stringValue, city: json["results"]["User"]["city"].stringValue, country: json["results"]["User"]["country"].stringValue, email: json["results"]["User"]["email"].stringValue, gender: json["results"]["User"]["gender"].stringValue, phone: json["results"]["User"]["phone"].stringValue, subscribed: json["results"]["User"]["subscribed"].stringValue, surname: json["results"]["User"]["surname"].stringValue,token: json["results"]["User"]["token"].stringValue)
                    

                    self._melody.clearLastUpdates()

                    
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("userConnected", object: nil, userInfo:nil)
                    
                    // SCLAlertView().showError(self, title: "Hello Error", subTitle: "This is a more descriptive error text.") // Error
                    var timer = NSTimer.scheduledTimerWithTimeInterval(6.0, target: self, selector: Selector("callAfter3Second"), userInfo: nil, repeats: false)
                  //  SCLAlertView().showSuccess(self, title: "Succès", subTitle: "La connexion à bien été effectuée") // Error
                    SCLAlertView().showSuccess("Succès", subTitle: "La connexion a bien été effectuée.", closeButtonTitle: "Fermer", duration: 6.0)
                }else{
                    println("Connexion failed")
                    
                    SCLAlertView().showError("Erreur", subTitle: "Impossible de se connecter, vérifiez votre e-mail et votre mot de passe.", closeButtonTitle: "Fermer", duration: 6.0)
                   // SCLAlertView().showError(self, title: "Hello Error", subTitle: "This is a more descriptive error text.") // Error
                    
                    /* */
                    
                }
            }
                
        }
    }
  
    
    
    
    func callAfter3Second(){
        self.emailTextFIeld.resignFirstResponder()
        self.passTextField.resignFirstResponder()

        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    @IBAction func leaveAction(sender: AnyObject) {
        self.emailTextFIeld.resignFirstResponder()
        self.passTextField.resignFirstResponder()
        
        self.dismissViewControllerAnimated(true, completion: nil)
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
