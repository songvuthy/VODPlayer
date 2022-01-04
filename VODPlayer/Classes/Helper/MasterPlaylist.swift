//
//  MasterPlaylist.swift
//  Messenger
//
//  Created by VLC on 8/29/20.
//  Copyright © 2020 VLC. All rights reserved.
//

import Foundation


open class MasterPlaylist {
    var playlists = [MediaPlaylist]()
    public init() {}

    open func addPlaylist(_ playlist: MediaPlaylist) {
        playlists.append(playlist)
    }
}
open class MediaPlaylist {
    var masterPlaylist: MasterPlaylist?
    open var resolution: String?
    open var bandwidth: Double = 0
    open var path: String?
    public init() {}
}
/**
* Reads the document found at the specified URL in one chunk synchonous
* and then lets the readLine function pick it line by line.
*/
public protocol BufferedReader {
    func close()
    // Return next line or nil if no more lines can be read
    func readLine() -> String?
}
open class URLBufferedReader: BufferedReader {
    var _uri: URL
    var _stringReader: StringBufferedReader

    public init(uri: URL) {
        _uri = uri
        _stringReader = StringBufferedReader(string: "")
        let request1: URLRequest = URLRequest(url: _uri)
        let response: AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
        do {
            let dataVal = try NSURLConnection.sendSynchronousRequest(request1, returning: response)
            let text = String(data: dataVal, encoding: String.Encoding.utf8)!
            _stringReader = StringBufferedReader(string: text)
        } catch {
            print("Failed to make request for content at \(_uri)")
        }
    }

    open func close() {
        _stringReader.close()
    }

    open func readLine() -> String? {
        return _stringReader.readLine()
    }

}

/**
* Uses a string as a stream and reads it line by line.
*/

open class StringBufferedReader: BufferedReader {
    var _buffer: [String]
    var _line: Int

    public init(string: String) {
        _line = 0
        _buffer = string.components(separatedBy: CharacterSet.newlines)
    }

    open func close() {
    }

    open func readLine() -> String? {
        if _buffer.isEmpty || _buffer.count <= _line {
            return nil
        }
        let result = _buffer[_line]
        _line += 1
        return result
    }
}

// Extend the String object with helpers
extension String {
    // String.replace(); similar to JavaScript's String.replace() and Ruby's String.gsub()
    func replace(_ pattern: String, replacement: String) throws -> String {

        let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])

        return regex.stringByReplacingMatches(
            in: self,
            options: [.withTransparentBounds],
            range: NSRange(location: 0, length: self.count),
            withTemplate: replacement
        )
    }
}
