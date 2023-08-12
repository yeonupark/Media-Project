//
//  TrendViewController.swift
//  Media Project
//
//  Created by 마르 on 2023/08/12.
//

import UIKit
import SwiftyJSON
import Alamofire
import Kingfisher

struct Movie {
    let title: String
    let releaseDate: String
    let poster: String
    let rate: String
}

class TrendViewController: UIViewController {
    
    @IBOutlet var trendTableView: UITableView!
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        
        let nib = UINib(nibName: TrendTableViewCell.identifier, bundle: nil)
        trendTableView.register(nib, forCellReuseIdentifier: TrendTableViewCell.identifier)
        
        super.viewDidLoad()
        trendTableView.delegate = self
        trendTableView.dataSource = self
        trendTableView.rowHeight = 180
        
        callRequest()
        
    }
    
    func callRequest() {
        
        let url = "https://api.themoviedb.org/3/trending/movie/day?api_key=\(APIKey.tmdb_accept)"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //print("JSON: \(json)")
                
                for i in 0...json["results"].count-1 {
                    let title = json["results"][i]["title"].stringValue
                    let releaseDate = json["results"][i]["release_date"].stringValue
                    let poster = json["results"][i]["poster_path"].stringValue
                    let rate = json["results"][i]["vote_average"].stringValue
                    
                    let movie = Movie(title: title, releaseDate: releaseDate, poster: poster, rate: rate)
                    self.movies.append(movie)
                }
                self.trendTableView.reloadData()
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
    
extension TrendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = trendTableView.dequeueReusableCell(withIdentifier: TrendTableViewCell.identifier) as! TrendTableViewCell

        cell.titleLabel?.text = movies[indexPath.row].title
        cell.dateLabel?.text = String(movies[indexPath.row].releaseDate.prefix(4))
        cell.rateLabel?.text = String(movies[indexPath.row].rate.prefix(3))

        if let url = URL(string: movies[indexPath.row].poster){
            cell.posterImage.kf.setImage(with: url)
        }
        
        return cell
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }

}
