//
//  VODAppConstants.swift
//  VODPlayer
//
//  Created by P-THY on 14/12/21.
//



import UIKit

struct VODAppConstants {

    struct BaseHeight {
        ///
        static let btn_height = VODDevice.iPad ? VODScale.padScale(25) : VODScale.phoneScale(25)
        ///
        static let btn_height_body = VODDevice.iPad ? VODScale.padScale(90) : VODScale.phoneScale(90)
        static let padding_body    = 80
        static let btn_play_insets = VODDevice.iPad ? VODScale.padScale(22) : VODScale.phoneScale(22)
        static let btn_play_10s = VODDevice.iPad ? VODScale.padScale(25) : VODScale.phoneScale(25)
        
        static let panModal_Height = VODDevice.iPad ? UIScreen.main.bounds.height * 0.3  : UIScreen.main.bounds.height * 0.7
        ///
        static let panModal_header_Height: CGFloat = VODDevice.iPad ? 44 + 44 * 0.4 : 44
        static let heightForItem: CGFloat          = 40
        static let padding: CGFloat                = 16
    }
    struct BaseFont {
        static let font_14 = UIFont.systemFont(
            ofSize: VODDevice.iPad ? VODScale.padScale(16) : VODScale.phoneScale(14),
            weight: .regular
        )
    }
    struct BaseColor {
        
        /// General / Out Line White
        static let C1 = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) // #FFFFFF
        
        ///Text Selecting // Button Color
        static let C2 = #colorLiteral(red: 0.9960784314, green: 0.5333333333, blue: 0.01176470588, alpha: 1) // #FDB316
        
        /// Backgound color General
        static let C3 = #colorLiteral(red: 0.09411764706, green: 0.09411764706, blue: 0.1333333333, alpha: 1) // #181822

    }
}

class VODDevice {
    static var iPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}

class VODScale {
    
    private static let PAD_MIN_SCREEN_HEIGHT   = 768
    private static let PHONE_MIN_SCREEN_HEIGHT = 375
    
    static func padScale(_ value: CGFloat) -> CGFloat {
        let width = UIScreen.main.bounds.width
        
        let ratio = width / CGFloat(VODScale.PAD_MIN_SCREEN_HEIGHT)
        return ratio * value
    }
    static func phoneScale(_ value: CGFloat) -> CGFloat {
        let width = UIScreen.main.bounds.width
        
        let ratio = width / CGFloat(VODScale.PHONE_MIN_SCREEN_HEIGHT)
        return ratio * value
    }
}
