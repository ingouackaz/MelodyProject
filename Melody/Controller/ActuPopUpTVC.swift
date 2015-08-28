//
//  ActuPopUpTVC.swift
//  Melody
//
//  Created by Roger Ingouacka on 08/01/2015.
//
//

import UIKit

class ActuPopUpTVC: UITableViewController {

    var _melody : Melody = Melody.sharedInstance

    
    @IBOutlet var copyrightLabel: UILabel!
    @IBOutlet weak var descriptionWebView: UIWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var startDayLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        var err: NSError?
        
        
        var controller : MZFormSheetController = self.navigationController!.formSheetController
        controller.shouldDismissOnBackgroundViewTap = true
    }

    func updatePopUpContent(){
        //  self.title = _melody._selectedEmission?.emissionName
     //   self.titleLabel.text = _melody._selectedEmission?.emissionName
        self.startDayLabel.text =  "Le " + _melody._selectedEmission!.publication!.actuPublicationString()
        self.title = _melody._selectedEmission?.emissionName
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
        
        self.updatePopUpContent()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source



    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
