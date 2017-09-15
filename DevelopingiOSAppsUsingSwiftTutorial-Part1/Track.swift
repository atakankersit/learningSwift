//
//  Track.swift
//  DevelopingiOSAppsUsingSwiftTutorial-Part1
//
//  Created by Viatori on 15/09/2017.
//  Copyright © 2017 Jameson Quave. All rights reserved.
//

import Foundation

struct Track {
    let title: String
    let price: String
    let previewUrl: String
    
    init(title: String, price: String, previewUrl: String) {
        self.title = title
        self.price = price
        self.previewUrl = previewUrl
    }
    
    static func tracksWithJSON(results: NSArray) -> [Track] {
        // Create an empty array of Albums to append to from this list
        var tracks = [Track]()
        
        // Store the results in our table data array
        
            for item in results {
            
                var result =  item as! NSDictionary

                var trackPrice = result["trackPrice"] as? String ?? ""
                var trackTitle = result["trackName"] as? String ?? ""
                var trackPreviewUrl = result["previewUrl"] as? String ?? ""
                
                if(trackTitle == nil) {
                    trackTitle = "Unknown"
                }
                else if(trackPrice == nil) {
                    trackPrice = "?"
                }
                else if(trackPreviewUrl == nil) {
                    trackPreviewUrl = ""
                }
                let track = Track(title: trackTitle, price: trackPrice, previewUrl: trackPreviewUrl)
                tracks.append(track)
        }
        
        return tracks
    }
}
