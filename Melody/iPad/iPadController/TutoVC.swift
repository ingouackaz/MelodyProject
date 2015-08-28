//
//  TutoViewController.swift
//  Melody
//
//  Created by Roger Ingouacka on 09/02/2015.
//
//

import UIKit


class TutoVC : UIViewController, UIPageViewControllerDataSource
{
    var _melody : Melody = Melody.sharedInstance

    var pageViewController : UIPageViewController?
    var pageTitles : Array<String> = ["God vs Man", "Cool Breeze", "Fire Sky"]
            //var pageImages : Array<UIImage> = [UIImage(named: "melody-SplashScreen")!, UIImage(named: "melody-SplashScreen")!, UIImage(named: "melody-SplashScreen")!]

    var currentIndex : Int = 0
    var _images  = [UIImage(named: "melody_cover")!,UIImage(named: "melody_cover")!,UIImage(named: "melody_cover")!]
    
    var _pageIndex : Int = Int()
    var _countImage : Int = 0

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        

        
        self._melody.displayLoadingView(self.view, text:"")


        if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone){
            self.loadiPhoneTutos()
        }
        else{
        self.loadiPadTutos()
        }
    }
    
    func loadiPhoneTutos(){
        for (index, obj) in enumerate(_images)
        {
            
            if let checkedUrl = NSURL(string:kMLDTutosUrlImage + "320_568_" + String(index+1) + ".png"){
                println("Checked url \(checkedUrl)")
                downloadImage(checkedUrl, index: index)
            }
            
        }
    
    }
    
    func loadiPadTutos() {
        for (index, obj) in enumerate(_images)
        {
            
            if let checkedUrl = NSURL(string:kMLDTutosUrlImage + "1024__" + String(index+1) + ".png"){
                println("Checked url \(checkedUrl)")
                downloadImage(checkedUrl, index: index)
            }
            
        }
    }
    
    func downloadImage(url:NSURL, index:Int){
        
        println("Started downloading \"\(url).")
        
        
        getDataFromUrl(url) { data in
            dispatch_async(dispatch_get_main_queue()) {
                url.lastPathComponent
                println("Finished downloading \"\(url.lastPathComponent!.stringByDeletingPathExtension)\".")
                println("index \(index)")
                self._countImage++
                if(data != nil){
                    self._images[index] = UIImage(data: data!)!
                    if(self._countImage == self._images.count){
                        
                        self._countImage = 0
                        self._melody.hideLoadingView()
                        self.pageViewController = self.storyboard!.instantiateViewControllerWithIdentifier("PageViewController") as? UIPageViewController
                        self.pageViewController!.dataSource = self
                        
                        
                        let startingViewController: PageTutoVC = self.viewControllerAtIndex(0)!
                        let viewControllers: NSArray = [startingViewController]
                        self.pageViewController!.setViewControllers(viewControllers as [AnyObject], direction: .Forward, animated: false, completion: nil)
                        self.pageViewController!.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
                        
                        self.addChildViewController(self.pageViewController!)
                        self.view.addSubview(self.pageViewController!.view)
                        self.pageViewController!.didMoveToParentViewController(self)
                        
                    }
                }
                
            }
        }
    }
    
    func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: NSData(data: data))
            }.resume()
    }
    
    func startGetLastActuRequest(){
        
       // self._melody.displayLoadingView(self.view)
        
        request(.GET, "http://www.melody.tv/images/stories/showcase/applis/1024_a.png")
            .responseSwiftyJSON{(request, response, json, error) in
                if (error?.code > -2000)
                {
                    
                    //println("No Internet connection")
                }
                else{
                    // Ajoute un print avant sinon playgr9und renvoie 0 -> bug
                    println(" MELODY CONTENT JSON \(json)")
                    

                    
                }
                
            //    self._melody.hideLoadingView()
                
        }
        
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! PageTutoVC).pageIndex
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index--
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! PageTutoVC).pageIndex
        
        if index == NSNotFound {
            return nil
        }
        
        index++
        
        if (index == self.pageTitles.count) {
            return nil
        }
        
        return viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(index: Int) -> PageTutoVC?
    {
        if self.pageTitles.count == 0 || index >= self.pageTitles.count
        {
            return nil
        }
        
        // Create a new view controller and pass suitable data.
        let pageContentViewController : PageTutoVC = self.storyboard!.instantiateViewControllerWithIdentifier("pageTuto") as! PageTutoVC
        
        pageContentViewController.titleText = pageTitles[index]
        pageContentViewController.currentImage = _images[index]
        pageContentViewController.pageIndex = index
        currentIndex = index
        
        return pageContentViewController
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return self.pageTitles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
}
