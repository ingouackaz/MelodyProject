//
//  GrilleTvVC.swift
//  Melody
//
//  Created by Roger Ingouacka on 04/12/14.
//
//

import UIKit

class GrilleTvVC: UIViewController , UICollectionViewDelegate,UICollectionViewDataSource, MBProgressHUDDelegate,UITableViewDelegate, UITableViewDataSource, MZFormSheetBackgroundWindowDelegate{

    @IBOutlet var popUpView: UIView!
    @IBOutlet  var dayCollectionView: UICollectionView!
    @IBOutlet weak var programmeTableView: UITableView!
    var _melody : Melody = Melody.sharedInstance
    var _emissions : Array<Emission> = []
    var _firstAppear : Bool = true
    var _formsheet : MZFormSheetController?
    var _isPresentingFormSheet : Bool = false
    var _daysCell : Array <GrilleCVC?> = Array <GrilleCVC?>(count: 10, repeatedValue: nil)
    var _selectedIndexCel : Int = 3
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _melody.calculateWeekDays()
        self.dayCollectionView.allowsMultipleSelection = false
       // self.dayCollectionView.reloadData()
        
        if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone){
        
            self.loadIphoneView()
        }else
        {
            self.loadiPadView()
        }
        


    }

    func loadIphoneView(){
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict
        self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()

    }
    
    func loadiPadView(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "bandeau-header-grilletv-1024"), forBarMetrics: UIBarMetrics.Default)
        
        var vc : UINavigationController
        var storyboard: UIStoryboard = UIStoryboard(name: "iPad", bundle: NSBundle(forClass: self.dynamicType))
        
        vc = storyboard.instantiateViewControllerWithIdentifier("popUp") as UINavigationController
        
        
        _formsheet =  MZFormSheetController(size: CGSize(width: 650, height: 600), viewController: vc)
        
        _formsheet!.shouldDismissOnBackgroundViewTap = true
        _formsheet!.shouldCenterVertically = true
        
        MZFormSheetController.sharedBackgroundWindow().formSheetBackgroundWindowDelegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"formSheetDidDismissNotification:", name:MZFormSheetDidDismissNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"formSheetDidPresentNotification:", name:MZFormSheetDidPresentNotification, object: nil)
    }
    
    func formSheetDidDismissNotification(notification : NSNotification){
        self.navigationController?.navigationBar.needsUpdateConstraints()
        _isPresentingFormSheet = false
        _melody._isTheFirstPopUp = true

    }
    
    func formSheetDidPresentNotification(notification : NSNotification){
        _isPresentingFormSheet = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        _melody._isTheFirstPopUp = true


    }
    
     override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (_firstAppear == true){
            self.dayCollectionView.selectItemAtIndexPath(NSIndexPath(forRow: 3, inSection: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.CenteredHorizontally)
            self.collectionView(self.dayCollectionView, didSelectItemAtIndexPath: NSIndexPath(forRow: 3, inSection: 0))
            _firstAppear = false
        }


    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        
        return _melody._weekDays.count
    }
    
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.dayCollectionView.selectItemAtIndexPath(NSIndexPath(forRow: indexPath.row, inSection: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.Left )

        self.deselectDayCells()
            //println("WEEKDAYS \(_melody._weekDays) & indexPath & \(indexPath) & collection \(collectionView)" )
            
        var cell : GrilleCVC =   _daysCell[indexPath.row]! as GrilleCVC

        _selectedIndexCel = indexPath.row
        
        cell.dayLabel.textColor = UIColor.orangeColor()
        println("IndexPath \(indexPath)")
        cell.tag = 1
        self.startGetGrilleTvRequest( _melody._weekDays[indexPath.row])


    }

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone){
            return 100

        }
        else{
            return 90
 
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        

        let cell = self.dayCollectionView.dequeueReusableCellWithReuseIdentifier("Day", forIndexPath: indexPath) as GrilleCVC
        var yesterday = NSDate().addDay(-1)
        var tomorrow = NSDate().addDay(1)
        
        
        _daysCell[indexPath.row] = cell

        
        if(_selectedIndexCel != indexPath.row){
            cell.dayLabel.textColor = UIColor.blackColor()
        }
        else{
            cell.dayLabel.textColor = UIColor.orangeColor()

        }
        
        if (_melody._weekDays[indexPath.row].isSameDayAsDate(NSDate())){
            cell.dayLabel.text =  "AUJOURD'HUI"



        }
        else if(_melody._weekDays[indexPath.row].isSameDayAsDate(tomorrow)){
            cell.dayLabel.text =  "DEMAIN"

        }
        else if(_melody._weekDays[indexPath.row].isSameDayAsDate(yesterday)){
            cell.dayLabel.text =  "HIER"
            
        }
        else{
            cell.dayLabel.text = _melody._weekDays[indexPath.row].toGrilleTvDisplayFormatString().uppercaseString
        }
        
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _emissions.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        var programme : Emission = _emissions[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("programmeCell", forIndexPath: indexPath) as ProgrammeTVCell
        cell.backgroundColor =  UIColor(hexString: "#E8E8E8")

        cell.hourLabel.text = programme.start
        cell.genderEmissionLabel.text = programme.emissionCategoryName
        cell.titleEmissionLabel.text = programme.emissionName
        return cell
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
       // println("TOUCH")

        
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //self.performSegueWithIdentifier("detailView", sender: nil)
        var yesterday = NSDate().addDay(-1)
        var tomorrow = NSDate().addDay(1)
        

        
        _melody._selectedEmission = _emissions[indexPath.row]
        
        
        if(_isPresentingFormSheet == false && UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad){
            self.mz_presentFormSheetWithViewController(_formsheet, animated: true, completionHandler: {(MZFormSheetController)  in
                println("red box has faded out")
            })
        }
        else {
            self.performSegueWithIdentifier("videoView", sender: nil)
        }

    }
    
    
    
    func formSheetBackgroundWindow(formSheetBackgroundWindow: MZFormSheetBackgroundWindow!, didChangeStatusBarFrame newStatusBarFrame: CGRect) {
        
    }
    
    
    func startGetGrilleTvRequest(date:NSDate){
        self._melody._loadingHUD.delegate = self
        self._melody.displayLoadingView(self.view)
        
        // exemple http://www.melody.tv/json/grids/view/ + 2014_12_05
        request(.GET,  _melody._grilleTvUrl + date.toGrilleTvUrlFormatString() + "?token=" +  _melody._userToken)
            .responseSwiftyJSON{(request, response, json, error) in
                if (error?.code > -2000)
                {
                    
                    //println("No Internet connection")
                    
                }
                else{

                    self.getEmissionItems(json,date: date)

                }
                self._melody.hideLoadingView()
        }
        
        
    }
    
    
    func deselectDayCells(){
    
        for(index, dayCell) in enumerate(_daysCell){
            dayCell?.dayLabel.textColor = UIColor.blackColor()
        }
        
    }

    
    func getEmissionItems(json: JSON, date:NSDate){
        var array = json["results"]
        
        //  //println("ARRAY \(array)")
        var artists : Array<String> = Array<String>()
        _emissions.removeAll(keepCapacity: false)
        for (index: String, subJson: JSON) in array {
            //Do something you want
            var artists : Array<JSON> = subJson["Video"]["Artist"].arrayValue

            
            if let video = subJson["Video"].dictionaryObject{
                
                var programme : Emission = Emission(emissionDescription: subJson["Video"]["description"].stringValue,
                    id: subJson["id"].stringValue,
                    emissionCategory: subJson["Emission"]["name"].stringValue,
                    end: subJson["end"].stringValue,
                    start: subJson["start"].stringValue,
                    produced: subJson["Video"]["produced"].stringValue.producedFormatNSDate(),
                    formated_duration: subJson["formated_duration"].stringValue,
                    url_Video: subJson["Video"]["url_mobile_hd_teaser"].stringValue,
                    thumb_image: subJson["Video"]["small_thumb_url"].stringValue,
                    date: date,
                    emissionName:subJson["Video"]["title"].stringValue,
                    artists:artists,
                    diffusionDate:NSDate(),
                    relatedEmissions:subJson["Video"]["related_video"].arrayValue,
                    tag:1
                    
                )
                //println("thumbrrr url \(subJson)")

                //NSString(string: subJson["date_diffusion"].stringValue).producedFormatNSDate()
                if (_melody.isUserConnected()){
                    if let url_mobile = subJson["Video"]["url_mobile"].string {
                        programme.url_Video = url_mobile
                        
                    }
                }

                //}
                
                var str =  subJson["Video"]["url_web_teaser"].stringValue
                
                _emissions.append(programme)

            }
            else{
                var name =  subJson["Emission"]["name"].stringValue
                var image =  subJson["Emission"]["name"].stringValue

                
                var valueDescription : String? = "..."

                if (_melody._emissionStaticDescription[name] != nil){
                    valueDescription = _melody._emissionStaticDescription[name]!
                }
                
                var x : String = subJson["date_diffusion"].stringValue
              
                
               // println("Name \(name) valueDescription [\(valueDescription)]")

                var programme : Emission = Emission(
                    id:subJson["id"].stringValue,
                    emissionCategory: subJson["Emission"]["name"].stringValue,
                    end: subJson["end"].stringValue,
                    start: subJson["start"].stringValue,
                    formated_duration: subJson["formated_duration"].stringValue, date:date,
                    emissionName:"",
                artists:artists,
                diffusionDate:NSString(string: subJson["date_diffusion"].stringValue).producedFormatNSDate(),
                    relatedEmissions:subJson["Video"]["related_video"].arrayValue,
                    tag:1
                )
                programme.emissionDescription = valueDescription!
                if(_melody._emissionStaticImages[name] != nil){
                    programme.thumb_image = _melody._emissionStaticImages[name]

                    //  valueImage = _melody._emissionStaticImages[name]
                }
                _emissions.append(programme)

            }            
            
        }
        programmeTableView.reloadData()
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
