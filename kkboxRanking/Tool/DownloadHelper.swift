//
//  DownloadHelper.swift
//  kkboxRanking
//
//  Created by 黃柏嘉 on 2023/5/28.
//

import Foundation

enum DownloadType {
    case none
    case fetchApi
    case downloadImage
}

class DownloadHelper{
    
    static let shared = DownloadHelper()
    
    private let apikey = "keyuuszf5krfcrpdZ"
    
    func download(URL:URL?,type:DownloadType,completion:@escaping (Result<Data,Error>)->()){
        guard let url = URL else { return }
        var request = URLRequest(url: url)
        
        switch type{
        case .none:
            return
        case .fetchApi:
            request.httpMethod = "GET"
            request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        case .downloadImage:
            break
        }
        
        URLSession.shared.dataTask(with: request) { data,_,error in
            if let data = data {
                completion(.success(data))
            }
            else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}
