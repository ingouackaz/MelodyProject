//
//  ActuTVC.swift
//  Melody
//
//  Created by Roger Ingouacka on 24/02/2015.
//
//

import UIKit

class ActuTVC: UITableViewController, UIWebViewDelegate {


    var _melody : Melody = Melody.sharedInstance

    
    @IBOutlet var titleActuLabel: UILabel!
    @IBOutlet var thumbImage: UIImageView!
    @IBOutlet var diffusionDateLabel: UILabel!
    @IBOutlet var descriptionWebView: UIWebView!
    
    @IBOutlet var copyrightLabel: UILabel!
    
    
    var _webViewHeight : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

    descriptionWebView.clipsToBounds = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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

    
    
    // MARK: - Table view data source

override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if (indexPath.row == 0){
        return 260
    }
    else{
        println("Height row \(_webViewHeight)")
        descriptionWebView.frame.size.height = _webViewHeight
        
        
        return _webViewHeight
        

    }

    }
    
    func webViewDidFinishLoad(webView : UIWebView) {
        //UIApplication.sharedApplication().networkActivityIndicatorVisible = false

        self.tableView.beginUpdates()
        
        
        var frame  : CGRect = webView.frame
        frame.size.height = 1
        webView.frame = frame
         var fittingSize : CGSize = webView.sizeThatFits(CGSizeZero)
        fittingSize.height += 25
        descriptionWebView.frame.size = fittingSize
        
        _webViewHeight = fittingSize.height
        self.tableView.endUpdates()

        descriptionWebView.frame.size = fittingSize


    }

    
    func loadInformation(){
        //  self.title = _melody._selectedEmission?.emissionName
        self.titleActuLabel.text = _melody._selectedEmission?.emissionName
        self.diffusionDateLabel.text =  _melody._selectedEmission!.publication!.actuPublicationString()
        // println("Description \(_melody._selectedEmission!.emissionDescription)")
          _melody._selectedEmission?.emissionDescription = _melody._selectedEmission!.emissionDescription.stringByReplacingOccurrencesOfString("\n", withString: "<br>", options: nil, range: nil)
         _melody._selectedEmission?.emissionDescription = _melody._selectedEmission!.emissionDescription.stringByReplacingOccurrencesOfString("\t", withString: "&nbsp", options: nil, range: nil)
        
        //<br>
        // _melody._selectedEmission?.emissionDescription = _melody._selectedEmission!.emissionDescription.replace("height=\"\\d+\"", template: "")
        
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
