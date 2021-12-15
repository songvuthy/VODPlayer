//
//  VODPlayerExstension.swift
//  VODPlayer
//
//  Created by P-THY on 14/12/21.
//

import Foundation



extension UIView {
    var vodIsFullScreen: Bool {
        return UIApplication.shared.statusBarOrientation.isLandscape
    }
    
    func VODImageResourcePath(_ fileName: String) -> UIImage? {
        let bundle = Bundle(for: VODPlayer.self)
        return UIImage(named: fileName, in: bundle, compatibleWith: nil)
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
        case skipPreview    = 109
        
    }
}
