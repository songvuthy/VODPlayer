//
//  ManifestBuilder.swift
//  Messenger
//
//  Created by VLC on 8/29/20.
//  Copyright © 2020 VLC. All rights reserved.
//

import Foundation

enum STREAM_INF: String {
    case banwidth   = "BANDWIDTH="
    case resolution = "RESOLUTION="
}

/**
* Parses HTTP Live Streaming manifest files
* Use a BufferedReader to let the parser read from various sources.
*/
open class ManifestBuilder {

    public init() {}
    func matches(for regex: String, in text: String) -> [String] {

        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    /**
    * Parses Master playlist manifests
    */
    fileprivate func parseMasterPlaylist(_ reader: BufferedReader, onMediaPlaylist:
            ((_ playlist: MediaPlaylist) -> Void)?) -> MasterPlaylist {
        let masterPlaylist = MasterPlaylist()
        var currentMediaPlaylist: MediaPlaylist?

        defer {
            reader.close()
        }
        while let line = reader.readLine() {
            if line.isEmpty {
                // Skip empty lines
            } else if line.hasPrefix("#EXT") {
                // Tags
                if line.hasPrefix("#EXTM3U") {
                    // Ok Do nothing
                } else if line.hasPrefix("#EXT-X-STREAM-INF") {
                    // #EXT-X-STREAM-INF:PROGRAM-ID=1, BANDWIDTH=200000
                    currentMediaPlaylist = MediaPlaylist()
                    let bandwidthString = line.components(separatedBy: STREAM_INF.banwidth.rawValue)[1].components(separatedBy: ",")[0]
                    var resolutionString: String?
                    if line.contains(STREAM_INF.resolution.rawValue) {
                        resolutionString = line.components(separatedBy: STREAM_INF.resolution.rawValue)[1].components(separatedBy: ",")[0]
                    }
                    if let currentMediaPlaylistExist = currentMediaPlaylist {
                        currentMediaPlaylistExist.resolution = resolutionString
                        currentMediaPlaylistExist.bandwidth = Double(bandwidthString)!
                    }
                    
                }
            } else if line.hasPrefix("#") {
                // Comments are ignored
            } else {
                // URI - must be
                if let currentMediaPlaylistExist = currentMediaPlaylist {
                    currentMediaPlaylistExist.path = line
                    currentMediaPlaylistExist.masterPlaylist = masterPlaylist
                    masterPlaylist.addPlaylist(currentMediaPlaylistExist)
                    if let callableOnMediaPlaylist = onMediaPlaylist {
                        callableOnMediaPlaylist(currentMediaPlaylistExist)
                    }
                }
            }
        }
        return masterPlaylist
    }
    /**
    * Parses the master playlist manifest requested synchronous from a URL
    *
    * Convenience method that uses a URLBufferedReader as source for the manifest.
    */
    open func parseMasterPlaylistFromURL(_ url: URL, onMediaPlaylist:
                ((_ playlist: MediaPlaylist) -> Void)? = nil) -> MasterPlaylist {
        return parseMasterPlaylist(URLBufferedReader(uri: url), onMediaPlaylist: onMediaPlaylist)
    }
    /**
    * Parses the master manifest found at the URL and all the referenced media playlist manifests recursively.
    */
    open func parse(_ url: URL, onMediaPlaylist: ((_ playlist: MediaPlaylist) -> Void)? = nil) -> MasterPlaylist {
        // Parse master
        let master = parseMasterPlaylistFromURL(url, onMediaPlaylist: onMediaPlaylist)
        return master
    }
}
