//
//  File.swift
//  Media Project
//
//  Created by 마르 on 2023/08/18.
//

import UIKit
import Alamofire

class SimilarAPIManager {
    static let shared = SimilarAPIManager()
    
    private init() {}
    
    func callSimilarRequest(_ movieID: Int, completionHandler: @escaping (Similar) -> Void) {
        
        let url = "https://api.themoviedb.org/3/movie/\(movieID)/similar?api_key=\(APIKey.tmdb_accept)"
        
        AF.request(url, method: .get).validate(statusCode: 200...500)
            .responseDecodable(of: Similar.self) { response in
                guard let value = response.value else {
                    print(response)
                    return }
                
                completionHandler(value)
        }
    }
    
}
