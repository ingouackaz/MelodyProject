//
//  ActuPopUpTVC.swift
//  Melody
//
//  Created by Roger Ingouacka on 08/01/2015.
//
//

import UIKit

class ActuPopUpTVC: UITableViewController, UIWebViewDelegate {

    var _melody : Melody = Melody.sharedInstance

    
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var copyrightLabel: UILabel!
    @IBOutlet weak var descriptionWebView: UIWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var startDayLabel: UILabel!
    
    var _webViewHeight : CGFloat = 0

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        var err: NSError?
        
        
        var controller : MZFormSheetController = self.navigationController!.formSheetController
        controller.shouldDismissOnBackgroundViewTap = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var tracker : GAITracker = GAI.sharedInstance().defaultTracker
        
        tracker.set(kGAIScreenName, value: "Pop Up actualité - " + _melody._selectedEmission!.emissionName)
        
        tracker.send(GAIDictionaryBuilder.createAppView().build() as [NSObject : AnyObject])
        if ((_melody._selectedEmission!.thumb_image ) == nil  && !_melody._selectedEmission!.url_thumb_image.isEmpty ){
            self.downloadImage()
        }
        else if ((_melody._selectedEmission!.thumb_image ) != nil){
            self.thumbImage.image = self._melody._selectedEmission!.thumb_image
            
        }
        else{
            self.thumbImage.image = UIImage(contentsOfFile: "melody_cover")
        }
        
        self.updatePopUpContent()
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 0){
            return 270
        }
        else{
            println("Height row \(_webViewHeight)")
            descriptionWebView.frame.size.height = _webViewHeight
                        
            return _webViewHeight
            
        }
        
    }
    
    func webViewDidFinishLoad(webView : UIWebView) {
        //UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        
        var frame  : CGRect = webView.frame
        frame.size.height = 1
        webView.frame = frame
        var fittingSize : CGSize = webView.sizeThatFits(CGSizeZero)
        fittingSize.height += 25
        descriptionWebView.frame.size = fittingSize
        
        _webViewHeight = fittingSize.height
        println("#Height webView \(webView.scrollView.contentSize.height)")
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        descriptionWebView.frame.size = fittingSize
        
    }

    
    func updatePopUpContent(){
        

        self.titleLabel.text = _melody._selectedEmission?.emissionName
        self.startDayLabel.text =  _melody._selectedEmission!.publication!.actuPublicationString()
        
        _melody._selectedEmission?.emissionDescription = _melody._selectedEmission!.emissionDescription.stringByReplacingOccurrencesOfString("\n", withString: "<br>", options: nil, range: nil)
        _melody._selectedEmission?.emissionDescription = _melody._selectedEmission!.emissionDescription.stringByReplacingOccurrencesOfString("\t", withString: "&nbsp", options: nil, range: nil)
        self.descriptionWebView.loadHTMLString(_melody._selectedEmission?.emissionDescription, baseURL: nil)
        self.copyrightLabel.text = _melody._selectedEmission?.emissionCategoryName
    }
    

    
    @IBAction func closePopUpAction(sender: AnyObject) {
        self.mz_dismissFormSheetControllerAnimated(true, completionHandler: nil)

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
    

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data sourc
}
