//
//  VODPlayList.swift
//  VODPlayer
//
//  Created by P-THY on 3/1/22.
//

import Foundation

public struct VODPlayList{
    var title:      String
    var quality:    String
    var resolution: String
    var banWidth:   Double
    var subURL:     String
    var checkmark:  Bool
}


public struct VODPlaySpeed {
    var title:     String
    let dataType:  VODPlaySpeedType
    var checkmark: Bool
}

public enum VODPlaySpeedType: String{
    case PBS_0_5X  = "0.5"
    case PBS_0_75X = "0.75"
    case PBS_1_0X  = "1.0"
    case PBS_1_25X = "1.25"
    case PBS_1_5X  = "1.5"

}

class VODDataLocal: NSObject{
    
    static var playBackSpeed: [VODPlaySpeed] = [VODPlaySpeed.init(title: "0.5x",
                                                                  dataType: .PBS_0_5X,
                                                                  checkmark: false),
                                                VODPlaySpeed.init(title: "0.75x",
                                                                  dataType: .PBS_0_75X,
                                                                  checkmark: false),

                                                VODPlaySpeed.init(title: "Normal",
                                                                  dataType: .PBS_1_0X,
                                                                  checkmark: true),

                                                VODPlaySpeed.init(title: "1.25x",
                                                                  dataType: .PBS_1_25X,
                                                                  checkmark: false),
                                                VODPlaySpeed.init(title: "1.5x",
                                                                  dataType: .PBS_1_5X,
                                                                  checkmark: false)]
    
    // To get play back speed with auto translate lang
    static func getPlayBackSpeed() -> [VODPlaySpeed] {
        var backSpeed: [VODPlaySpeed] = playBackSpeed
        if let i = playBackSpeed.firstIndex(where: {$0.dataType == .PBS_1_0X}) {
            backSpeed[i].title = "Normal"
        }
        return backSpeed
    }
    
    static var playPlayList: [VODPlayList] = []
    
    static var playSubtile: [VODSubtitleLanguages] = []
}
