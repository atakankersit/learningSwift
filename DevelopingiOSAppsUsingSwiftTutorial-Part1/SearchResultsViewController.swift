//
//  ViewController.swift
//  DevelopingiOSAppsUsingSwiftTutorial-Part1
//
//  Created by Jameson Quave on 4/17/17.
//  Copyright © 2017 Jameson Quave. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,APIControllerProtocol {
    
    @IBOutlet var appsTableView: UITableView!
    //var tableData = NSArray()
    let kCellIdentifier: String = "SearchResultCell"
    var imageCache = [String:UIImage]()
    var api : APIController!
    var albums = [Album]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //searchItunes(searchTerm: "JQ Software")
        api = APIController(delegate: self)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        api.searchItunes(searchTerm: "Beatles")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier) as! UITableViewCell
        
        let album = self.albums[indexPath.row]
        
        cell.detailTextLabel?.text = album.price
        // Update the textLabel text to use the title from the Album model
        cell.textLabel?.text = album.title
        
        // Start by setting the cell's image to a static file
        // Without this, we will end up without an image view!
        cell.imageView?.image = UIImage(named: "Blank52")
        
        let thumbnailURLString = album.thumbnailImageURL
        let thumbnailURL = NSURL(string: thumbnailURLString)!
        
        // If this image is already cached, don't re-download
        if let img = imageCache[thumbnailURLString] {
            cell.imageView?.image = img
        }
        else {
            // The image isn't cached, download the img data
            // We should perform this in a background thread
            let request = NSMutableURLRequest(url: thumbnailURL as URL)
                            let mainQueue = OperationQueue.main
                            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                                if error == nil {
                                    // Convert the downloaded data in to a UIImage object
                                    let image = UIImage(data: data!)
                                    // Store the image in to our cache
                                    self.imageCache[thumbnailURLString] = image
                                    // Update the cell
                                    DispatchQueue.main.async(execute: {
                                        if let cellToUpdate = tableView.cellForRow(at: indexPath) {
                                            cellToUpdate.imageView?.image = image
                                        }
                                    })
                                }
                                else {
                                    print("Error: \(error?.localizedDescription)")
                                }
            })
        }
        return cell
        //2. way
        
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "MyTestCell")
//        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier) as! UITableViewCell
//        
//        
//        
//        if let rowData: NSDictionary = self.tableData[indexPath.row] as? NSDictionary,
//            // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
//            let urlString = rowData["artworkUrl60"] as? String,
//            let imgURL = URL(string: urlString),
//            // Get the formatted price string for display in the subtitle
//            let formattedPrice = rowData["formattedPrice"] as? String,
//            // Download an NSData representation of the image at the URL
//            //let imgData = NSData(contentsOfURL: imgURL),
//            // Get the track name
//            let trackName = rowData["trackName"] as? String {
//            // Get the formatted price string for display in the subtitle
//            cell.detailTextLabel?.text = formattedPrice
//            cell.detailTextLabel?.textColor = UIColor.red
//            cell.backgroundColor = UIColor.yellow
//            // Update the imageView cell to use the downloaded image data
//            //cell.imageView?.image = UIImage(data: imgData)
//            // Update the textLabel text to use the trackName from the API
//            cell.textLabel?.text = trackName
//            cell.textLabel?.textColor = UIColor.red
//            
//            // Start by setting the cell's image to a static file
//            // Without this, we will end up without an image view!
//            cell.imageView?.image = UIImage(named: "Blank52")
//            
//            if let img = imageCache[urlString]{
//            cell.imageView?.image = img
//            }
//            else{
//                let request = NSMutableURLRequest(url: imgURL)
//                let mainQueue = OperationQueue.main
//                NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
//                    if error == nil {
//                        // Convert the downloaded data in to a UIImage object
//                        let image = UIImage(data: data!)
//                        // Store the image in to our cache
//                        self.imageCache[urlString] = image
//                        // Update the cell
//                        DispatchQueue.main.async(execute: {
//                            if let cellToUpdate = tableView.cellForRow(at: indexPath) {
//                                cellToUpdate.imageView?.image = image
//                            }
//                        })
//                    }
//                    else {
//                        print("Error: \(error?.localizedDescription)")
//                    }
//
//            })
//        
//            }
//        }
//    
//    
//        // Get the app from the list at this row's index
//        //let app = tableData[indexPath.row]
//        
//        // Pull out the relevant strings in the app record
//        //cell.textLabel?.text = app["appName"]
//        //cell.detailTextLabel?.text = app["price"]
//        
//        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = self.albums[indexPath.row] as? NSDictionary,
         let name = data["trackName"] as? String,
             let formattedPrice = data["formattedPrice"] {
            let alert = UIAlertController(title: name, message: formattedPrice as? String, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
   
    
    func didReceivedApiResults(results: NSArray) {
        DispatchQueue.main.async {
            self.albums = Album.albumsWithJSON(results: results)
            self.appsTableView!.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false

        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailsViewController: DetailsViewController = segue.destination as! DetailsViewController{
            detailsViewController.album = self.albums[(appsTableView.indexPathForSelectedRow?.row)!]
        
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animate(withDuration: 0.25, animations: {cell.layer.transform = CATransform3DMakeScale(1, 1, 1)})
    }
       /* func searchItunes(searchTerm: String) {
        // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
        let itunesSearchTerm = searchTerm.replacingOccurrences(of: " ", with: "+", options: .caseInsensitive, range: nil)
        // Also replace every character with a percent encoding
        let escapedSearchTerm = itunesSearchTerm.addingPercentEncoding(withAllowedCharacters: [])!
        
        // This is the URL that Apple offers for their search API
        let urlString = "http://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software"
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                // If there is an error in the web request, print it to the console
                print(error)
                return
            }
            // Because we'll be calling a function that can throw an error
            // we need to wrap the attempt inside of a do { } block
            // and catch any error that comes back inside the catch block
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                self.didReceive(searchResult: jsonResult)
            }
            catch let err {
                print(err.localizedDescription)
            }
            // Close the dataTask block, and call resume() in order to make it run immediately
        }.resume()
    }*/

}

