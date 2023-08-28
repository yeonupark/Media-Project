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

class TrendViewController: BaseViewController {
    
    let mainView = TrendView()
    
    var movies: [Movie] = []
    var trendMovies: [Movie] = []
    var similarMovies: [Movie] = []
    var genre_dict: [[String: String]] = []
    
    override func loadView() {
        view.self = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mainView.trendTableView.delegate = self
        mainView.trendTableView.dataSource = self
        
        mainView.segmentedControl.addTarget(self, action: #selector(switchViews), for: .valueChanged)

        getGenre()
        dispatchGroup()
        UserDefaults.standard.set(true, forKey: "isLaunched")
    }
    
    func dispatchGroup() {
        
        let group = DispatchGroup()
        
        group.enter()
        TrendAPIManager.shared.callRequest { data in
            
            for result in data.results {
                let title = result.title
                let releaseDate = result.releaseDate
                let poster = result.posterPath
                let rate = String(result.voteAverage)
                let overview = result.overview
                let id = String(result.id)
                let genre_ids = result.genreIDS
                let originalTitle = result.originalTitle
                
                let movie = Movie(title: title, releaseDate: releaseDate, poster: poster, rate: rate, overview: overview, id: id, originalTitle: originalTitle, genres: genre_ids)
                self.trendMovies.append(movie)
            }
            group.leave()
        }
        
        group.enter()
        SimilarAPIManager.shared.callSimilarRequest(13) { data in
            for result in data.results {
                let title = result.title
                let releaseDate = result.releaseDate
                let rate = String(result.voteAverage)
                let overview = result.overview
                let id = String(result.id)
                let genre_ids = result.genreIDS
                let poster = result.posterPath
                let originalTitle = result.originalTitle

                let movie = Movie(title: title, releaseDate: releaseDate, poster: poster ?? "" , rate: rate, overview: overview, id: id, originalTitle: originalTitle, genres: genre_ids)
                self.similarMovies.append(movie)
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.movies = self.trendMovies //
            self.mainView.trendTableView.reloadData()
            print("end")
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
    
    @objc func switchViews(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            movies = trendMovies
            mainView.trendTableView.reloadData()
            
        } else {
            movies = similarMovies
            mainView.trendTableView.reloadData()
        }
    }
}
    
extension TrendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = mainView.trendTableView.dequeueReusableCell(withIdentifier: TrendingTableViewCell.identifier) as? TrendingTableViewCell else {
            print("ㅜㅜ")
            return UITableViewCell()}
        
        let movie = movies[indexPath.row]
        cell.titleLabel.text = movie.title
        cell.originalTitleLabel.text = " " + movie.originalTitle
        cell.dateLabel.text = String(movie.releaseDate.prefix(4))
        cell.rateLabel.text = "★ " + String(movie.rate.prefix(3))
        let genres = translateGenre(movie.genres)
        cell.genreLabel.text = genres
        
        let posterUrl = "https://image.tmdb.org/t/p/w500"+movie.poster
        if let url = URL(string: posterUrl){
            cell.posterImage.kf.setImage(with: url)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = CreditViewController()
        vc.movie = movies[indexPath.row]
        present(vc, animated: true)
    }
    
    func translateGenre(_ genre_ids: [Int]) -> String {
        var genre_sentence = ""
        for id in genre_ids {
            let string_id = String(id)
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
