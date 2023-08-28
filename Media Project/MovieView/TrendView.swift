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

class TrendView: BaseView {

    let segmentedControl = {
        let view = UISegmentedControl(items: ["실시간 인기 컨텐츠", "유사한 컨텐츠"])
        view.backgroundColor = .systemPink
        view.selectedSegmentIndex = 0
        
        return view
    }()
    
    let trendTableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.register(TrendingTableViewCell.self, forCellReuseIdentifier: "TrendingTableViewCell")
        
        return view
    }()
    
    override func configureView() {
        addSubview(segmentedControl)
        addSubview(trendTableView)
        trendTableView.rowHeight = 200
    }
    
    override func setConstraints() {
        segmentedControl.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(self.safeAreaLayoutGuide)
        }
        trendTableView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalTo(segmentedControl.snp.bottom)
        }
    }
}
