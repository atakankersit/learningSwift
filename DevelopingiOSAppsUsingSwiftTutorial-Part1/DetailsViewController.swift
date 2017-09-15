//
//  DetailsViewController.swift
//  DevelopingiOSAppsUsingSwiftTutorial-Part1
//
//  Created by Viatori on 14/09/2017.
//  Copyright © 2017 Jameson Quave. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDataSource , UITabBarDelegate , APIControllerProtocol {

    var album: Album?
    var tracks = [Track]()
    

    
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var tvTitle: UILabel!
    @IBOutlet weak var tracksTableView: UITableView!
    
    var api : APIController!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tvTitle.text = album?.title
        changeImage()
        api = APIController(delegate: self)
        api.lookupAlbum(collectionId: (album?.collectionId)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeImage()  {
        
        let thumbnailURLString = album?.largeImageURL
        let thumbnailURL = NSURL(string: thumbnailURLString!)!
        let request = NSMutableURLRequest(url: thumbnailURL
            as URL)
        let mainQueue = OperationQueue.main
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
            if error == nil {
                // Convert the downloaded data in to a UIImage object
                let image = UIImage(data: data!)
                // Store the image in to our cache
                // Update the cell
                DispatchQueue.main.async(execute: {
                    self.imgPhoto.image = image
                })
            }
            else {
                print("Error: \(error?.localizedDescription)")
            }
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell") as! TrackCell
        let track = tracks[indexPath.row]
        cell.titleLabel.text = track.title
        cell.playIcon.text = "▶️"
        return cell
        
    }
    
    func didReceivedApiResults(results: NSArray) {
        DispatchQueue.main.async {
            self.tracks = Track.tracksWithJSON(results: results)
            self.tracksTableView!.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}
