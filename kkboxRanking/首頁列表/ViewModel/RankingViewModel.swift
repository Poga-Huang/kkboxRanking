//
//  RankingViewModel.swift
//  kkboxRanking
//
//  Created by 黃柏嘉 on 2023/5/28.
//

import UIKit
import Combine

class RankingViewModel{
    
    //儲存所有綁訂
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var loading :Bool = true
    @Published var sections = [Section]()
    @Published var currentSelectedType:SectionType = .Chinese
    @Published var selectedFunctionFromIndexPath:FunctionIndex?
    
    init(){
        setupBinding()
    }
    
    
    private func setupBinding(){
        $loading.sink { loading in
            if loading{
                self.cleanAllData()
                self.fetchAPIData()
            }
        }.store(in: &subscriptions)
        
    }
    
    private func cleanAllData(){
        sections.removeAll()
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
        
        var sectionBox = [Section]()
        
        SectionType.allCases.enumerated().forEach { (index,type) in
            
            let section = Section(type: type, items: [SongCellViewModel]())
            
            data.records.forEach { record in
                if record.fields.SongType == type.typeName{
                    let row = (record.fields.Rank as NSString).integerValue - 1
                    
                    section.items.append(SongCellViewModel(from: self,data: record,indexPath: IndexPath(row:row, section: index)))
                }
            }
            sectionBox.append(section)
        }
        
        sections = sectionBox
        loading = false
    }
    
}
