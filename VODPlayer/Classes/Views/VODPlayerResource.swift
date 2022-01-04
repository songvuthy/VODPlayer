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
//    public var subtitles:   [VODSubtitleLanguages]
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
//                subtitles:   [VODSubtitleLanguages] = []
    ) {
        self.movieId     = movieId
        self.watchTime   = watchTime
        self.url         = url
        self.name        = name
        self.cover       = cover
//        self.subtitles   = subtitles
    }
}
public struct VODSubtitleLanguages {
    var language: String
    var subtitle: VODSubtitles?
    var checkmark: Bool
    
    public init(language: String, subtitle: URL?) {
        
        var subtitles: VODSubtitles? = nil
        if let subtitle = subtitle{
            subtitles = VODSubtitles(url: subtitle)
        }
        self.language  = language
        self.subtitle  = subtitles
        self.checkmark = false
    }
}


public class VODSubtitles {
    public var groups: [Group] = []
    /// subtitles delay, positive:fast, negative:forward
    public var delay: TimeInterval = 0
    
    public var data: Data? = nil
    
    public struct Group: CustomStringConvertible {
        var index: Int
        var start: TimeInterval
        var end  : TimeInterval
        var text : String
        
        init(_ index: Int, _ start: NSString, _ end: NSString, _ text: NSString) {
            self.index = index
            self.start = Group.parseDuration(start as String)
            self.end   = Group.parseDuration(end as String)
            self.text  = text as String
        }
        
        static func parseDuration(_ fromStr:String) -> TimeInterval {
            var h: TimeInterval = 0.0, m: TimeInterval = 0.0, s: TimeInterval = 0.0, c: TimeInterval = 0.0
            let scanner = Scanner(string: fromStr)
            scanner.scanDouble(&h)
            scanner.scanString(":", into: nil)
            scanner.scanDouble(&m)
            scanner.scanString(":", into: nil)
            scanner.scanDouble(&s)
            scanner.scanString(",", into: nil)
            scanner.scanDouble(&c)
            return (h * 3600.0) + (m * 60.0) + s + (c / 1000.0)
        }
        
        public var description: String {
            return "Subtile Group ==========\nindex : \(index),\nstart : \(start)\nend   :\(end)\ntext  :\(text)"
        }
    }
    
    public init(url: URL, encoding: String.Encoding? = nil) {
        DispatchQueue.global(qos: .background).async {[weak self] in
            do {
                let string: String
                if let encoding = encoding {
                    string = try String(contentsOf: url, encoding: encoding)
                } else {
                    string = try String(contentsOf: url)
                }
                self?.data = Data(string.utf8)
                self?.groups = VODSubtitles.parseSubRip(string) ?? []
            } catch {
                print("| VODPlayer | [Error] failed to load \(url.absoluteString) \(error.localizedDescription)")
            }
        }
    }
    
    /**
     Search for target group for time
     
     - parameter time: target time
     
     - returns: result group or nil
     */
    public func search(for time: TimeInterval) -> Group? {
        let result = groups.first(where: { group -> Bool in
            if group.start - delay <= time && group.end - delay >= time {
                return true
            }
            return false
        })
        return result
    }
    
    /**
     Parse str string into Group Array
     
     - parameter payload: target string
     
     - returns: result group
     */
    fileprivate static func parseSubRip(_ payload: String) -> [Group]? {
        var groups: [Group] = []
        let scanner = Scanner(string: payload)
        while !scanner.isAtEnd {
            var indexString: NSString?
            scanner.scanUpToCharacters(from: .newlines, into: &indexString)
            
            var startString: NSString?
            scanner.scanUpTo(" --> ", into: &startString)
            
            // skip spaces and newlines by default.
            scanner.scanString("-->", into: nil)
            
            var endString: NSString?
            scanner.scanUpToCharacters(from: .newlines, into: &endString)
            
            var textString: NSString?
            scanner.scanUpTo("\r\n\r\n", into: &textString)
            
            if let text = textString {
                textString = text.trimmingCharacters(in: .whitespaces) as NSString
                textString = text.replacingOccurrences(of: "\r", with: "") as NSString
            }
            
            if let indexString = indexString,
                let index = Int(indexString as String),
                let start = startString,
                let end   = endString,
                let text  = textString {
                let group = Group(index, start, end, text)
                groups.append(group)
            }
        }
        return groups
    }
}
