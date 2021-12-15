//
//  VODPlayerResource.swift
//  VODPlayer
//
//  Created by P-THY on 13/12/21.
//

import Foundation

public struct VODPlayerResource {
    public var movieId:     Int
    public var watchTime:   Int
    public var url:         URL
    public let name:        String
    public var cover:       URL?
    
    /**
     Play resouce with multi definitions
     
     - parameter url:         video url
     - parameter urlTrailer:  video url trailer
     - parameter name:        video name
     - parameter cover:       video cover
     - parameter subtitles:   video subtitles
     */
    public init(movieId:     Int,
                watchTime:   Int = 0,
                url:         URL ,
                name:        String = "",
                cover:       URL? = nil
    ) {
        self.movieId     = movieId
        self.watchTime   = watchTime
        self.url         = url
        self.name        = name
        self.cover       = cover
    }
}
