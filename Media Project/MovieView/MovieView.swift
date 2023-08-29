//
//  TrendView.swift
//  Media Project
//
//  Created by 마르 on 2023/08/28.
//

import UIKit

struct Movie {
    let title: String
    let releaseDate: String
    let poster: String
    let rate: String
    let overview: String
    let id: String
    let originalTitle: String
    
    let genres: [Int]
}

class MovieView: BaseView {

    let profileButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "person.circle"), for: .normal)
        view.tintColor = .systemPink
        
        return view
    }()
    
    let segmentedControl = {
        let view = UISegmentedControl(items: ["실시간 인기 컨텐츠", "유사한 컨텐츠"])
        view.backgroundColor = .systemPink
        view.selectedSegmentIndex = 0
        
        return view
    }()
    
    let trendTableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieTableViewCell")
        
        return view
    }()
    
    override func configureView() {
        addSubview(segmentedControl)
        addSubview(profileButton)
        addSubview(trendTableView)
        trendTableView.rowHeight = 200
    }
    
    override func setConstraints() {
        segmentedControl.snp.makeConstraints { make in
            make.leading.top.equalTo(self.safeAreaLayoutGuide)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(60)
        }
        profileButton.snp.makeConstraints { make in
            make.leading.equalTo(segmentedControl.snp.trailing)
            make.top.trailing.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(segmentedControl.snp.bottom)
        }
        trendTableView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalTo(segmentedControl.snp.bottom)
        }
    }
}
