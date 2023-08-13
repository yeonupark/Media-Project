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
    
    let genres: [String]
}

class TrendViewController: UIViewController {
    
    @IBOutlet var trendTableView: UITableView!
    var movies: [Movie] = []
    //var genreList: [String] = []
    
    override func viewDidLoad() {
        
        let nib = UINib(nibName: TrendTableViewCell.identifier, bundle: nil)
        trendTableView.register(nib, forCellReuseIdentifier: TrendTableViewCell.identifier)
        
        super.viewDidLoad()
        trendTableView.delegate = self
        trendTableView.dataSource = self
        trendTableView.rowHeight = 200
        
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
                    
                    var genres: [String] = []
                    for id in genre_ids {
                        let string_id = id.stringValue
                        genres.append(self.getGenre(string_id))
                    }
                    
                    let movie = Movie(title: title, releaseDate: releaseDate, poster: poster, rate: rate, overview: overview, id: id, genres: genres)
                    
                    self.movies.append(movie)
                    
                }
                self.trendTableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getGenre(_ id: String) -> String {
        let url = "https://api.themoviedb.org/3/genre/movie/list?api_key=\(APIKey.tmdb_accept)"
        //var genreList: [String] = []
        var movieGenre = ""
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)

                for genre in json["genres"] {
                    if genre.1["id"].stringValue == id {
                        movieGenre = genre.1["name"].stringValue
                    }
                }
                print(movieGenre)
                //self.trendTableView.reloadData()


            case .failure(let error):
                print(error)
            }
            
        }
        return movieGenre
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
        //let genres = movies[indexPath.row].genres
        //print(genres)
        //cell.genreLabel?.text = genres[0]
        
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

}
