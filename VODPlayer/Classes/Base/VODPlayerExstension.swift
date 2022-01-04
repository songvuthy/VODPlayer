//
//  VODPlayerExstension.swift
//  VODPlayer
//
//  Created by P-THY on 14/12/21.
//

import Foundation



extension UIView {
    func vodPerformSpringAnimation(completion: ((Bool) -> Void)? = nil) {
        self.alpha = 1
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {[self] in
            self.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
            //reducing the size
            UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {[self] in
                self.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }) { (status) in
                completion?(status)
            }
        })
    }
    
    var vodIsFullScreen: Bool {
        return UIApplication.shared.statusBarOrientation.isLandscape
    }
    
    func VODImageResourcePath(_ fileName: String) -> UIImage? {
        let bundle = Bundle(for: VODPlayer.self)
        return UIImage(named: fileName, in: bundle, compatibleWith: nil)
    }
    var x : CGFloat {
        get {
            return frame.origin.x
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.origin.x = newValue
            frame = tempFrame
        }
    }
    
    var y : CGFloat {
        get {
            return frame.origin.y
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.origin.y = newValue
            frame = tempFrame
        }
    }
    
    var width : CGFloat {
        get {
            return frame.size.width
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.size.width = newValue
            frame = tempFrame
        }
    }
    
    var height : CGFloat {
        get {
            return frame.size.height
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.size.height = newValue
            frame = tempFrame
        }
    }
    
    var centerX : CGFloat {
        get {
            return center.x
        }
        set {
            var tempCenter : CGPoint = center
            tempCenter.x = newValue
            center = tempCenter
        }
    }
    var centerY : CGFloat {
        get {
            return center.y
        }
        set {
            var tempCenter : CGPoint = center
            tempCenter.y = newValue
            center = tempCenter
        }
    }
    var size : CGSize {
        get {
            return frame.size
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.size = newValue
            frame = tempFrame
        }
    }
    
    var right : CGFloat {
        get {
            return frame.origin.x + frame.size.width
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.origin.x = newValue - frame.size.width
            frame = tempFrame
        }
    }
    
    var bottom : CGFloat {
        get {
            return frame.origin.y + frame.size.height
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.origin.y = newValue - frame.size.height
            frame = tempFrame
        }
    }
}

extension CGContext {
    
    func fill(_ rect: CGRect,
              with mask: CGImage,
              using color: CGColor) {
        
        saveGState()
        defer { restoreGState() }
        
        translateBy(x: 0.0, y: rect.size.height)
        scaleBy(x: 1.0, y: -1.0)
        setBlendMode(.normal)
        
        clip(to: rect, mask: mask)
        
        setFillColor(color)
        fill(rect)
    }
}

extension UIImage {
    
    func filled(with color: UIColor) -> UIImage {
        let rect = CGRect(origin: .zero, size: self.size)
        guard let mask = self.cgImage else { return self }
        
        if #available(iOS 10.0, *) {
            let rendererFormat = UIGraphicsImageRendererFormat()
            rendererFormat.scale = self.scale
            
            let renderer = UIGraphicsImageRenderer(size: rect.size,
                                                   format: rendererFormat)
            return renderer.image { context in
                context.cgContext.fill(rect,
                                       with: mask,
                                       using: color.cgColor)
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(rect.size,
                                                   false,
                                                   self.scale)
            defer { UIGraphicsEndImageContext() }
            
            guard let context = UIGraphicsGetCurrentContext() else { return self }
            
            context.fill(rect,
                         with: mask,
                         using: color.cgColor)
            return UIGraphicsGetImageFromCurrentImageContext() ?? self
        }
    }
    
    /// Get the pixel color at a point in the image
    func pixelColor(atLocation point: CGPoint) -> UIColor? {
        guard let cgImage = cgImage, let pixelData = cgImage.dataProvider?.data else { return nil }
        
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let bytesPerPixel = cgImage.bitsPerPixel / 8
        
        let pixelInfo: Int = ((cgImage.bytesPerRow * Int(point.y)) + (Int(point.x) * bytesPerPixel))
        
        let b = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let r = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

extension UIApplication {
    static var safeFrame: CGRect {
        var safeArea: CGRect = .zero
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows[0]
            let safeFrame = window.safeAreaLayoutGuide.layoutFrame
            safeArea = safeFrame
        }
        return safeArea
    }
}

extension VODPlayerControls {
    
    public enum ButtonType: Int {
        case play       = 101
        case replay     = 102
        case next10     = 103
        case pre10      = 104
        
    }
    public enum TapActionType: Int {
        case back           = 101
        case download       = 102
        case mirror         = 103
        case subtitles      = 104
        case setting        = 105
        case brightness     = 106
        case volume         = 107
        case cancelDownload = 108
        
    }
    
    static func formatSecondsToString(_ seconds: TimeInterval) -> String {
        if seconds.isNaN {
            return "00:00:00"
        }
        let hours = Int(seconds) / 3600
        let min = Int(seconds / 60) % 60
        let sec = Int(seconds.truncatingRemainder(dividingBy: 60))
        if hours != 0{
            return String(format: "%02d:%02d:%02d",hours, min, sec)
        }else{
            return String(format: "%02d:%02d", min, sec)
        }
    }
}

extension TimeInterval {
    var secToMillisecond: Int {
        return Int((self*1000))
    }
}
extension Int {
    var msToSeconds: Double {
        return Double(self) / 1000
    }
}

extension String {
    var vodGetQuality: String {
        let quality = self.components(separatedBy: "x")
        return quality[1]
    }
    var vodGetResolution: CGSize {
        let quality = self.components(separatedBy: "x")
        let w = (quality[0] as NSString).floatValue
        let h = (quality[1] as NSString).floatValue
        return CGSize(width: CGFloat(w), height: CGFloat(h))
    }
    
    private var vodHtmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8, allowLossyConversion: true) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var vodHtmlToString: String {
        return vodHtmlToAttributedString?.string ?? ""
    }
}


extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(cell: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: UICollectionReusableView>(header: T.Type) {
        register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: UICollectionReusableView>(footer: T.Type) {
        register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.reuseIdentifier)
    }
}

extension UICollectionView {
    func dequeue<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    func dequeue<T: UICollectionReusableView>(forHeader indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    func dequeue<T: UICollectionReusableView>(forFooter indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}
