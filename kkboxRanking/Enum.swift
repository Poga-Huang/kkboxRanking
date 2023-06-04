//
//  Enum.swift
//  kkboxRanking
//
//  Created by 黃柏嘉 on 2023/6/4.
//

import Foundation

enum SectionType:Int,CaseIterable{
    case Chinese = 0
    case English = 1
    case Japanese = 2
    case Korean = 3
    case Taiwanese = 4
    
    var typeName:String{
        switch self {
        case .Chinese:
            return "華語"
        case .English:
            return "西洋"
        case .Japanese:
            return "日語"
        case .Korean:
            return "韓語"
        case .Taiwanese:
            return "台語"
        }
    }
    
    var headerTitle:String{
        return self.typeName + "年度單曲累積榜"
    }
}

enum FunctionType:String{
    case PlayMusic = "音樂播放"
    case PlayMusicVideo = "MV播放"
}
