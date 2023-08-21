//
//  CreditViewController.swift
//  Media Project
//
//  Created by 마르 on 2023/08/12.
//

import UIKit
import SwiftyJSON
import Alamofire
import Kingfisher

struct cast {
    let originName: String
    let character: String
    let image: String
}

class CreditViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentTextView: UITextView!
    @IBOutlet var posterImage: UIImageView!
    
    @IBOutlet var tableView: UITableView!
    
    var movie: Movie = Movie(title: " ", releaseDate: " ", poster: " ", rate: " ", overview: " ", id: " ", originalTitle: " ", genres: [])
    var castList: [cast] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        setMovieInfo()
        
        callCreditRequest(id: movie.id )
    }
    
    func setMovieInfo() {
        let posterUrl = "https://image.tmdb.org/t/p/w500"+movie.poster
        if let url = URL(string: posterUrl){
            posterImage.kf.setImage(with: url)
        }
        
        titleLabel.text = movie.title
        titleLabel.backgroundColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 15)
        
        contentTextView.text = movie.overview
        contentTextView.isEditable = false
    }
    
    func callCreditRequest(id: String) {
        let url = "https://api.themoviedb.org/3/movie/\(id)/credits?api_key=\(APIKey.tmdb_accept)"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                for i in 0...json["cast"].count-1 {
                    let origin = json["cast"][i]["original_name"].stringValue
                    let character = json["cast"][i]["character"].stringValue
                    let image = json["cast"][i]["profile_path"].stringValue
                    
                    let actor = cast(originName: origin, character: character, image: image)
                    self.castList.append(actor)
                }
                self.tableView.reloadData()
                //print(self.castList)
                
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension CreditViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return castList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CreditTableViewCell.identifier) as! CreditTableViewCell
        
        let profileUrl = "https://image.tmdb.org/t/p/w500"+castList[indexPath.row].image
        if let url = URL(string: profileUrl) {
            cell.profileImage.kf.setImage(with: url)
        }
        
        cell.name.text = castList[indexPath.row].originName
        
        cell.roleName.text = castList[indexPath.row].character
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
