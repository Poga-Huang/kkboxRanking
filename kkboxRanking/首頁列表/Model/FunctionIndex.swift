//
//  FunctionIndex.swift
//  kkboxRanking
//
//  Created by 黃柏嘉 on 2023/6/17.
//

import Foundation

class FunctionIndex {
    var type:FunctionType?
    var index:IndexPath?
    
    init(type: FunctionType? = nil, index: IndexPath? = nil) {
        self.type = type
        self.index = index
    }
    
}
