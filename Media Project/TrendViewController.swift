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
    
    let genres: [Int]
}

class TrendViewController: UIViewController {
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var trendTableView: UITableView!
    
    var movies: [Movie] = []
    var trendMovies: [Movie] = []
    var similarMovies: [Movie] = []
    
    var genre_dict: [[String: String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: TrendTableViewCell.identifier, bundle: nil)
        trendTableView.register(nib, forCellReuseIdentifier: TrendTableViewCell.identifier)
        
        trendTableView.delegate = self
        trendTableView.dataSource = self
        trendTableView.rowHeight = 200
        
        setSegmentedControl()
        getGenre()
        dispatchGroup()
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
                
                let movie = Movie(title: title, releaseDate: releaseDate, poster: poster, rate: rate, overview: overview, id: id, genres: genre_ids)
                self.trendMovies.append(movie)
            }
            group.leave()
        }
        
        group.enter()
        SimilarAPIManager.shared.callSimilarRequest(13) { data in
            for result in data.results {
                let title = result.title
                let releaseDate = result.releaseDate
                let poster = result.posterPath
                let rate = String(result.voteAverage)
                let overview = result.overview
                let id = String(result.id)
                let genre_ids = result.genreIDS
                
                let movie = Movie(title: title, releaseDate: releaseDate, poster: poster, rate: rate, overview: overview, id: id, genres: genre_ids)
                self.similarMovies.append(movie)
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.movies = self.trendMovies //
            self.trendTableView.reloadData()
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
    
    func setSegmentedControl() {
        segmentedControl.setTitle("실시간 인기 컨텐츠", forSegmentAt: 0)
        segmentedControl.setTitle("유사한 컨텐츠", forSegmentAt: 1)
        segmentedControl.backgroundColor = .systemPink
    }
    
    @IBAction func switchViews(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            movies = trendMovies
            trendTableView.reloadData()
            
        } else {
            movies = similarMovies
            trendTableView.reloadData()
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
//        let show = segmentedControl.selectedSegmentIndex
//        let movies = show == 0 ? trendMovies : similarMovies
        
        let vc = storyboard?.instantiateViewController(withIdentifier: CreditViewController.identifier) as! CreditViewController
        
        vc.image = movies[indexPath.row].poster
        vc.movieTitle = movies[indexPath.row].title
        vc.content = movies[indexPath.row].overview
        vc.id = movies[indexPath.row].id
        
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
