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
    let overview: String
    let id: String
    
    let genres: [JSON]
}

class TrendViewController: UIViewController {
    
    @IBOutlet var trendTableView: UITableView!
    var movies: [Movie] = []
    
    var genre_dict: [[String: String]] = []
    
    override func viewDidLoad() {
        
        let nib = UINib(nibName: TrendTableViewCell.identifier, bundle: nil)
        trendTableView.register(nib, forCellReuseIdentifier: TrendTableViewCell.identifier)
        
        super.viewDidLoad()
        trendTableView.delegate = self
        trendTableView.dataSource = self
        trendTableView.rowHeight = 200
        
        getGenre()
        callRequest()
        
    }
    
    func callRequest() {
        
        let url = "https://api.themoviedb.org/3/trending/movie/day?api_key=\(APIKey.tmdb_accept)"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                for i in 0...json["results"].count-1 {
                    let title = json["results"][i]["title"].stringValue
                    let releaseDate = json["results"][i]["release_date"].stringValue
                    let poster = json["results"][i]["poster_path"].stringValue
                    let rate = json["results"][i]["vote_average"].stringValue
                    let overview = json["results"][i]["overview"].stringValue
                    let id = json["results"][i]["id"].stringValue
                    let genre_ids = json["results"][i]["genre_ids"].arrayValue
                    
                    let movie = Movie(title: title, releaseDate: releaseDate, poster: poster, rate: rate, overview: overview, id: id, genres: genre_ids)
                    
                    self.movies.append(movie)
                    
                }
                self.trendTableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getGenre()  {
        let url = "https://api.themoviedb.org/3/genre/movie/list?api_key=\(APIKey.tmdb_accept)"

        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                for genre in json["genres"] {
                    let id = genre.1["id"].stringValue
                    let name = genre.1["name"].stringValue
                    
                    let arr = ["id": id, "name": name]
                    self.genre_dict.append(arr)
                }
                
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
        cell.rateLabel?.text = "★ " + String(movies[indexPath.row].rate.prefix(3))
        let genres = translateGenre(movies[indexPath.row].genres)
        cell.genreLabel?.text = genres
        
        let posterUrl = "https://image.tmdb.org/t/p/w500"+movies[indexPath.row].poster
        if let url = URL(string: posterUrl){
            cell.posterImage.kf.setImage(with: url)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: CreditViewController.identifier) as! CreditViewController
        
        vc.image = movies[indexPath.row].poster
        vc.movieTitle = movies[indexPath.row].title
        vc.content = movies[indexPath.row].overview
        vc.id = movies[indexPath.row].id
        
        present(vc, animated: true)
        //navigationController?.pushViewController(vc, animated: true)
    }
    
    func translateGenre(_ genre_ids: [JSON]) -> String {
        var genre_sentence = ""
        for id in genre_ids {
            let string_id = id.stringValue
            for genre in genre_dict {
                if genre["id"] == string_id {
                    if let name = genre["name"] {
                        genre_sentence += "#\(name) "
                    }
                    
                }
            }
        }
        return genre_sentence
    }
}
