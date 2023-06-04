//
//  SongCellViewModel.swift
//  kkboxRanking
//
//  Created by 黃柏嘉 on 2023/5/28.
//

import UIKit

class SongCellViewModel:Hashable{
    
    //Hashable處理
    static func == (lhs: SongCellViewModel, rhs: SongCellViewModel) -> Bool {
        return lhs.data == rhs.data
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(data)
    }
    
    var data:APIModel.Records
    @Published var coverImage:UIImage?
    
    init(data: APIModel.Records) {
        self.data = data
    }
    
    func getImage(){
        //儲存圖片，下次能取得圖片就無需重新下載
        let tempDirectory = FileManager.default.temporaryDirectory
        let imageFileURL = tempDirectory.appendingPathComponent(data.fields.SongName)
        if FileManager.default.fileExists(atPath: imageFileURL.path){
            let image = UIImage(contentsOfFile: imageFileURL.path)
            self.coverImage = image
        }else{
            if let imageURL = URL(string: data.fields.CoverImage[0].url) {
                DownloadHelper.shared.download(URL: imageURL, type: .downloadImage) { result in
                    switch result{
                    case.success(let data):
                        self.coverImage = UIImage(data: data)
                        try? data.write(to: imageFileURL)
                    case.failure(_):
                        self.coverImage = nil
                    }
                }
            }
        }
    }
    
}
