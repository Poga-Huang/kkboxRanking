//
//  Section.swift
//  kkboxRanking
//
//  Created by 黃柏嘉 on 2023/6/4.
//

import Foundation

class Section:Hashable{
    
    //Hashable處理
    static func == (lhs: Section, rhs: Section) -> Bool {
        return lhs.type == rhs.type && lhs.items == rhs.items
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(items)
    }
    
    var type:SectionType
    var items:[SongCellViewModel]
    
    init(type: SectionType, items: [SongCellViewModel]) {
        self.type = type
        self.items = items
    }
}
