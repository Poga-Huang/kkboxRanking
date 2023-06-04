//
//  APIModel.swift
//  kkboxRanking
//
//  Created by 黃柏嘉 on 2023/5/28.
//

import Foundation

enum SongType:String,CaseIterable{
    case Chinese = "華語"
    case English = "西洋"
    case Japanese = "日語"
    case Korean = "韓語"
    case Taiwanese = "台語"
}

struct APIModel:Codable,Hashable{
    var records:[Records]
    struct Records:Codable,Hashable{
        var fields:Fields
        struct Fields:Codable,Hashable{
            var SongName:String
            var Rank:String
            var Singer:String
            var ReleaseDate:String
            var SongType:String
            var Lyrics:String
            var MusicVideoURL:String?
            var CoverImage:[CoverImage]
            struct CoverImage:Codable,Hashable{
                var url:String
            }
        }
    }
    //Get JSON Data
    static func apiDataHandler(data:Data)->APIModel?{
        do{
            let result = try JSONDecoder().decode(APIModel.self, from: data)
            
            return result
        }
        catch{
            return nil
        }
    }
    
}
