//
//  ActuVC.swift
//  Melody
//
//  Created by Roger Ingouacka on 16/01/2015.
//
//

import UIKit

class ActuVC: UIViewController {

    var _melody : Melody = Melody.sharedInstance

    @IBOutlet var titleActuLabel: UILabel!
    @IBOutlet var thumbImage: UIImageView!
    @IBOutlet var diffusionDateLabel: UILabel!
    @IBOutlet var descriptionWebView: UIWebView!
  
    @IBOutlet var copyrightLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem =  UIBarButtonItem(title: "Actualités musicales", style: .Plain, target: self, action:nil)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if ((_melody._selectedEmission!.thumb_image ) == nil  && !_melody._selectedEmission!.url_thumb_image.isEmpty ){
            self.downloadImage()
        }
        else if ((_melody._selectedEmission!.thumb_image ) != nil){
            self.thumbImage.image = self._melody._selectedEmission!.thumb_image
            
        }
        else{
            self.thumbImage.image = UIImage(contentsOfFile: "melody_cover")
        }
        
        self.loadInformation()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadInformation(){
        //  self.title = _melody._selectedEmission?.emissionName
        self.titleActuLabel.text = _melody._selectedEmission?.emissionName
        self.diffusionDateLabel.text =  _melody._selectedEmission!.publication!.actuPublicationString()
       // println("Description \(_melody._selectedEmission!.emissionDescription)")
        
        
        
        self.descriptionWebView.loadHTMLString(_melody._selectedEmission?.emissionDescription, baseURL: nil)
        self.copyrightLabel.text = _melody._selectedEmission?.emissionCategoryName


    }
    func downloadImage(){
        var imgUrl: NSURL = NSURL(string: _melody._selectedEmission!.url_thumb_image)!
        
        // Download an NSData representation of the image at the URL
        let request: NSURLRequest = NSURLRequest(URL: imgUrl)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
            if error == nil {
                
                self._melody._selectedEmission!.thumb_image =  UIImage(data: data)
                self.thumbImage.image = self._melody._selectedEmission?.thumb_image
                
            }
            else {
                println("Error: \(error.localizedDescription)")
            }
        })
    }

    
}
