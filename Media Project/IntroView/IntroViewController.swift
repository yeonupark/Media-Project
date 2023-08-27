//
//  IntroViewController.swift
//  Media Project
//
//  Created by 마르 on 2023/08/27.
//

import UIKit
import SnapKit

class FirstViewController: UIViewController {
    
    let welcome = {
        let view = UILabel()
        view.text = "TMDB PROJECT"
        view.font = .boldSystemFont(ofSize: 30)
        view.textColor = .black
        
        return view
    }()
    
    let subText = {
        let view = UILabel()
        view.text = "영화의 모든 것"
        view.font = .boldSystemFont(ofSize: 20)
        view.textColor = .systemPink
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(welcome)
        view.addSubview(subText)
        
        welcome.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(50)
        }
        
        subText.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(welcome.snp.bottom)
            make.height.equalTo(50)
        }
    }
}

class SecondViewController: UIViewController {
    
    let welcome = {
        let view = UILabel()
        view.text = "실시간 인기 영화 정보를 확인해보세요"
        view.font = .boldSystemFont(ofSize: 20)
        view.textColor = .black
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(welcome)
        
        welcome.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(50)
        }
    }
}

class ThirdViewController: UIViewController {
    
    let welcome = {
        let view = UILabel()
        view.text = "나의 인생 영화와 유사한 영화를 추천해드려요"
        view.font = .boldSystemFont(ofSize: 20)
        view.textColor = .black
        
        return view
    }()
    
    let button = {
        let view = UIButton()
        view.setTitle("시작하기", for: .normal)
        view.setTitleColor(UIColor.systemPink, for: .normal)
        view.tintColor = .systemPink
        view.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(welcome)
        view.addSubview(button)
        
        welcome.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(50)
        }
        
        button.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.top.equalTo(welcome.snp.bottom).offset(50)
        }
        
        button.addTarget(self, action: #selector(start), for: .touchUpInside)
    }
    
    @objc func start() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: TrendViewController.identifier)
        
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

class IntroViewController: UIPageViewController {
    
    var list: [UIViewController] = []
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        list = [FirstViewController(), SecondViewController(), ThirdViewController()]
        
        delegate = self
        dataSource = self
        
        guard let first = list.first else { return }
        setViewControllers([first], direction: .forward, animated: true) //
        
    }
}

extension IntroViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = list.firstIndex(of: viewController) else { return nil }
        let previousIndex = currentIndex - 1
        
        return previousIndex < 0 ? nil : list[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = list.firstIndex(of: viewController) else { return nil }
        let nextIndex = currentIndex + 1
        
        return nextIndex >= list.count ? nil : list[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return list.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let first = viewControllers?.first, let index = list.firstIndex(of: first) else { return 0 }
        return index
    }
}
