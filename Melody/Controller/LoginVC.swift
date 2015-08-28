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
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // mgr = configureManager()

        // Do any additional setup after loading the vi ew.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        }
        return true
    }
    
    func startLoginRequest() {
        request(.GET, "http://www.melody.tv/json-new/users/authenticate/\(emailTextFIeld.text)/\(passTextField.text)")
            .responseSwiftyJSON{(request, response, json, error) in
                
                if (error?.code > -2000)
                {
                    
                         println("No Internet connection")
                    
                }else{
                if (json["status"].boolValue == true){
                    println("JSON \(json)")
                    
                  //  println(self.cookies.cookiesForURL(NSURL(string: "http://www.Melody-hd.com/json/users/authenticate/\(self.emailTextFIeld.text)/\(self.passTextField.text)")!))

                   // self.checkCookies()

                    println("Connexion succeed")
                    
                    var entityUser : NSEntityDescription = NSEntityDescription.entityForName("User", inManagedObjectContext: self._melody._context)!
                    
                    
                    self._melody.createNewUserWithName(json["results"]["User"]["name"].stringValue, address: json["results"]["User"]["address"].stringValue, birthdate: json["results"]["User"]["birthdate"].stringValue, city: json["results"]["User"]["city"].stringValue, country: json["results"]["User"]["country"].stringValue, email: json["results"]["User"]["email"].stringValue, gender: json["results"]["User"]["gender"].stringValue, phone: json["results"]["User"]["phone"].stringValue, subscribed: json["results"]["User"]["subscribed"].stringValue, surname: json["results"]["User"]["surname"].stringValue,token: json["results"]["User"]["token"].stringValue)
                    

                    self._melody.clearLastUpdates()

                    
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("userConnected", object: nil, userInfo:nil)
                    
                    // SCLAlertView().showError(self, title: "Hello Error", subTitle: "This is a more descriptive error text.") // Error
                    var timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("callAfter3Second"), userInfo: nil, repeats: false)
                    SCLAlertView().showSuccess(self, title: "Succès", subTitle: "La connexion à bien été effectuée") // Error
                    
                }else{
                    println("Connexion failed")
                    
                    SCLAlertView().showError(self, title: "Erreur", subTitle: "Impossible de se connecter, verifier votre nom d'utilisateur et votre mot de passe.") // Error
                    
                }
            }
                
        }
    }
  
    
    
    
    func callAfter3Second(){
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
