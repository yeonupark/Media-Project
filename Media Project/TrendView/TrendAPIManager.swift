//
//  TrendAPIManager.swift
//  Media Project
//
//  Created by 마르 on 2023/08/18.
//

import Foundation
import Alamofire

class TrendAPIManager {
    static let shared = TrendAPIManager()
    
    private init() {}
    
    func callRequest(completionHandler: @escaping (Trending) -> Void) {
        
        let url = "https://api.themoviedb.org/3/trending/movie/day?api_key=\(APIKey.tmdb_accept)"
        
        AF.request(url, method: .get).validate()
            .responseDecodable(of: Trending.self) { response in
                guard let value = response.value else {
                    print(response)
                    return }
                
                completionHandler(value)
        }
    }
}
