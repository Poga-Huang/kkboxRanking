//
//  SongCellViewModel.swift
//  kkboxRanking
//
//  Created by 黃柏嘉 on 2023/5/28.
//

import UIKit
import Combine

class SongCellViewModel:Hashable{
    
    //Hashable處理
    static func == (lhs: SongCellViewModel, rhs: SongCellViewModel) -> Bool {
        return lhs.data == rhs.data
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(data)
    }
    //儲存所有綁訂
    private var subscriptions = Set<AnyCancellable>()
    
    var data:APIModel.Records
    let indexPath:IndexPath
    let viewModel:RankingViewModel
    
    @Published var clickFunctionType:FunctionType?
    @Published var coverImage:UIImage?
    
    init(from viewModel:RankingViewModel ,data: APIModel.Records,indexPath:IndexPath) {
        self.data = data
        self.indexPath = indexPath
        self.viewModel = viewModel
        setupBinding()
    }
    
    private func setupBinding() {
        /*
        監聽到Cell改變了點擊的功能類別
         將當前的indexPath與type塞給來源的ViewModel
         讓ViewModel通知VC Push畫面
        */
        $clickFunctionType
            .sink { [weak self] type in
            guard let self = self, let type = type else { return }
            
                viewModel.selectedFunctionFromIndexPath = FunctionIndex(type: type,index: self.indexPath)
            }.store(in: &subscriptions)
    }
    
    func getImage(){
        //儲存圖片，下次能取得圖片就無需重新下載
        let tempDirectory = FileManager.default.temporaryDirectory
        let imageFileURL = tempDirectory.appendingPathComponent(data.fields.WholeSongName)
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
