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
    var tableData = NSArray()
    let kCellIdentifier: String = "SearchResultCell"
    var imageCache = [String:UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //searchItunes(searchTerm: "JQ Software")
        let api = APIController()
        api.delegate = self
        api.searchItunes(searchTerm: "Angry Birds")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "MyTestCell")
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier) as! UITableViewCell
        
        
        
        if let rowData: NSDictionary = self.tableData[indexPath.row] as? NSDictionary,
            // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
            let urlString = rowData["artworkUrl60"] as? String,
            let imgURL = URL(string: urlString),
            // Get the formatted price string for display in the subtitle
            let formattedPrice = rowData["formattedPrice"] as? String,
            // Download an NSData representation of the image at the URL
            //let imgData = NSData(contentsOfURL: imgURL),
            // Get the track name
            let trackName = rowData["trackName"] as? String {
            // Get the formatted price string for display in the subtitle
            cell.detailTextLabel?.text = formattedPrice
            cell.detailTextLabel?.textColor = UIColor.red
            cell.backgroundColor = UIColor.yellow
            // Update the imageView cell to use the downloaded image data
            //cell.imageView?.image = UIImage(data: imgData)
            // Update the textLabel text to use the trackName from the API
            cell.textLabel?.text = trackName
            cell.textLabel?.textColor = UIColor.red
            
            // Start by setting the cell's image to a static file
            // Without this, we will end up without an image view!
            cell.imageView?.image = UIImage(named: "Blank52")
            
            if let img = imageCache[urlString]{
            cell.imageView?.image = img
            }
            else{
                let request = NSMutableURLRequest(url: imgURL)
                let mainQueue = OperationQueue.main
                NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                    if error == nil {
                        // Convert the downloaded data in to a UIImage object
                        let image = UIImage(data: data!)
                        // Store the image in to our cache
                        self.imageCache[urlString] = image
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
        }
    
    
        // Get the app from the list at this row's index
        //let app = tableData[indexPath.row]
        
        // Pull out the relevant strings in the app record
        //cell.textLabel?.text = app["appName"]
        //cell.detailTextLabel?.text = app["price"]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = self.tableData[indexPath.row] as? NSDictionary,
         let name = data["trackName"] as? String,
             let formattedPrice = data["formattedPrice"] {
            let alert = UIAlertController(title: name, message: formattedPrice as? String, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
   
    
    func didReceivedApiResults(results: NSArray) {
        DispatchQueue.main.async {
            self.tableData = results
            self.appsTableView!.reloadData()
        }
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

