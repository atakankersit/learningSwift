//
//  APIController.swift
//  DevelopingiOSAppsUsingSwiftTutorial-Part1
//
//  Created by ATAKAN KERŞİT on 06/08/2017.
//  Copyright © 2017 Jameson Quave. All rights reserved.
//

import Foundation

protocol APIControllerProtocol {
    func didReceivedApiResults(results: NSArray)
}

 class APIController {
    var delegate: APIControllerProtocol?
    
    func searchItunes(searchTerm: String) {
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
                let results: NSArray = jsonResult["results"] as! NSArray
                self.delegate?.didReceivedApiResults(results: results)

            }
            catch let err {
                print(err.localizedDescription)
            }

            // Close the dataTask block, and call resume() in order to make it run immediately
            }.resume()
    }
    

}

