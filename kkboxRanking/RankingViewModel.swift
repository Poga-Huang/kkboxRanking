//
//  RankingViewModel.swift
//  kkboxRanking
//
//  Created by 黃柏嘉 on 2023/5/28.
//

import Foundation
import Combine

class RankingViewModel{
    
    //儲存所有綁訂
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var loading :Bool = true
    @Published var covertDataEnd:Bool = false
    
    var chineseVM = [SongCellViewModel]()
    var englishVM = [SongCellViewModel]()
    var japaneseVM = [SongCellViewModel]()
    var koreanVM = [SongCellViewModel]()
    var taiwaneseVM = [SongCellViewModel]()
     
    init(){
        setupBinding()
    }
    
    
    private func setupBinding(){
        $loading.sink { loading in
            if !loading{
                self.covertDataEnd = true
            }
            else{
                self.cleanAllData()
                self.fetchAPIData()
            }
        }.store(in: &subscriptions)
        
    }
    
    private func cleanAllData(){
        chineseVM.removeAll()
        englishVM.removeAll()
        japaneseVM.removeAll()
        koreanVM.removeAll()
        taiwaneseVM.removeAll()
    }
    
    private func fetchAPIData(){
        let url = URL(string: "https://api.airtable.com/v0/appTDdyNa7e93TDqq/kkboxRanking?sort[0][field]=SongType&sort[0][direction]=desc&sort[1][field]=Rank&sort[1][direction]=asc")
        DownloadHelper.shared.download(URL: url, type: .fetchApi) { result in
            switch result{
            case.success(let data):
                print("success")
                if let data = APIModel.apiDataHandler(data: data){
                    self.convertApiDataToTable(data: data)
                }
            case .failure(_):
                print("fail")
            }
        }
    }
    
    private func convertApiDataToTable(data:APIModel){
        
        SongType.allCases.forEach { type in
            data.records.forEach { record in
                if record.fields.SongType == type.rawValue{
                    switch type{
                    case .Chinese:
                        chineseVM.append(SongCellViewModel(data: record))
                    case .English:
                        englishVM.append(SongCellViewModel(data: record))
                    case .Japanese:
                        japaneseVM.append(SongCellViewModel(data: record))
                    case .Korean:
                        koreanVM.append(SongCellViewModel(data: record))
                    case .Taiwanese:
                        taiwaneseVM.append(SongCellViewModel(data: record))
                    }
                }
            }
        }
    
        loading = false
    }
    
}
