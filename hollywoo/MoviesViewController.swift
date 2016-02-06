//
//  MoviesViewController.swift
//  
//
//  Created by Jiaqi Wu on 1/10/16.
//
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var movies: [NSDictionary]?
    //to get movies via API!
    //use questionmark to make movies "optional"...it can be nil too
    
    var endpoint: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        networkRequest()

        
    }
    
    func networkRequest() {
        // Do any additional setup after loading the view.
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        
        //endpoint string allows user to decide whether they want top rated movies or all movies to be displayd in tab navigation
        
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        // Display HUD right before the request is made
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                
                //Hide HUD once network request comes back
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
                if let data = dataOrNil {
                    //data is coming back as responseDictionary
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            //print("response: \(responseDictionary)")
                    
                    //use self when inside an enclosure!
                    self.movies = responseDictionary["results"] as! [NSDictionary]
                    self.tableView.reloadData()
                    }
                }
        })

        
        task.resume()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            //if it isn't nil, let equal to a constant called movies! 
            return movies.count
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        //if not nil, execute!
        if let posterPath = movie["poster_path"] as? String {
            let baseUrl = "http://image.tmdb.org/t/p/w500"
            let imageUrl = NSURL(string: baseUrl + posterPath)
            //cell.posterView.setImageWithURL(imageUrl!)
            
            
            let lowResUrl = "https://image.tmdb.org/t/p/w45" + posterPath
            let highResUrl = "https://image.tmdb.org/t/p/original" + posterPath
            
            let smallImageRequest = NSURLRequest(URL: NSURL(string: lowResUrl)!)
            let largeImageRequest = NSURLRequest(URL: NSURL(string: highResUrl)!)
            
            cell.posterView.setImageWithURLRequest(
                smallImageRequest,
                placeholderImage: nil,
                success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                    
                    // smallImageResponse will be nil if the smallImage is already available
                    // in cache (might want to do something smarter in that case).
                    cell.posterView.alpha = 0.0
                    cell.posterView.image = smallImage;
                    
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        
                        cell.posterView.alpha = 1.0
                        
                        }, completion: { (sucess) -> Void in
                            
                            // The AFNetworking ImageView Category only allows one request to be sent at a time
                            // per ImageView. This code must be in the completion block.
                           cell.posterView.setImageWithURLRequest(
                                largeImageRequest,
                                placeholderImage: smallImage,
                                success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                    
                                    cell.posterView.image = largeImage;
                                    
                                },
                                failure: { (request, response, error) -> Void in
                                    // do something for the failure condition of the large image request
                                    // possibly setting the ImageView's image to a default image
                            })
                    })
                },
                failure: { (request, response, error) -> Void in
                    // do something for the failure condition
                    // possibly try to get the large image
            })
            
            //fade in image loaded from network
             let imageRequest = NSURLRequest(URL: imageUrl!)
            
             cell.posterView.setImageWithURLRequest(
             imageRequest,
             placeholderImage: nil,
             success: { (imageRequest, imageResponse, image) -> Void in
             
             // imageResponse will be nil if the image is cached
             if imageResponse != nil {
                print("Image was NOT cached, fade in image")
                cell.posterView.alpha = 0.0
                cell.posterView.image = image
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    cell.posterView.alpha = 1.0
             })}
             else {
                print("Image was cached so just update the image")
                cell.posterView.image = image
                }},
             failure: { (imageRequest, imageResponse, error) -> Void in
                print("Error: failure clause executed")
             })
        }
        //set selected tableview cell background color
        let backgroundView = UIView()
        
        backgroundView.backgroundColor = UIColor(red: 0/255, green: 230/255, blue: 234/255, alpha: 1.0)
        cell.selectedBackgroundView = backgroundView
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        return cell 
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let myRequest = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)

        
        // Configure session so that completion handler is executed on main UI thread
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(myRequest,
            completionHandler: { (dataONil, response, error) in
                
                // ... Use the new data to update the data source ...
                if let data = dataONil {
                    //data is coming back as responseDictionary
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            //print("response: \(responseDictionary)")
                            
                            //use self when inside an enclosure!
                            self.movies = responseDictionary["results"] as! [NSDictionary]
                            self.tableView.reloadData()
                    }
                }
                
                // Reload the tableView now that there is new data
                self.tableView.reloadData()
                
                // Tell the refreshControl to stop spinning
                refreshControl.endRefreshing()	
        });
        task.resume()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let movie = movies![indexPath!.row] //getting the right row
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.movie = movie
        
    
        
        print("prepare for segue called")
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    
    
    
    

}
