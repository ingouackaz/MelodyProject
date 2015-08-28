//
//  PageTutoVC.swift
//  Melody
//
//  Created by Roger Ingouacka on 09/02/2015.
//
//

import UIKit

class PageTutoVC: UIViewController {
    var _melody : Melody = Melody.sharedInstance

    var pageIndex : Int = 0
    var titleText : String = ""
    var imageFile : String = ""
    
    var currentImage : UIImage = UIImage()
    
    
    @IBOutlet var backgroundImage: UIImageView!
    
    @IBOutlet var goApplicationButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if(pageIndex == 2){
            goApplicationButton.hidden = false
        }
        else{
            goApplicationButton.hidden = true

        }
        backgroundImage.image = currentImage
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goToApplication(sender: AnyObject) {
        self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
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
